# # Street View view
#
# This module implements a model view that displays Street View using Google
# Maps JavaScript API v3 and model data.
#
# This module is in UMD format. It will create a
# `ribcageGoogleMaps.views.streetView`,
# `ribcageGoogleMaps.views.StreetView`, and
# `ribcageGoogleMaps.viewMixins.StreetView` globals if not used with an AMD loader
# such as RequireJS.
#

define = ((root) ->
  if typeof root.define is 'function' and root.define.amd
    return define
  else
    require = (dep) ->
      (() ->
        switch dep
          when 'underscore' then root._
          when 'jquery' then root.jQuery
          when 'ribcage/views/base' then root.ribcage.views.baseView
          when '../gmaps' then root.google?.maps
          else null
      )() or throw new Error "Unmet dependency #{dep}"
    (factory) ->
      module = factory(require)
      root.ribcageGoogleMaps.views.streetView = module
      root.ribcageGoogleMaps.views.StreetView = module.View
      root.ribcageGoogleMaps.viewMixins.StreetView = module.mixin
) this

define (require) ->

  # This module depends on Google Maps API v3 library, Underscore, jQuery, and
  # `ribcage.views.BaseView`.
  #
  _ = require 'underscore'
  {type, clone} = require 'dahelpers'
  {View: BaseView} = require 'ribcage/views/base'
  maps = require '../gmaps'
  svService = new google.maps.StreetViewService()

  DEGREES_PER_RADIAN = 57.2957795
  RADIANS_PER_DEGREE = 0.017453

  # ::TOC::
  #

  # ## `streetViewMixin`
  #
  # This mixin implements the API for the `StreetView`.
  #
  # The model passed to `StreetView` should contain information about various
  # coordinates. The properties on the view itself control the overall
  # appearance of the Street View such as placement of controls, and similar.
  #
  streetViewMixin =

    # ### `#template`
    #
    # Template to render before rendering the map. Overriding this can be
    # useful if you want to render Street View and map in separate containers.
    # Otherwise, the default is empty string.
    #
    # If this attribute is a function, it will be called without arguments and
    # it will be expected to return the string to use as HTML. The resulting
    # HTML will be appended into the `el`.
    #
    template: ''

    # ### `#streetViewContainer`
    #
    # jQuery selector for the streetview container. The container must be
    # inside the view's `el`. Default is null (use same element as map).
    #
    streetViewContainer: null

    # ### `#visible`
    #
    # Whether Street View is visible by default or not. Default is `true`.
    #
    visible: true

    # ### `#streetViewDefaultUI`
    #
    # Whether all of default UI is enabled. Default is `true`.
    #
    streetViewDefaultUI: true

    # ### `#streetViewWheel`
    #
    # Whether scroll wheel zooming is enabled in Street View. Default is
    # `true`.
    #
    streetViewWheel: true

    # ### `#maxSearchRadius`
    #
    # The maximum search radius in which to lookg for available panorama. 50 is
    # the minimum and default value. Use larger values to ensure that
    # streetview is always displayed even if not available at specified
    # location.
    #
    maxSearchRadius: 50

    # ### `#ignoreHeading`
    #
    # Ignore the heading and attempt to recalculate the heading based on the
    # difference between actual location and intended location. Default is
    # `false` (use model data).
    #
    ignoreHeading: false

    # ### `#defaultHeading`
    #
    # Default heading when ignoring the heading in the model data and the
    # actual and intended locations are the same. Default is 0.
    #
    defaultHeading: 0

    # ### `#streetViewAddressControl`
    #
    # Position of the address control in Street View. Any of the following:
    #
    #  + 'bottom_center'
    #  + 'bottom_left'
    #  + 'bottom_right'
    #  + 'left_bottom'
    #  + 'left_center'
    #  + 'left_top'
    #  + 'right_bottom'
    #  + 'right_center'
    #  + 'right_top'
    #  + 'top_center'
    #  + 'top_left'
    #  + 'top_right'
    #  + `false` (disabled)
    #  + `true` (enabled in default position)
    #
    # Default is `true`.
    #
    streetViewAddressControl: true

    # ### `#streetViewClickToGo`
    #
    # Whether click-to-go behavior is enabled. Default is `true`.
    #
    streetViewClickToGo: true

    # ### `#streetViewDblClickZoom`
    #
    # Whether double-click zoom is enabled. Default is `false`.
    #
    streetViewDblClickZoom: false

    # ### `#streetViewCloseButton`
    #
    # Whether close button is enabled. Default is `false`.
    #
    streetViewCloseButton: false

    # ### `#streetViewImageDates`
    #
    # Whether image acquisition date control is enabled. Default is `false`.
    #
    streetViewImageDates: false

    # ### `#streetViewLinks`
    #
    # Whether links control is enabled. Default is `false`
    #
    streetViewLinks: false

    # ### `#streetViewPanControl`
    #
    # Position of the pan control. Any of the following:
    #
    #  + 'bottom_center'
    #  + 'bottom_left'
    #  + 'bottom_right'
    #  + 'left_bottom'
    #  + 'left_center'
    #  + 'left_top'
    #  + 'right_bottom'
    #  + 'right_center'
    #  + 'right_top'
    #  + 'top_center'
    #  + 'top_left'
    #  + 'top_right'
    #  + `false` (disabled)
    #  + `true` (enabled in default position)
    #
    # Default is `false`.
    #
    streetViewPanControl: false

    # ### `#streetViewZoomControl`
    #
    # Position of the zoom control in Street View. Any of the following values:
    #
    #  + 'bottom_center'
    #  + 'bottom_left'
    #  + 'bottom_right'
    #  + 'left_bottom'
    #  + 'left_center'
    #  + 'left_top'
    #  + 'right_bottom'
    #  + 'right_center'
    #  + 'right_top'
    #  + 'top_center'
    #  + 'top_left'
    #  + 'top_right'
    #  + `false` (disabled)
    #  + `true` (enabled in default position)
    #
    # Default is `true`.
    #
    streetViewZoomControl: null

    # ### `#streetViewZoomControlStyle`
    #
    # Can be any of the following values:
    #
    #  + 'large'
    #  + 'small'
    #  + `null` (default style)
    #
    # Default is null.
    #
    streetViewZoomControlStyle: null

    # ### `#getTrueHeading(target, actual)`
    #
    # Returns the true heading based on desired latitude and longitude, and
    # actual latitude and longitude of the street view. Returns 0 if the
    # target location is the same as actual location.
    #
    # Both arguments are excepted to be `google.maps.LatLng` objects.
    #
    getTrueHeading: (target, actual) ->
      targetLat = target.lat()
      targetLong = target.lng()
      lat = actual.lat()
      long = actual.lng()
      if targetLat is lat and targetLong is long
        return @defaultHeading
      deltaLat = targetLat - lat
      deltaLong = targetLong - long
      yaw = Math.atan2(
        deltaLong * Math.cos(targetLat * RADIANS_PER_DEGREE), deltaLat
      ) * DEGREES_PER_RADIAN
      return yaw if 0 < yaw < 360
      if yaw < 0 then yaw + 360 else yaw - 360

    # ### `#getCtrlPos(v)`
    #
    # Converts the `MapView` control position string to Maps API version.
    #
    getCtrlPos: (v) ->
      return undefined if not v? or v in [true, false]
      maps.ControlPosition[v.toUpperCase()]

    # ### `#getZoomCtrlStyle(v)`
    #
    # Converts the `MapView` zoom control style to Maps API version.
    #
    getZoomCtrlStyle: (v) ->
      v = if not v? then 'DEFAULT' else v.toUpperCase()
      maps.ZoomControlStyle[v]

    # ### `#getStreetViewContainer()`
    #
    # Return the node to use a the Street View container.
    #
    getStreetViewContainer: () ->
      return @el if not @streetViewContainer?
      svContainer = @$ @streetViewContainer
      if svContainer.length then svContainer[0] else @el

    # ### `#getStreetViewOpts(cfg, data)`
    #
    # Returns the `maps.StreetViewPanorama` instance.
    #
    getStreetViewOpts: (cfg={}, data) ->
      ((o) =>
        cfg[o] = this[o] if not cfg[o]?
      ) o for o in [
        'streetViewDefaultUI'
        'streetViewWheel'
        'streetViewAddressControl'
        'streetViewClickToGo'
        'streetViewDblClickZoom'
        'streetViewCloseButton'
        'streetViewImageDates'
        'streetViewLinks'
        'streetViewPanControl'
        'streetViewZoomControl'
        'streetViewZoomControlStyle'
      ]

      pov:
        heading: data.heading()
        pitch: data.pitch()
      position: data.coords()
      addressControl: !!cfg.streetViewAddressControl
      addressControlOptions:
        position: @getCtrlPos cfg.streetViewAddressControl
      clickToGo: cfg.streetViewClickToGo
      disableDefaultUI: not cfg.streetViewDefaultUI
      disableDoubleClickZoom: not cfg.streetViewDblClickZoom
      enableCloseButton: cfg.streetViewCloseButton
      imageDateControl: cfg.streetViewImageDates
      linksControl: cfg.streetViewLinks
      panControl: !!cfg.streetViewPanControl
      panControlOptions:
        position: @getCtrlPos cfg.streetViewPanControl
      scrollWheel: cfg.streetViewWheel
      visible: false
      zoomControl: !!cfg.streetViewZoomControl
      zoomControlOptions:
        position: @getCtrlPos cfg.streetViewZoomControl
        style: @getZoomCtrlStyle cfg.streetViewZoomControlStyle

    # ## `#initialize(settings)`
    #
    # The settings object may contain `svExtraConfigs` key which will be used
    # to override any of the view's settings during rendering.
    #
    # Unlike the `MapView`, this view doesn't do any data-binding. It will not
    # render more than once.
    #
    initialize: ({@svExtraConfigs}) ->
      return

    # ## `noStreetView(config, callback)`
    #
    # Called when there is no street view data for the given location.
    #
    # Default implementation simply alerts an error message: "Street view data
    # is not available for this location".
    #
    # `config` object is the configuration object that was going to be used to
    # create the panorama.
    #
    # `callback` is the callback originally passed to `#render()` method. It
    # should be invoked in this method with this view as first argument,
    # view's panorama property as second, and configuration object as third
    # parameter.
    #
    noStreetView: (config, callback) ->
      alert "Street view data is not available for this location"
      callback this, @panorama, config if callback?

    # ## `#beforeRender(config, renderCallback, callback)`
    #
    # Try to obtain streetview data directly first, to see if there is any.
    # Lets render proceed normally if there is data, otherwise calls
    # `#noStreetView()` method.
    #
    # `config` parameter is the configuration object that is going to be used
    # for the panorama.
    #
    # `renderCallback` is the callback originally passed to the `#render()`
    # method.
    #
    # `callback` function is called only if data is available. It should
    # expect `google.maps.StreetViewData` object as its sole argument.
    #
    beforeRender: (config, renderCallback, callback) ->
      pos = config.position
      radius = @maxSearchRadius
      svService.getPanoramaByLocation pos, radius, (data, status) =>
        if status isnt maps.StreetViewStatus.OK
          return @noStreetView config, renderCallback
        callback data

    # ### `#render(cb)`
    #
    # Renders the Street View panorama and stores the reference to rendered
    # panorama as `this.panorama`.
    #
    # Unlike standard synchronous `#render()` methods, this render method will
    # return `this` before rendering the panorama. Rendering happens with a
    # slight delay of 1ms, which is not significant, but gives the
    # application enough time to attach `el` to the DOM tree and prevent the
    # map from rendering in a 0-height box (essentially hidden away).
    #
    # A single callback function can be specified which is called as soon as
    # the new map instance is created. The callback will receive three
    # arguments, a reference to the view, a reference to the panorama instance,
    # and an object containing the configuration used to create the panorama.
    #
    render: (cb) ->
      return if @panorama

      @$el.html if type @template, 'function' then @template() else @template

      return if @panorama
      svContainer = @getStreetViewContainer()
      svCfg = @getStreetViewOpts @svExtraConfigs, @model

      @beforeRender svCfg, cb, (data) =>
        ## This callback function is only called if street view data is
        ## available for the given location. When the data is not available
        ## the `#noStreetView()` method is called instead.
        @panorama = new maps.StreetViewPanorama svContainer, svCfg
        @panorama.setPano data.location.pano
        if @ignoreHeading
          actualLoc = data.location.latLng
          heading = @getTrueHeading svCfg.position, data.location.latLng
          @panorama.setPov heading: heading, pitch: 0
        @panorama.setVisible @visible
        cb(this, @panorama, svCfg) if type cb, 'function'

      this

  # ## `StreetView`
  #
  # Please see the documentation for [`streetViewMixin`](#streetviewmixin) for
  # more information on this view's API.
  #
  StreetView = BaseView.extend streetViewMixin

  # ## Exports
  #
  # This module exports `mixin` and `View` properties.
  #
  mixin: streetViewMixin
  View: StreetView
