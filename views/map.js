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
  var $, BaseView, MapView, mapViewMixin, maps, _;
  _ = require('underscore');
  $ = require('jquery');
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
    overview: false,
    streetView: false,
    streetViewContainer: null,
    streetViewControl: true,
    streetViewDefaultUI: true,
    streetViewWheel: true,
    streetViewAddressControl: true,
    streetViewClickToGo: true,
    streetViewDblClickZoom: false,
    streetViewCloseButton: false,
    streetViewImageDates: false,
    streetViewLinks: false,
    streetViewPanControl: false,
    streetViewZoomControl: null,
    streetViewZoomControlStyle: null,
    getCtrlPos: function(v) {
      v = v.toUpperCase();
      return maps.ControlPosition[v];
    },
    getMapType: function(v) {
      v = v.toUpperCase();
      return maps.MapTypeId[v];
    },
    getMapTypes: function(a) {
      var v, _i, _len, _results;
      if (!a) {
        return null;
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
        return null;
      }
      v = v === null ? 'DEFAULT' : v.toUpperCase();
      return maps.MapTypeControlStyle[v];
    },
    getZoomCtrlStyle: function(v) {
      v = v === null ? 'DEFAULT' : v.toUpperCase();
      return maps.ZoomControlStyle[v];
    },
    getOverviewOpen: function(v) {
      if (v === false) {
        return null;
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
    getStreetViewContainer: function() {
      var svContainer;
      if (this.streetViewContainer == null) {
        return null;
      }
      svContainer = this.$(this.streetViewContainer);
      if (!svContainer.length) {
        return null;
      }
      return svContainer[0];
    },
    getStreetView: function(cfg) {
      return maps.StreetViewPanorama(this.getStreetViewContainer(), {
        addressControl: !!cfg.streetViewAddressControl,
        addressControlOptions: {
          position: this.getCtrlPos(cfg.streetViewAddressControl)
        },
        clickToGo: cfg.streetViewClickToGo,
        disableDefaultUI: !cfg.streetViewDefaultUI,
        disableDoubleClickZoom: !cfg.streetViewDblClickZoom,
        enableCloseButton: cfg.streetViewCloseButton,
        imageDateControl: cfg.streetViewImageDates,
        linksControl: cfg.streetViewLinks,
        panControl: !!cfg.streetViewPanControl,
        panControlOptions: {
          position: this.getCtrlPos(cfg.streetViewPanControl)
        },
        scrollWheel: cfg.streetViewWheel,
        visible: cfg.streetView,
        zoomControl: !!cfg.streetViewZoomControl,
        zoomControlOptions: {
          position: this.getCtrlPos(cfg.streetViewZoomControl),
          style: this.getZoomCtrlStyle(cfg.streetViewZoomControlStyle)
        }
      });
    },
    getMapOpts: function(cfg) {
      var o, opts, _fn, _i, _len, _ref;
      cfg = $.extend(true, {}, cfg);
      _ref = ['mapType', 'zoom', 'minZoom', 'maxZoom', 'defaultUI', 'dblClickZoom', 'draggable', 'dragHoverCursor', 'dragMoveCursor', 'shortcuts', 'wheel', 'mapMaker', 'mapTypeControl', 'mapControlStyle', 'mapTypes', 'panControl', 'rotateControl', 'scaleControl', 'zoomControl', 'zoomControlStyle', 'overview', 'streetView', 'streetViewControl', 'streetViewDefaultUI', 'streetViewWheel', 'streetViewAddressControl', 'streetViewClickToGo', 'streetViewDblClickZoom', 'streetViewCloseButton', 'streetViewImageDates', 'streetViewLinks', 'streetViewPanControl', 'streetViewZoomControl', 'streetViewZoomControlStyle'];
      _fn = function(o) {
        return cfg[o] || (cfg[o] = this[o]);
      };
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        o = _ref[_i];
        _fn(o);
      }
      return opts = {
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
        scrollwheel: cfg.wheel,
        zoom: cfg.zoom,
        streetViewPanorama: this.getStreetView(cfg)
      };
    },
    initialize: function(settings) {
      this.cfg = this.getmapOpts(settings);
      return this.model.on('change', this.render, this);
    },
    render: function() {
      var cfg, data;
      this.$el.html((typeof this.template === 'function' ? this.template() : this.template));
      cfg = $.extend(true, {}, this.cfg);
      data = this.model.toJSON();
      cfg.center = cfg.streetView.position = data.coords;
      cfg.heading = data.heading;
      cfg.streetView.pov = {
        heading: data.heading,
        pitch: data.pitch
      };
      return this.map = maps.Map(this.getMapContainer(), cfg);
    }
  };
  MapView = BaseView.extend(mapViewMixin);
  return {
    mixin: mapViewMixin,
    View: MapView
  };
});
