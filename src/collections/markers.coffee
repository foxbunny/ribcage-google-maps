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
    require = (dep) ->
      (() ->
        switch dep
          when 'ribcage/collections/base' then root.ribcage.collections.baseCollection
          else null
      )() or throw new Error "Unmet dependency #{dep}"
    (factory) ->
      m = factory(require)
      r = root.ribcageGoogleMaps
      r.collections.markersCollection = m
      r.collections.MarkersCollection = m.Model
      r.collectionMixins.MarkersCollection = m.mixin
) this


define (require) ->

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

  # ## Exports
  #
  # This module exports `mixin` and `Collection` properties.
  #
  mixin: markersCollectionMixin
  Collection: MarkersCollection

