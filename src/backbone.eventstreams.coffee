Backbone.EventStream =
  asEventStream: (eventName, eventTransformer = _.identity) ->
    eventTarget = this
    new Bacon.EventStream (sink) ->
      handler = (args...) ->
        reply = sink(new Bacon.Next(eventTransformer args...))
        if reply == Bacon.noMore
          unbind()

      unbind = -> eventTarget.off(eventName, handler)
      eventTarget.on(eventName, handler, this)
      unbind

_.extend Backbone,                      Backbone.EventStream
_.extend Backbone.Model.prototype,      Backbone.EventStream
_.extend Backbone.Collection.prototype, Backbone.EventStream
_.extend Backbone.Router.prototype,     Backbone.EventStream
_.extend Backbone.History.prototype,    Backbone.EventStream
_.extend Backbone.View.prototype,       Backbone.EventStream
