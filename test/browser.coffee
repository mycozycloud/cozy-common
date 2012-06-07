exports.Browser = require("zombie").Browser


exports.Browser::isVisible = (selector) ->
    @evaluate "$('#{selector}').is(':visible')"
    
exports.Browser::length = (selector) ->
    @evaluate "$('#{selector}').length()"

exports.Browser::click = (selector) ->
    @evaluate "$('#{selector}').click()"

exports.Browser::hasClass = (selector, className) ->
    @evaluate "$('#{selector}').hasClass('#{className}')"

exports.Browser::keyUp = (selector) ->
    @evaluate "$('#{selector}').keyup()"

exports.Browser::html = (selector) ->
    @evaluate "$('#{selector}').html()"

exports.Browser::enterKeyUp = (selector) ->
    @evaluate "e = jQuery.Event('keyup')"
    @evaluate "e.which = 13"
    @evaluate "$('.jstree-rename-input').trigger(e)"
