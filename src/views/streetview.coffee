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

    # ### `#streetViewControl`
    #
    # Position of the Street View control (the pegman). Any of the following:
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
    streetViewControl: true

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
      ((o) ->
        cfg[o] = this[o] if not cfg[o]?
      ) o for o in [
        'streetViewControl'
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
      visible: cfg.visible
      zoomControl: !!cfg.streetViewZoomControl
      zoomControlOptions:
        position: @getCtrlPos cfg.streetViewZoomControl
        style: @getZoomCtrlStyle cfg.streetViewZoomControlStyle

    initialize: ({@svExtraConfigs}) ->

    render: (cb) ->
      return if @panorama

      @$el.html if type @template, 'function' then @template() else @template

      setTimeout () =>
        return if @panorama
        svContainer = @getStreetViewContainer()
        svCfg = @getStreetViewOpts @svExtraConfigs, @model
        @panorama = new maps.StreetViewPanorama svContainer, svCfg
      , 1

      this

  StreetView = BaseView.extend streetViewMixin

  mixin: streetViewMixin
  View: StreetView
