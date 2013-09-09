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

  markersCollection = require './collections/markers'

  mapView = require './views/map'
  markerView = require './views/marker'
  markersView = require './views/markers'

  # ::TOC::
  #

  # ## Models
  #
  #  + [LatLongModel](models/latlong.mkd) - Base model for models that
  #    prepresents coordinates.
  #  + [MapDataModel](models/map_data.mkd) - Handles basic map data
  #    (position, heading, pov).
  #  + [MarkerModel](models/marker.mkd) - Represents the data for a single
  #    marker and associated info window.
  #
  models:
    latLongModel: latLongModel
    mapDataModel: mapDataModel
    markerModel: markerModel
    LatLongModel: latLongModel.Model
    MapDataModel: mapDataModel.Model
    MarkerModel: markerModel.Model

  modelMixins:
    MapDataModel: mapDataModel.mixin
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
  #  + [MarkerView](views/marker) - Handles the rendering and presentation
  #    of a single map marker and its info window.
  #  + [MarkersView](views/markers) - Handles the rendering and
  #    presentation of a collection of markers with related views.
  #
  views:
    mapView: mapView
    markerView: markerView
    markersView: markersView
    MapView: mapView.View
    MarkerView: markerView.View
    MarkersView: markersView.View

  viewMixins:
    MapView: mapView.mixin
    MarkerView: markerView.mixin
    MarkersView: markersView.mixin

