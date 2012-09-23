slugify = require('../client/app/helpers').slugify

###
# The aim of this class is to have a representation of the tree on server side.
# The structure is close to what expect jstree on client side so that a simple
# serialization can send the tree to the client .
# All manipulations of the TreeData - creation renaming move delete update - 
# are done through the manipulation of Note
# Structure of the tree :
#       nodes : {"id_1":node_1, ... ,"id_n":node_n} hash table of all node. 
#           Ids are the same as notes ids. 
#           If you want to access to the node corresponding to a note : node = nodes[note_id]
#       root : ref to the root node. Initialised with the node "All"
# Structure of a node :
#       _parent  : parentNode reference
#       _id      : note.id
#       children : []
#       data     : note.title  => "data" corresponds to jstree requirements
#       attr     : {id:note.id}
# Methods :
#     addNode: (note, parentNoteID) ->
#         return newNode
###
class exports.DataTree


    ###
    # constructor (jsonStruct)
    #    jsonStruct : optionnal : a json sting that represents a DataTree. Used when
    #                 retrieving an existing tree from the DB.
    ###
    constructor: (jsonStruct) ->
        if jsonStruct
            @nodes       = {}
            @root        = JSON.parse(jsonStruct)
            @root._parent = null
            @_initWalk(@root)
        else
            @root =
                    _parent  : null
                    _id      : 'tree-node-all'
                    children : []
                    data     : 'All'
                    attr     : {id:'tree-node-all'}
            @nodes = {"tree-node-all":@root}


    ### 
    # Walks through the children of a node in order to init
    # add nodes to this.nodes
    # set the parent property of each node
    ###
    _initWalk: (node)->
        this.nodes[node._id]=node
        for n in node.children
            n._parent=node
            @_initWalk(n)


    ###
    # Add a node to the tree as the last son of the given parentNote
    # note : a instance of Note 
    ###
    addNode: (note, parentNoteID) ->
        # console.log '***** DataTree.addNode ('+note+", " + parentNoteID
        if !parentNoteID
            parentNoteID = 'tree-node-all'
        parentNode = @nodes[parentNoteID]
        newNode    =
            _parent  : parentNode
            _id      : note.id
            children : []
            data     : note.title
            attr     : {id:note.id}
        parentNode.children.push(newNode)
        @nodes[note.id] = newNode
        return newNode


    ###
    # updates the title of a node, wich corresponds to its "data" propertie.
    ###
    updateTitle: (noteId, newTitle) ->
        @nodes[noteId].data = newTitle


    ###
    # Move a node to a new parent
    ###
    moveNode: (noteId, newParentId) ->
        # var
        newParent   = @nodes[newParentId]
        node        = @nodes[noteId]
        parentChldn = node._parent.children # old parent children
        # remove from the children of its parent
        # for child, i in parentChldn
        #     if child._id == noteId
        #         parentChldn.splice(i,1)
        #         break

        i = 0
        while i < parentChldn.length
            c = parentChldn[i]
            if c._id == noteId
                parentChldn.splice(i,1)
                break
            i++
        # add to the children of its new parent
        newParent.children.push(node)
        node._parent = newParent


    ###
    # params :
    #     node : a reference to a node or the id of a node.
    ###
    getPath: (node)->
        if typeof node == "string"
            node = @nodes[node]
        path = []
        if node._parent != null
            path.unshift(node.data)
        while node._parent != null
            node = node._parent
            path.unshift(node.data)
        path.shift()
        return path


    ###
    # Retrieves all the paths of a note and its children
    # Returns an array : [{id:note_id,path:note_path}, ... ]
    # params :
    #     nodeid : a reference to a node or the id of a node.
    ###
    getPaths: (node) ->
        node = @nodes[node] if typeof(node) == "string"
        path = @getPath(node)
        list = [ { id: node._id, path: path } ]
        
        @_addChildrenPaths(node, path, list)

        return list

    _addChildrenPaths: (parent, parentPath, list) ->
        for child in parent.children
            
            path = parentPath.slice()
            path.push child.data
            list.push
                id: child._id
                path: path

            @_addChildrenPaths(child, path, list)


    ###*
     * Remove a note and all its children
     * Returns an array of the ids of the children removed nodes : [id_node_1, ... ]
     * @param  {node or id} node a reference to a node or the id of a node.
     * @return {[array]}        returns an array of ids of the removed children 
     *                          the initial node is not in the array.
    ###
    removeNode: (node) ->
        
        # vars
        if typeof node == "string"
            node = @nodes[node]
        list = []

        # remove all the children, ids will be stacked in list
        @_removeNode(node, list)
        
        # remove from the children of its parent
        parentChldn = node._parent.children # parent children array
        for child, i in parentChldn
            if child._id == node._id
                parentChldn.splice(i,1)
                break

        return list        

    _removeNode: (node, list) ->
        for c in node.children
            list.push c._id
            @_removeNode(c,list)
        delete @nodes[node._id]


    ###*
     * retrieves ALL children of a node (children of children etc...)
     * returns an array of ids : [id_child_1, ... ]
     * @param  {node or id} node a reference to a node or the id of a node.
     * @return {[array]}        returns an array of ids : [id_child_1, ... ]
    ###
    getAllChildrens: (node) ->
        if typeof node == "string"
            node = @nodes[node]
        list = []

        @_getAllChildren(node, list)
        return list        

    _getAllChildren: (node, list) ->
        for c in node.children
            list.push c._id
            @_addChildren(c,list)


    ###
    # Return a json string of the root for persistance in the database
    # _parent is filtered in ordered to avoid circular references.
    # The _initWalk method adds _parent and @nodes when the json is retrieved
    # from db.
    ###
    toJson: ()->
        filter = ->
            if arguments[0] == '_parent'
                return undefined
            else
                return arguments[1]
        return JSON.stringify(@root, filter)


    ###
    # Return a json string of the root for the jsTree of web client
    # properties with a name beginning by "_" are filtered
    ###
    toJsTreeJson: ->
        filter = ->
            if arguments[0].charAt(0) == '_'
                return undefined
            else
                return arguments[1]
        return JSON.stringify(@root, filter)

