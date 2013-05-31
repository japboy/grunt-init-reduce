# Base classes for Backbone.js

class Model extends Backbone.Model

  set: (attributes, options) =>
    options = {} unless options
    options.validate = true
    super attributes, options

  fetch: (options) =>
    options = {} unless options
    options.crossDomain = true
    options.dataType = 'jsonp'
    options.jsonp = 'jsonp'
    super options


class Collection extends Backbone.Collection

  fetch: (options) =>
    options = {} unless options
    options.crossDomain = true
    options.dataType = 'jsonp'
    options.jsonp = 'jsonp'
    super options


class View extends Backbone.View


class Router extends Backbone.Router


@Base =
  VERSION: Backbone.VERSION
  Model: Model
  Collection: Collection
  View: View
  Router: Router
