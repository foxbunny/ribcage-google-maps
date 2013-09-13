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
      root.ribcageGoogleMaps.views.streetView = module;
      root.ribcageGoogleMaps.views.StreetView = module.View;
      return root.ribcageGoogleMaps.viewMixins.StreetView = module.mixin;
    };
  }
})(this);

define(function(require) {
  var BaseView, StreetView, clone, maps, streetViewMixin, type, _, _ref;
  _ = require('underscore');
  _ref = require('dahelpers'), type = _ref.type, clone = _ref.clone;
  BaseView = require('ribcage/views/base').View;
  maps = require('../gmaps');
  streetViewMixin = {
    template: '',
    streetViewContainer: null,
    visible: true,
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
      if ((v == null) || (v === true || v === false)) {
        return void 0;
      }
      return maps.ControlPosition[v.toUpperCase()];
    },
    getZoomCtrlStyle: function(v) {
      v = v == null ? 'DEFAULT' : v.toUpperCase();
      return maps.ZoomControlStyle[v];
    },
    getStreetViewContainer: function() {
      var svContainer;
      if (this.streetViewContainer == null) {
        return this.el;
      }
      svContainer = this.$(this.streetViewContainer);
      if (svContainer.length) {
        return svContainer[0];
      } else {
        return this.el;
      }
    },
    getStreetViewOpts: function(cfg, data) {
      var o, _fn, _i, _len, _ref1,
        _this = this;
      if (cfg == null) {
        cfg = {};
      }
      _ref1 = ['streetViewDefaultUI', 'streetViewWheel', 'streetViewAddressControl', 'streetViewClickToGo', 'streetViewDblClickZoom', 'streetViewCloseButton', 'streetViewImageDates', 'streetViewLinks', 'streetViewPanControl', 'streetViewZoomControl', 'streetViewZoomControlStyle'];
      _fn = function(o) {
        if (cfg[o] == null) {
          return cfg[o] = _this[o];
        }
      };
      for (_i = 0, _len = _ref1.length; _i < _len; _i++) {
        o = _ref1[_i];
        _fn(o);
      }
      return {
        pov: {
          heading: data.heading(),
          pitch: data.pitch()
        },
        position: data.coords(),
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
        visible: cfg.visible,
        zoomControl: !!cfg.streetViewZoomControl,
        zoomControlOptions: {
          position: this.getCtrlPos(cfg.streetViewZoomControl),
          style: this.getZoomCtrlStyle(cfg.streetViewZoomControlStyle)
        }
      };
    },
    initialize: function(_arg) {
      this.svExtraConfigs = _arg.svExtraConfigs;
    },
    render: function(cb) {
      var _this = this;
      if (this.panorama) {
        return;
      }
      this.$el.html(type(this.template, 'function') ? this.template() : this.template);
      setTimeout(function() {
        var svCfg, svContainer;
        if (_this.panorama) {
          return;
        }
        svContainer = _this.getStreetViewContainer();
        svCfg = _this.getStreetViewOpts(_this.svExtraConfigs, _this.model);
        _this.panorama = new maps.StreetViewPanorama(svContainer, svCfg);
        if (type(cb, 'function')) {
          return cb(_this, _this.panorama, svCfg);
        }
      }, 1);
      return this;
    }
  };
  StreetView = BaseView.extend(streetViewMixin);
  return {
    mixin: streetViewMixin,
    View: StreetView
  };
});
