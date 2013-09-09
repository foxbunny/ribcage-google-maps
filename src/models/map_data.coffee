# # Map data model
#
# This is a model that contains map data compatible with `MapView`.
#
# This module is in UMD format. It will create
# `ribcageGoogleMaps.models.mapDataModel`,
# `ribcageGoogleMaps.models.MapDataModel`, and
# `ribcageGoogleMaps.modelMixins.MapDataModel` globals if not used with an AMD
# loader such as RequireJS.
#

define = ((root) ->
  if typeof root.define is 'function' and root.define.amd
    root.define
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
      root.ribcageGoogleMaps.models.mapDataModel = module
      root.ribcageGoogleMaps.models.MapDataModel = module.Model
      root.ribcageGoogleMaps.modelMixins.MapDataModel = module.mixin
) this

define (require) ->

  # This module depends on DaHelpers and `ribcageGoogleMaps.latLongModel.
  #
  dh = require 'dahelpers'
  latLongModel = require './latlong'

  # ::TOC::
  #

  # ## `mapDataModelMixin`
  #
  # This mixin implements the API of the `MapDataModel`.
  #
  # It extends the `LatLongModel` to add heading and pitch information.
  #
  mapDataModelMixin =
    defaults: dh.extend
      heading: 0
      pitch: 0
    , latLongModelMixin.mixin.defaults

  # ### `#heading`
  #
  # This is an accessor for the `heading` attribute. The setting will convert
  # any value to float. The value will be `NaN` if it cannot be parsed by
  # `parseFloat`.
  #
  Object.defineProperty mapDataModelMixin, 'heading',
    get: () -> @get 'heading'
    set: (v) -> @set heading: parseFloat v

  # ### `#pitch`
  #
  # This is an accessor for the `pitch` attribute. The setting will convert any
  # value to float. The value will be `NaN` if it cannot be parsed by
  # `parseFloat`.
  #
  Object.defineProperty mapDataModelMixin, 'pitch',
    get: () -> @get 'pitch'
    set: (v) -> @set pitch: parseFloat v

  MapDataModel = latLongModelMixin.Model.extend mapDataModelMixin

  mixin: mapDataModelMixin
  Model: MapDataModel

