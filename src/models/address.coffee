# # Address model
#
# This model is a `MapData` subclass that returns coordinates based on address
# using the [Geocoder
# service](https://developers.google.com/maps/documentation/javascript/3.exp/reference#Geocoder).
#
# This module is in UMD format. It will create
# `ribcageGoogleMaps.models.addressModel`, `ribcageGoogleMaps.models.Address`,
# and `ribcageGoogleMaps.modelMixins.Address` globals if not used with an AMD
# loader such as RequireJS.
#

define = ((root) ->
  if typeof root.define is 'function' and root.define.amd
    root.define
  else
    require = (dep) ->
      (() ->
        switch dep
          when './map_data' then ribcageGoogleMaps.models.mapData
          when '../gmaps' then root.google?.maps
          else null
      )() or throw new Error "Unmet dependency #{dep}"
    (factory) ->
      module = factory(require)
      root.ribcageGoogleMaps.models.addressModel = module
      root.ribcageGoogleMaps.models.Address = module.Model
      root.ribcageGoogleMaps.modelMixins.Address = module.mixin
) this

define (require) ->

  # This module depends on DaHelpers, Google Maps API v3 library and
  # `ribcageGoogleMaps.models.MapData`.
  #
  dh = require 'dahelpers'
  {Model: MapDataModel} = require './map_data'
  {Geocoder, GeocoderStatus} = require '../gmaps'

  # ::TOC::
  #

  # ## `addressModelMixin`
  #
  # This mixin implements the API of the `AddressModel`.
  #
  addressModelMixin =
    defaults: dh.extend
      address: ''
    , MapDataModel::defaults

    # ### `#setLocation(geocoderResponse)`
    #
    # Sets the location based on geocoder response array.
    #
    setLocation: (geocoderResponse) ->
      firstResult = geocoderResponse[0]
      loc = firstResult.geometry.location
      @lat loc.lat()
      @long loc.lng()

    # ### `#address([address, callback])`
    #
    # This is an accessor for the `address` attribute. The setter will request
    # the coordinates for the address and set appropriate latitude and
    # longitude.
    #
    # The setter is asynchornous, so the `callback` function can be passed,
    # which is invoked with the model instance once the request is completed.
    #
    # The callback function has the following signature:
    #
    #     callback(err, model)
    #
    #  + `err`: Error status (`null` if there were no errors)
    #  + `model`: model instance (if there are no errors)
    #
    address: (address=null, callback) ->
      if address?
        @set 'address', address
        req = address: address
        gc = new Geocoder()
        gc.geocode req, (res, status) =>
          if status isnt GeocoderStatus.OK
            callback status if callback?
            return
          @setLocation res
          callback null, @ if callback?
      else
        @get 'address'

  # ## `LatLongModel`
  #
  # Please see the documentation for [`latLongModelMixin`](#latlongmodelmixin)
  # for more information about this model's API.
  #
  AddressModel = MapDataModel.extend addressModelMixin

  # ## Exports
  #
  # This module exports `mixin` and `Model` properties.
  #
  mixin: addressModelMixin
  Model: AddressModel
