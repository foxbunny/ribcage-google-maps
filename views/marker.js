// Generated by CoffeeScript 1.6.3
var define;

define = (function(root) {
  var require;
  if (typeof root.define === 'function' && root.define.amd) {
    return define;
  } else {
    require = function(dep) {
      return (function() {
        var _ref;
        switch (dep) {
          case 'ribcage/views/base':
            return root.ribcage.views.baseView;
          case '../gmaps':
            return (_ref = root.google) != null ? _ref.maps : void 0;
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
      root.ribcageGoogleMaps.views.markerView = module;
      root.ribcageGoogleMaps.views.MarkerView = module.View;
      return root.ribcageGoogleMaps.viewMixins.MarkerView = module.mixin;
    };
  }
})(this);

define(function(require) {
  var BaseView, MarkerView, maps, markerViewMixin;
  BaseView = require('ribcage/views/base').View;
  maps = require('../gmaps');
  markerViewMixin = {
    initialize: function(_arg) {
      this.map = _arg.map;
      return this.model.on('change', this.render, this);
    },
    markerShadow: false,
    markerAnimation: null,
    markerClickable: true,
    markerDraggable: false,
    markerIcon: null,
    markerShape: null,
    markerVisible: true,
    infoTemplateSource: '',
    infoTemplate: function(data) {
      return _.template(this.infoTemplateSource(data));
    },
    infoWindowAutoPan: true,
    infoWindowOffset: 0,
    createInfoWindow: function(data) {
      var cfg;
      cfg = {
        content: this.infoTemplate(data),
        disableAutoPan: !this.infoWindowAutoPan,
        maxWidth: this.infoWindowWidth,
        pixelOffset: this.infoWindowOffset
      };
      if (this.infoWindow != null) {
        this.infoWindow.setOptions(cfg);
        return this.infoWindow;
      } else {
        return new maps.InfoWindow(cfg);
      }
    },
    getMarkerAnim: function(v) {
      if (v == null) {
        return null;
      }
      return maps.Animation[v.toUpperCase()];
    },
    onClick: function() {
      if (this.infoWindow) {
        return this.infoWindow.open(this.map, this.marker);
      }
    },
    render: function() {
      var cfg, k,
        _this = this;
      cfg = {
        map: this.map,
        position: this.model.coords(),
        title: this.model.title,
        animation: this.getMarkerAnim(this.markerAimation),
        flat: !this.markerShadow,
        clickable: this.markerClickable,
        draggable: this.markerDraggable,
        icon: this.markerIcon,
        shape: this.markerShape,
        visible: this.markerVisible
      };
      if (this.marker != null) {
        this.marker.setOptions(cfg);
      } else {
        this.marker = new maps.Marker(cfg);
        maps.event.addListener(this.marker, 'click', function() {
          return _this.onClick();
        });
      }
      if ((this.model.info != null) && ((function() {
        var _results;
        _results = [];
        for (k in this.model.info) {
          _results.push(k);
        }
        return _results;
      }).call(this)).length) {
        return this.infoWindow = this.createInfoWindow(this.model.get('info'));
      } else {
        return this.infoWindow = null;
      }
    },
    show: function() {
      if (this.marker == null) {
        this.render();
      }
      return this.marker.setVisible(true);
    },
    hide: function() {
      if (!this.marker) {
        return;
      }
      return this.marker.setVisible(false);
    },
    remove: function() {
      var _ref;
      if (this.marker == null) {
        return;
      }
      maps.event.clearListeners(this.marker);
      this.marker.setMap(null);
      this.marker = null;
      if ((_ref = this.infoWindow) != null) {
        _ref.setMap(null);
      }
      return this.infoWindow = null;
    }
  };
  MarkerView = BaseView.extend(markerViewMixin);
  return {
    mixin: markerViewMixin,
    View: MarkerView
  };
});
