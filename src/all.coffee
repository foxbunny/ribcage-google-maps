# # Ribcage-Google-Maps
#
# This is the main Ribcage-Google-Maps module. It represents a one-stop shop
# for all other modules and a namespace creator when not used with an AMD
# loader such as RequireJS.
#
# You should generally require indivudal modules instead of this one. However,
# if you are not using an AMD module loader, you _must_ load this module first.
#

define = ((root) ->
  if typeof root.define is 'function' and root.define.amd
    return define
  else
    (factory) ->
      module = root.ribcageGoogleMaps or= {}
      module.models or= {}
      module.modelMixins or= {}
      module.collections or= {}
      module.collectionMixins or= {}
      module.views or= {}
      module.viewMixins or={}
) this

define () ->
  latLongModel = require './models/latlong'
  mapDataModel = require './models/map_data'
  markerModel = require './models/marker'
  addressMOdel = require './models/address'

  markersCollection = require './collections/markers'

  mapView = require './views/map'
  markerView = require './views/marker'
  markersView = require './views/markers'
  streetView = require './views/streetview'

  # ::TOC::
  #

  # ## Models
  #
  #  + [LatLongModel](models/latlong.mkd) - Base model for models that
  #    prepresents coordinates.
  #  + [MapDataModel](models/map_data.mkd) - Handles basic map data
  #    (position, heading, pov).
  #  + [AddressModel](models/address.mkd) - Same as `MapDataModel` but with
  #    geocoding support to set coordinates from address.
  #  + [MarkerModel](models/marker.mkd) - Represents the data for a single
  #    marker and associated info window.
  #
  models:
    latLongModel: latLongModel
    mapDataModel: mapDataModel
    addressModel: addressModel
    markerModel: markerModel
    LatLongModel: latLongModel.Model
    MapDataModel: mapDataModel.Model
    AddressModel: addressModel.Model
    MarkerModel: markerModel.Model

  modelMixins:
    MapDataModel: mapDataModel.mixin
    AddressModel: addressModel.mixin
    MarkerModel: markerModel.mixin

  # ## Collections
  #
  #  + [MarkersCollection](collections/markers.mkd) - Represents a
  #    collection of markers.
  #
  collections:
    markersCollection: markersCollection
    MarkersCollection: markersCollection.Collection

  collectionMixins:
    MarkersCollection: markersCollection.mixin

  # ## Views
  #
  #  + [MapView](views/map.mkd) - The main map view: handles the rendering
  #    and presentation of the map.
  #  + [MarkerView](views/marker.mkd) - Handles the rendering and presentation
  #    of a single map marker and its info window.
  #  + [MarkersView](views/markers.mkd) - Handles the rendering and
  #    presentation of a collection of markers with related views.
  #  + [StreetView](views/streetview.mkd) - Handles rendering of stand-alone
  #    Street View panoramas
  #
  views:
    mapView: mapView
    markerView: markerView
    markersView: markersView
    streetView: streetView
    MapView: mapView.View
    MarkerView: markerView.View
    MarkersView: markersView.View
    StreetView: streetView.View

  viewMixins:
    MapView: mapView.mixin
    MarkerView: markerView.mixin
    MarkersView: markersView.mixin
    StreetView: streetView.mixin
