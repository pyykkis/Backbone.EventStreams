(function() {
  var __slice = [].slice;

  Backbone.EventStream = {
    asEventStream: function() {
      var args, eventName, eventTarget, eventTransformer, listener, _ref, _ref1;
      args = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
      if (typeof args[0] === 'object') {
        _ref = args.concat([_.identity]), listener = _ref[0], eventName = _ref[1], eventTransformer = _ref[2];
      } else {
        _ref1 = args.concat([_.identity]), eventName = _ref1[0], eventTransformer = _ref1[1];
      }
      eventTarget = this;
      return new Bacon.EventStream(function(sink) {
        var handler, unbind;
        handler = function() {
          var args, reply;
          args = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
          reply = sink(new Bacon.Next(eventTransformer.apply(null, args)));
          if (reply === Bacon.noMore) {
            return unbind();
          }
        };
        if (listener) {
          unbind = function() {
            return listener.stopListening(eventTarget, eventName, handler);
          };
          listener.listenTo(eventTarget, eventName, handler);
        } else {
          unbind = function() {
            return eventTarget.off(eventName, handler);
          };
          eventTarget.on(eventName, handler, this);
        }
        return unbind;
      });
    }
  };

  _.extend(Backbone, Backbone.EventStream);

  _.extend(Backbone.Model.prototype, Backbone.EventStream);

  _.extend(Backbone.Collection.prototype, Backbone.EventStream);

  _.extend(Backbone.Router.prototype, Backbone.EventStream);

  _.extend(Backbone.History.prototype, Backbone.EventStream);

  _.extend(Backbone.View.prototype, Backbone.EventStream);

}).call(this);
