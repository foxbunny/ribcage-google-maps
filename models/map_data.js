// Generated by CoffeeScript 1.6.3
var define;

define = (function(root) {
  var require;
  if (typeof root.define === 'function' && root.define.amd) {
    return root.define;
  } else {
    require = function(dep) {
      return (function() {
        var _ref, _ref1;
        switch (dep) {
          case 'dahelpers':
            return root.dahelpers;
          case './latlong':
            return (_ref = root.ribcageGoogleMaps) != null ? (_ref1 = _ref.models) != null ? _ref1.latLongModel : void 0 : void 0;
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
      root.ribcageGoogleMaps.models.mapDataModel = module;
      root.ribcageGoogleMaps.models.MapDataModel = module.Model;
      return root.ribcageGoogleMaps.modelMixins.MapDataModel = module.mixin;
    };
  }
})(this);

define(function(require) {
  var MapDataModel, dh, latLongModel, mapDataModelMixin;
  dh = require('dahelpers');
  latLongModel = require('./latlong');
  mapDataModelMixin = {
    defaults: dh.extend({
      heading: 0,
      pitch: 0
    }, latLongModel.mixin.defaults),
    heading: function(v) {
      if (v == null) {
        return this.get('heading');
      } else {
        return this.set('heading', v);
      }
    },
    pitch: function(v) {
      if (v == null) {
        return this.get('pitch');
      } else {
        return this.set('pitch', v);
      }
    }
  };
  MapDataModel = latLongModel.Model.extend(mapDataModelMixin);
  return {
    mixin: mapDataModelMixin,
    Model: MapDataModel
  };
});
