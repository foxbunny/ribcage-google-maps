# # Map marker model
#
# This model allows you to store map marker data.
#
# Thos module is in UMD format. It will create
# `ribcageGoogleMaps.models.markerModel`,
# `ribcageGoogleMaps.models.MarkerModel`, and
# `ribcageGoogleMaps.mixins.MarkerModel` globals if not used with an AMD loader
# such as RequireJS.
#

define = ((root) ->
  if typeof root.define is 'function' and root.define.amd
    return define
  else
    require = (dep) ->
      (() ->
        switch dep
          when 'dahelpers' then root.dahelpers
          when './latlong' then root.ribcageGoogleMaps?.models?.latLongModel
          else null
      )() or throw new Error "Unmet dependency #{dep}"
    (factory) ->
      module = factory(require)
      root.ribcageGoogleMaps.models.markerModel = module
      root.ribcageGoogleMaps.models.MarkerModel = module.Model
      root.ribcageGoogleMaps.modelMixins.MarkerModel = module.mixin
) this

define (require) ->

  # This module depends on DaHelpers and `ribcageGoogleMaps.latLongModel`.
  #
  dh = require 'dahelpers'
  latLongModel = require './latlong'

  # ::TOC::
  #

  # ## `markerModelMixin`
  #
  # This mixin implements the `MarkerModel` API.
  #
  # It extends the `LatLongModel` to add the following attributes:
  #
  #  + title - the roll-over title (string)
  #  + info - context information for info window (should be an object)
  #
  mapMarkerModelMixin =
    defaults: dh.extend
      title: null
      info: {}
    , latLongModel.mixin.defaults

  # ## `MarkerModel`
  #
  # Please see the documentation for
  # [`mapMarkerModelMixin`](#mapmarkermodelmixin) for more information about
  # this model's API.
  #
  MarkerModel = latLongModel.Model.extend mapMarkerModelMixin

  # ## Exports
  #
  # This module exports `mixin` and `Model` properties.
  #
  mixin: mapMarkerModelMixin
  Model: MarkerModel
