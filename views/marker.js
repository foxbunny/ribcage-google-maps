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
          case 'dahelpers':
            return root.dahelpers;
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
  var BaseView, MarkerView, empty, maps, markerViewMixin, type, _ref;
  _ref = require('dahelpers'), type = _ref.type, empty = _ref.empty;
  BaseView = require('ribcage/views/base').View;
  maps = require('../gmaps');
  markerViewMixin = {
    initialize: function(_arg) {
      this.map = _arg.map, this.others = _arg.others;
      return this.model.on('change', this.render, this);
    },
    markerShadow: false,
    markerAnimation: null,
    markerClickable: true,
    markerDraggable: false,
    markerIcon: null,
    markerShape: null,
    markerSize: null,
    markerOrigin: null,
    markerImageSize: null,
    markerAnchor: null,
    markerVisible: true,
    infoTemplateSource: '',
    infoTemplate: function(data) {
      return _.template(this.infoTemplateSource, data);
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
    getPoint: function(xy) {
      var x, y;
      if (empty(xy) || (xy == null)) {
        return null;
      }
      x = xy[0], y = xy[1];
      return new maps.Point(x, y);
    },
    getSize: function(xy) {
      var x, y;
      if (empty(xy) || (xy == null)) {
        return null;
      }
      x = xy[0], y = xy[1];
      return new maps.Size(x, y, 'px', 'px');
    },
    getMarkerIcon: function() {
      if (!type(this.markerIcon, 'string')) {
        return this.markerIcon;
      } else {
        return {
          anchor: this.getPoint(this.markerIconAnchor),
          origin: this.getPoint(this.markerOrigin),
          scaledSize: this.getSize(this.markerSize),
          size: this.getSize(this.markerImageSize),
          url: this.markerIcon
        };
      }
    },
    getMarkerAnim: function(v) {
      if (v == null) {
        return null;
      }
      return maps.Animation[v.toUpperCase()];
    },
    onClick: function() {
      if (this.infoWindow != null) {
        return this.infoWindow.open(this.map, this.marker);
      }
    },
    render: function() {
      var cfg, info, k,
        _this = this;
      cfg = {
        map: this.map,
        position: this.model.coords(),
        title: this.model.title,
        animation: this.getMarkerAnim(this.markerAimation),
        flat: !this.markerShadow,
        clickable: this.markerClickable,
        draggable: this.markerDraggable,
        icon: this.getMarkerIcon(),
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
      info = this.model.get('info');
      if ((info != null) && ((function() {
        var _results;
        _results = [];
        for (k in info) {
          _results.push(k);
        }
        return _results;
      })()).length) {
        this.infoWindow = this.createInfoWindow(info);
      } else {
        this.infoWindow = null;
      }
      return this;
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
      var _ref1;
      if (this.marker == null) {
        return;
      }
      maps.event.clearListeners(this.marker);
      this.marker.setMap(null);
      this.marker = null;
      if ((_ref1 = this.infoWindow) != null) {
        _ref1.setMap(null);
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
