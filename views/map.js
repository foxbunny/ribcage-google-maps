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
          case 'underscore':
            return root._;
          case 'jquery':
            return root.jQuery;
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
      root.ribcageGoogleMaps.views.mapView = module;
      root.ribcageGoogleMaps.views.MapView = module.View;
      return root.ribcageGoogleMaps.viewMixins.MapView = module.mixin;
    };
  }
})(this);

define(function(require) {
  var BaseView, MapView, clone, mapViewMixin, maps, type, _, _ref;
  _ = require('underscore');
  _ref = require('dahelpers'), type = _ref.type, clone = _ref.clone;
  BaseView = require('ribcage/views/base').View;
  maps = require('../gmaps');
  mapViewMixin = {
    template: '',
    mapContainer: null,
    mapType: 'roadmap',
    zoom: 8,
    minZoom: null,
    maxZoom: null,
    defaultUI: true,
    dblClickZoom: true,
    draggable: true,
    dragHoverCursor: null,
    dragMoveCursor: null,
    shortcuts: true,
    wheeel: true,
    mapMaker: false,
    mapTypeControl: true,
    mapControlStyle: null,
    mapTypes: null,
    panControl: true,
    rotateControl: true,
    scaleControl: true,
    zoomControl: null,
    zoomControlStyle: null,
    streetViewControl: true,
    overview: false,
    styles: [],
    getCtrlPos: function(v) {
      if ((v == null) || (v === true || v === false)) {
        return void 0;
      }
      return maps.ControlPosition[v.toUpperCase()];
    },
    getMapType: function(v) {
      return v || void 0;
    },
    getMapTypes: function(a) {
      var v, _i, _len, _results;
      if ((a == null) || !a.length) {
        return void 0;
      }
      _results = [];
      for (_i = 0, _len = a.length; _i < _len; _i++) {
        v = a[_i];
        _results.push(this.getMapTypes(v));
      }
      return _results;
    },
    getMapTypeCtrlStyle: function(v) {
      if (v === true || v === false) {
        return void 0;
      }
      v = v == null ? 'DEFAULT' : v.toUpperCase();
      return maps.MapTypeControlStyle[v];
    },
    getZoomCtrlStyle: function(v) {
      v = v == null ? 'DEFAULT' : v.toUpperCase();
      return maps.ZoomControlStyle[v];
    },
    getOverviewOpen: function(v) {
      if (v === false || (v == null)) {
        return void 0;
      }
      if (v === 'open') {
        return true;
      } else {
        return false;
      }
    },
    getCoords: function(lat, long) {
      lat = parseFloat(lat);
      long = parseFloat(long);
      if (isNaN(lat) || isNaN(long)) {
        return new maps.LatLng(0, 0, false);
      } else {
        return new maps.LatLng(lat, long, false);
      }
    },
    getMapContainer: function() {
      var mapContainer;
      if (this.mapContainer == null) {
        return this.el;
      }
      mapContainer = this.$(this.mapContainer);
      if (!mapContainer.length) {
        return this.el;
      }
      return mapContainer[0];
    },
    getMapOpts: function(cfg, data) {
      var o, opts, _fn, _i, _len, _ref1,
        _this = this;
      if (cfg == null) {
        cfg = {};
      }
      cfg = clone(cfg);
      _ref1 = ['mapType', 'zoom', 'minZoom', 'maxZoom', 'defaultUI', 'dblClickZoom', 'draggable', 'dragHoverCursor', 'dragMoveCursor', 'shortcuts', 'wheel', 'mapMaker', 'mapTypeControl', 'mapControlStyle', 'mapTypes', 'panControl', 'rotateControl', 'scaleControl', 'zoomControl', 'zoomControlStyle', 'streetView', 'streetViewControl', 'overview', 'styles'];
      _fn = function(o) {
        if (cfg[o] == null) {
          return cfg[o] = _this[o];
        }
      };
      for (_i = 0, _len = _ref1.length; _i < _len; _i++) {
        o = _ref1[_i];
        _fn(o);
      }
      return opts = {
        center: data.coords(),
        heading: data.heading(),
        disableDefaultUI: !cfg.defaultUI,
        disableDoubleClickZoom: !cfg.dblClickZoom,
        draggable: cfg.draggable,
        draggableCursor: cfg.dragHoverCursor,
        draggingCursor: cfg.dragMoveCursor,
        keyboardShortcuts: cfg.shortcuts,
        mapMaker: cfg.mapMaker,
        mapTypeControl: !!cfg.mapTypeControl,
        mapTypeControlOptions: {
          mapTypeIds: this.getMapTypes(cfg.mapTypes),
          position: this.getCtrlPos(cfg.mapControl),
          style: this.getMapTypeCtrlStyle(cfg.mapControlStyle)
        },
        mapTypeId: this.getMapType(cfg.mapType),
        maxZoom: cfg.maxZoom,
        minZoom: cfg.minZoom,
        noClear: false,
        overviewMapControl: !!cfg.overview,
        overviewMapControlOptions: {
          opened: this.getOverviewOpen(cfg.overview)
        },
        panControl: !!cfg.panControl,
        panControlOptions: {
          position: this.getCtrlPos(cfg.panControl)
        },
        rotateControl: !!cfg.rotateControl,
        rotateControlOptions: {
          position: this.getCtrlPos(cfg.rotateControl)
        },
        scaleControl: !!cfg.rotateControl,
        scaleControlOptions: {
          position: this.getCtrlPos(cfg.scaleControl)
        },
        styles: cfg.styles,
        streetViewControl: !!cfg.streetViewControl,
        streetViewControlOptions: {
          position: this.getCtrlPos(cfg.streetViewControl)
        },
        scrollwheel: cfg.wheel,
        zoomControl: !!cfg.zoomControl,
        zoomControlOptions: {
          position: this.getCtrlPos(cfg.zoomControl),
          style: this.getZoomCtrlStyle(cfg.zoomControlStyle)
        },
        zoom: cfg.zoom
      };
    },
    initialize: function(_arg) {
      this.mapExtraConfigs = _arg.mapExtraConfigs;
      return this.model.on('change', this.render, this);
    },
    render: function(cb) {
      var _this = this;
      if (this.map == null) {
        this.$el.html(type(this.template, 'function') ? this.template() : this.template);
      }
      setTimeout(function() {
        var cfg;
        cfg = _this.getMapOpts(_this.mapExtraConfigs, _this.model);
        if (_this.map != null) {
          _this.map.setOptions(cfg);
        } else {
          _this.map = new maps.Map(_this.getMapContainer(), cfg);
        }
        if (type(cb, 'function')) {
          return cb(_this, _this.map, cfg);
        }
      }, 1);
      return this;
    }
  };
  MapView = BaseView.extend(mapViewMixin);
  return {
    mixin: mapViewMixin,
    View: MapView
  };
});
