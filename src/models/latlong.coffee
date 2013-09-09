# # Lat-long model
#
# This model stores latitude and longitude information and provides a coords
# accesor for manipulating them.
#
# This module is in UMD format. It will create
# `ribcageGoogleMaps.models.latLong`, `ribcageGoogleMaps.models.LatLong`, and
# `ribcageGoogleMaps.modelMixins.LatLong` globals if not used with an AMD
# loader such as RequireJS.
#

define = ((root) ->
  if typeof root.define is 'function' and root.define.amd
    root.define
  else
    require = (dep) ->
      (() ->
        switch dep
          when 'ribcage/models/base' then root.ribcage.models.basreModel
          when '../gmaps' then root.google?.maps
          else null
      )() or throw new Error "Unmet dependency #{dep}"
    (factory) ->
      module = factory(require)
      root.ribcageGoogleMaps.models.latLongModel = module
      root.ribcageGoogleMaps.models.LatLong = module.Model
      root.ribcageGoogleMaps.modelMixins.LatLong = module.mixin
) this

define (require) ->

  # This module depends on Google Maps API v3 library and
  # `ribcage.models.BaseModel`.
  #
  {Model: BaseModel} = require 'ribcage/models/base'
  {LatLng} = require '../gmaps'

  # ::TOC::
  #

  # ## `latLongModelMixin`
  #
  # This mixin implements the API of the `LatLongModel`.
  #
  latLongModelMixin =
    defaults:
      lat: 0
      long: 0

    # ### `#lat([v])`
    #
    # This is an accessor for the `lat` attribute. The setter will convert any
    # value to a float. The value will be `NaN` if it cannot be parsed by
    # `parseFloat`.
    #
    # When called without arguments it returns the current value. Otherwise
    # sets the value to `v`.
    #
    lat: (v) ->
      if not v?
        @get 'lat'
      else
        @set lat: parseFloat v

    # ### `#long([v])`
    #
    # This is an accessor for the `long` attribute. The setting will convert any
    # value to float. The value will be `NaN` if it cannot be parsed by
    # `parseFloat`.
    #
    # Returns current value when called without arguments, otherwise sets value
    # to `v`.
    #
    long: (v) ->
      if not v?
        @get 'long'
      else
        @set long: parseFloat v

    # ### `#coords([lat, long])`
    #
    # This is a shortcut for getting a `google.maps.LatLng` object based on the
    # `lat` and `long` attributes. When setting a new value using this accessor,
    # you must pass it an array of two float values that represent the lattitude
    # and longitude.
    #
    # Returns `google.maps.LatLng` instance if called without argumetns,
    # otherwise sets latitude and longitude when passed the arguments.
    #
    coords: (lat, long) ->
      if not lat? or not long?
        new LatLng @lat(), @long(), false
      else
        @lat(lat)
        @long(long)

  LatLongModel = BaseModel.extend latLongModelMixin

  mixin: latLongModelMixin
  Model: LatLongModel
