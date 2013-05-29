# jQuery extensions

# Internal functions
handleSetTimeout = (callback) ->
  id = setTimeout =>
    clearTimeout id
    callback.apply @
  , 200


# Extend jQuery functions
$.extend

  # Preload an array of URLs by DOM `<img>` insertion
  preloadByDOM: (items) ->
    promises = []

    request = (url, promise) ->
      handleError = (ev) ->
        $(@).remove()
        promise.reject url

      handleLoad = (ev) ->
        $(@).remove()
        promise.notify url
        promise.resolve url

      $('<img/>')
      .attr('src', url)
      .on('error', handleError)
      .on('abort', handleError)
      .on('load', handleLoad)

    for item in items
      deferred = $.Deferred()
      promises.push deferred
      request item, deferred

    return promises


  # Preload an array of URLs by XHR
  preloadByXHR: (items) ->
    promises = []

    request = (url, promise) ->
      $.ajax
        type: 'GET'
        url: url
        error: promise.reject
        success: (data, textStatus, jqXHR) ->
          promise.notify url
          promise.resolve data

    for item in items
      deferred = $.Deferred()
      promises.push deferred
      request item, deferred

    return promises


# Extend jQuery selector methods
$.fn.extend

  # Fire up `animationend` event even if UA doesn't support it
  onAnimationend: (callback) ->
    return handleSetTimeout.call @, callback unless Modernizr.cssanimations
    $(@).on 'animationend webkitAnimationEnd oanimationend MSAnimationEnd', callback

  oneAnimationend: (callback) ->
    return handleSetTimeout.call @, callback unless Modernizr.cssanimations
    $(@).on 'animationend webkitAnimationEnd oanimationend MSAnimationEnd', callback
