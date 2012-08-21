# Slugify given word, replace space with hyphens and removs non alphanumeric
# character.
exports.slugify = require "./slug"

# Transform in its regexp expression. Useful to retrieve path that starts
# with the given path.
exports.getPathRegExp = (path) ->
    slashReg = new RegExp "/", "g"
    "^#{path.replace(slashReg, "\/")}"
