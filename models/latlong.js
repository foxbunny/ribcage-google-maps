// Generated by CoffeeScript 1.6.3
var define;

define = (function(root) {
  var require;
  if (typeof root.define === 'function' && root.define.amd) {
    return root.define;
  } else {
    require = function(dep) {
      return (function() {
        var _ref;
        switch (dep) {
          case 'ribcage/models/base':
            return root.ribcage.models.basreModel;
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
      root.ribcageGoogleMaps.models.latLongModel = module;
      root.ribcageGoogleMaps.models.LatLong = module.Model;
      return root.ribcageGoogleMaps.modelMixins.LatLong = module.mixin;
    };
  }
})(this);

define(function(require) {
  var BaseModel, LatLng, LatLongModel, latLongModelMixin;
  BaseModel = require('ribcage/models/base').Model;
  require('../gmaps');
  LatLng = google.maps.LatLng;
  latLongModelMixin = {
    defaults: {
      lat: 0,
      long: 0
    }
  };
  Object.defineProperty(latLongModelMixin, 'lat', {
    get: function() {
      return this.get('lat');
    },
    set: function(v) {
      return this.set({
        lat: parseFloat(v)
      });
    }
  });
  Object.defineProperty(latLongModelMixin, 'long', {
    get: function() {
      return this.get('long');
    },
    set: function(v) {
      return this.set({
        long: parseFloat(v)
      });
    }
  });
  Object.defineProperty(latLongModelMixin, 'coords', {
    get: function() {
      return new LatLng(this.lat, this.long, false);
    },
    set: function(v) {
      return this.lat = v[0], this.long = v[1], v;
    }
  });
  LatLongModel = BaseModel.extend(latLongModelMixin);
  return {
    mixin: latLongModelMixin,
    Model: LatLongModel
  };
});
