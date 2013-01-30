Backbone.EventStream =
  asEventStream: (args...) ->
    if typeof args[0] == 'object'
      [listener, eventName, eventTransformer] = args.concat [_.identity]
    else
      [eventName, eventTransformer] = args.concat [_.identity]
    eventTarget = this
    new Bacon.EventStream (sink) ->
      handler = (args...) ->
        reply = sink(new Bacon.Next(eventTransformer args...))
        if reply == Bacon.noMore
          unbind()

      if listener
        unbind = -> listener.stopListening(eventTarget, eventName, handler)
        listener.listenTo(eventTarget, eventName, handler)
      else
        unbind = -> eventTarget.off(eventName, handler)
        eventTarget.on(eventName, handler, this)
      unbind

_.extend Backbone,                      Backbone.EventStream
_.extend Backbone.Model.prototype,      Backbone.EventStream
_.extend Backbone.Collection.prototype, Backbone.EventStream
_.extend Backbone.Router.prototype,     Backbone.EventStream
_.extend Backbone.History.prototype,    Backbone.EventStream
_.extend Backbone.View.prototype,       Backbone.EventStream
