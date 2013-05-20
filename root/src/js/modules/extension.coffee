$.extend
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
