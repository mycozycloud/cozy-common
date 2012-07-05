# Slugify given word, replace space with hyphens and removs non alphanumeric
# character.
exports.slugify = (string) ->
    _slugify_strip_re = /[^\w\s-]/g
    _slugify_hyphenate_re = /[-\s]+/g
    string = string.replace(_slugify_strip_re, '').trim().toLowerCase()
    string = string.replace _slugify_hyphenate_re, '-'
    string

# Transform in its regexp expression. Useful to retrieve path that starts
# with the given path.
exports.getPathRegExp = (path) ->
    slashReg = new RegExp "/", "g"
    "^#{path.replace(slashReg, "\/")}"
