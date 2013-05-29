# Base classes for Backbone.js

fetch = (options) ->
  options = {} unless options
  options.crossDomain = true
  options.dataType = 'jsonp'
  options.jsonp = 'jsonp'
  super options


class Model extends Backbone.Model

  set: (attributes, options) =>
    options = {} unless options
    options.validate = true
    super attributes, options

  fetch: fetch.apply @


class Collection extends Backbone.Collection

  fetch: fetch.apply @


class View extends Backbone.View


class Router extends Backbone.Router


@Base =
  VERSION: Backbone.VERSION
  Model: Model
  Collection: Collection
  View: View
  Router: Router
