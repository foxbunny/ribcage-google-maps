// Generated by CoffeeScript 1.6.3
var define;

define = (function(root) {
  if (typeof root.define === 'function' && root.define.amd) {
    return define;
  } else {
    return function(factory) {
      var module;
      module = root.ribcageGoogleMaps || (root.ribcageGoogleMaps = {});
      module.models || (module.models = {});
      module.modelMixins || (module.modelMixins = {});
      module.collections || (module.collections = {});
      module.collectionMixins || (module.collectionMixins = {});
      module.views || (module.views = {});
      return module.viewMixins || (module.viewMixins = {});
    };
  }
})(this);

define(function() {
  var addressMOdel, latLongModel, mapDataModel, mapView, markerModel, markerView, markersCollection, markersView, streetView;
  latLongModel = require('./models/latlong');
  mapDataModel = require('./models/map_data');
  markerModel = require('./models/marker');
  addressMOdel = require('./models/address');
  markersCollection = require('./collections/markers');
  mapView = require('./views/map');
  markerView = require('./views/marker');
  markersView = require('./views/markers');
  streetView = require('./views/streetview');
  return {
    models: {
      latLongModel: latLongModel,
      mapDataModel: mapDataModel,
      addressModel: addressModel,
      markerModel: markerModel,
      LatLongModel: latLongModel.Model,
      MapDataModel: mapDataModel.Model,
      AddressModel: addressModel.Model,
      MarkerModel: markerModel.Model
    },
    modelMixins: {
      MapDataModel: mapDataModel.mixin,
      AddressModel: addressModel.mixin,
      MarkerModel: markerModel.mixin
    },
    collections: {
      markersCollection: markersCollection,
      MarkersCollection: markersCollection.Collection
    },
    collectionMixins: {
      MarkersCollection: markersCollection.mixin
    },
    views: {
      mapView: mapView,
      markerView: markerView,
      markersView: markersView,
      streetView: streetView,
      MapView: mapView.View,
      MarkerView: markerView.View,
      MarkersView: markersView.View,
      StreetView: streetView.View
    },
    viewMixins: {
      MapView: mapView.mixin,
      MarkerView: markerView.mixin,
      MarkersView: markersView.mixin,
      StreetView: streetView.mixin
    }
  };
});
