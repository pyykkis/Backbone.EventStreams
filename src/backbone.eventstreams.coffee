Backbone.EventStream =
  listenToEventStream: (eventTarget, eventName, eventTransformer = _.identity) ->
    listener = this
    new Bacon.EventStream (sink) ->
      handler = (args...) ->
        reply = sink(new Bacon.Next(eventTransformer args...))
        if reply == Bacon.noMore
          unbind()

      unbind = -> listener.stopListening(eventTarget, eventName, handler)
      listener.listenTo(eventTarget, eventName, handler)
      unbind

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

Backbone.BaconProperty =
  toModel: ->
    model = new Backbone.Model(this.take(1))
    handler = (value) ->
      model.set value
    this.onValue(handler)
    model
      

_.extend Bacon.Property.prototype,      Backbone.BaconProperty