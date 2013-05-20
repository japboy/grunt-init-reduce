'use strict'

preloads = [
  'http://lorempixel.com/1280/1280/'
]

promises = $.preloadByDOM preloads

handleProgress = (items...) ->

handleFail = (jqXHR, textStatus, errorThrown) ->

handleDone = (items...) ->
  $('#loader').addClass('animating')

$ ->
  console.log _.VERSION
  console.log Base.VERSION
  console.log 'Hello, index.'

  $('#loader').on 'animationend webkitAnimationEnd oanimationend MSAnimationEnd', ->
    $(@).remove()

  $.when.apply(@, promises)
    .progress(handleProgress)
    .fail(handleFail)
    .done(handleDone)
