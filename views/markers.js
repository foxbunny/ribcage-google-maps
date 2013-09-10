// Generated by CoffeeScript 1.6.3
var define;

define = (function(root) {
  var require;
  if (typeof root.define === 'function' && root.define.amd) {
    return define;
  } else {
    require = function(dep) {
      return (function() {
        switch (dep) {
          case 'ribcage/views/base':
            return root.ribcage.views.baseView;
          case './marker':
            return root.ribcageGoogleMaps.views.markerView;
          default:
            return null;
        }
      })() || (function() {
        throw new Error("Unmet dependency " + dep);
      })();
    };
    return function(factory) {
      var module;
      module = factory(require);
      root.ribcageGoogleMaps.views.markersView = module;
      root.ribcageGoogleMaps.views.MarkersView = module.View;
      return root.ribcageGoogleMaps.viewMixins.MarkersView = module.mixin;
    };
  }
})(this);

define(function(require) {
  var BaseView, MarkerView, MarkersView, markersViewMixin;
  BaseView = require('ribcage/views/base').View;
  MarkerView = require('./marker').View;
  markersViewMixin = {
    initialize: function(_arg) {
      this.map = _arg.map;
      return this.collection.on('change', this.render, this);
    },
    markerView: MarkerView,
    getMarkerView: function(attributes) {
      return this.markerView;
    },
    childViews: [],
    render: function() {
      var m;
      this.remove();
      return this.childViews = (function() {
        var _i, _len, _ref, _results,
          _this = this;
        _ref = this.collection.models;
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          m = _ref[_i];
          _results.push((function(m) {
            var View, marker;
            View = _this.getMarkerView(m.toJSON());
            marker = new View({
              model: m,
              map: _this.map,
              others: _this
            });
            marker.render();
            return marker;
          })(m));
        }
        return _results;
      }).call(this);
    },
    remove: function() {
      var view, _i, _len, _ref;
      _ref = this.childViews;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        view = _ref[_i];
        view.remove();
      }
      return this.childViews = [];
    }
  };
  MarkersView = BaseView.extend(markersViewMixin);
  return {
    mixin: markersViewMixin,
    View: MarkersView
  };
});
