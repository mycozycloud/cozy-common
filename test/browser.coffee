exports.Browser = require("zombie").Browser


exports.Browser::isVisible = (selector) ->
    @evaluate "$('#{selector}').is(':visible')"
    
exports.Browser::length = (selector) ->
    @evaluate "$('#{selector}').length"

exports.Browser::click = (selector) ->
    @evaluate "$('#{selector}').click()"

exports.Browser::hasClass = (selector, className) ->
    @evaluate "$('#{selector}').hasClass('#{className}')"

exports.Browser::keyUp = (selector) ->
    @evaluate "$('#{selector}').keyup()"

exports.Browser::html = (selector, value) ->
    if value?
        @evaluate "$('#{selector}').html('#{value}')"
    else
        @evaluate "$('#{selector}').html()"

exports.Browser::enterKeyUp = (selector) ->
    @evaluate "e = jQuery.Event('keyup')"
    @evaluate "e.which = 13"
    @evaluate "$('#{selector}').trigger(e)"

exports.Browser::keyup = (selector, keyCode, ctrlKey) ->
    @evaluate "e = jQuery.Event('keyup')"
    @evaluate "e.which = #{keyCode}"
    if ctrlKey?
        @evaluate "e.ctrlKey = true"
    @evaluate "$('#{selector}').trigger(e)"

exports.Browser::val = (selector) ->
    @evaluate "$('#{selector}').val()"

