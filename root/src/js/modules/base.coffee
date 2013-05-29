class Model extends Backbone.Model

  set: (attributes, options) =>
    options = {} unless options
    options.validate = true
    super attributes, options


class Collection extends Backbone.Collection


class View extends Backbone.View


class Router extends Backbone.Router


@Base =
  VERSION: Backbone.VERSION
  Model: Model
  Collection: Collection
  View: View
  Router: Router
