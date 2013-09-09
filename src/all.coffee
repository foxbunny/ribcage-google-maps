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
  mapDataModel = require './models/map_data'
  markerModel = require './models/marker'

  markersCollection = require './collections/markers'

  mapView = require './views/map'
  markerView = require './views/marker'
  markersView = require './views/markers'

  models:
    mapDataModel: mapDataModel
    markerModel: markerModel
    MapDataModel: mapDataModel.Model
    MarkerModel: markerModel.Model

  modelMixins:
    MapDataModel: mapDataModel.mixin
    MarkerModel: markerModel.mixin

  collections:
    markersCollection: markersCollection
    MarkersCollection: markersCollection.Collection

  collectionMixins:
    MarkersCollection: markersCollection.mixin

  views:
    mapView: mapView
    markerView: markerView
    markersView: markersView
    MapView: mapView.View
    MarkerView: markerView.View
    MarkersView: markersView.View

