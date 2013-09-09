# # Marker collection
#
# This is a simple collection of map markers.
#
# This module is in UMD format. It will create
# `ribcageGoogleMaps.collection.markersCollection`,
# `ribcageGoogleMaps.collection.MarkersCollection`, and
# `ribcageGoogleMaps.collectionMixins.MarkersCollection` globals if not used
# with an AMD loader such as RequireJS.
#

define = ((root) ->
  if typeof root.define is 'function' and root.define.amd
    return define
  else
    (factory) ->
      module = factory()
      root.ribcageGoogleMaps.collections.markersCollection = module
      root.ribcageGoogleMaps.collections.MarkersCollection = module.Model
      root.ribcageGoogleMaps.collectionMixins.MarkersCollection = module.mixin
) this

define () ->

  # This module depeds on `ribcage.collections.BaseCollection`
  #
  {Collection: BaseCollection} = require 'ribcage/collections/base'

  # ::TOC::
  #

  # ## `markersCollectionMixin`
  #
  # This mixin implements the API for `MarkersCollection`.
  #
  # This is currently a stub. Future versions of Ribcage-Google-Maps will
  # implement features such as clustering in this collection mixin.
  #
  markersCollectionMixin = {}

  # ## `MarkersCollection`
  #
  # Please look at the documentation for
  # [`markersCollectionMixin`](#markerscollectionmixin) for more information
  # about this collection's API.
  #
  MarkersCollection = BaseCollection.extend markersCollectionMixin

  mixin: markersCollectionMixin
  Collection: MarkersCollection

