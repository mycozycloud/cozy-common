exports.Browser = require("zombie").Browser


exports.Browser::isVisible = (selector) ->
    @evaluate "$('#{selector}').is(':visible')"
    
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
    @evaluate "$('#{selector}').trigger(e)"

exports.Browser::val = (selector) ->
    @evaluate "$('#{selector}').val()"
