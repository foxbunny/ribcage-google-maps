# # Map view
#
# This module implements a model view that displays a map using Google Maps
# JavaScript API v3 and model data. It also updates the map based on model data
# when model data changes.
#
# This module is in UMD format. It will create a
# `ribcageGoogleMaps.views.mapView`,
# `ribcageGoogleMaps.views.MapView`, and
# `ribcageGoogleMaps.viewMixins.MapView` globals if not used with an AMD loader
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
      root.ribcageGoogleMaps.views.mapView = module
      root.ribcageGoogleMaps.views.MapView = module.View
      root.ribcageGoogleMaps.viewMixins.MapView = module.mixin
) this

define (require) ->

  # This module depends on Google Maps API v3 library, Underscore, jQuery, and
  # `ribcage.views.BaseView`.
  #
  _ = require 'underscore'
  {type, clone} = require 'dahelpers'
  {View: BaseView} = require 'ribcage/views/base'
  maps = require '../gmaps'

  # ::TOC::
  #

  # ## `mapViewMixin`
  #
  # This mixin implements the API for the `MapView`.
  #
  # The model passed to `MapView` should contain information about various
  # coordinates. The properties on the view itself control the overall
  # appearance of the map such as placement of controls, the type of map to
  # display, and similar.
  #
  mapViewMixin =

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

    # ### `#mapContainer`
    #
    # jQuery selector for the map container. The view's `el` is used if `null`.
    # Default is `null`.
    #
    mapContainer: null

    # ### `#mapType`
    #
    # Sets the type of map to use. Can be any of the following values:
    #
    #  + 'hybrid'
    #  + 'roadmap'
    #  + 'sattelite'
    #  + 'terrain'
    #
    # Default is 'roadmap'.
    #
    mapType: 'roadmap'

    # ### `#zoom`
    #
    # Default zoom of the map. Default is 8.
    #
    zoom: 8

    # ### `#minZoom`
    #
    # Minimum zoom level. Default is `null`.
    #
    minZoom: null

    # ### `#maxZoom`
    #
    # Maximum zoom level. Default is `null`.
    #
    maxZoom: null

    # ### `#defaultUI`
    #
    # Whether all of default map UI is enabled. Default is `true`.
    #
    defaultUI: true

    # ### `#dblClickZoom`
    #
    # Whether double-click zoom is enabled. Default is `true`.
    dblClickZoom: true

    # ### `#draggable`
    #
    # Whether dragging is enabled. Default is `true`.
    draggable: true

    # ### `#dragHoverCursor`
    #
    # The URL of the cursor to show when cursor is over a draggable map.
    # Default is `null` (default cursor).
    #
    dragHoverCursor: null

    # ### `#dragMoveCursor`
    #
    # The URL of the cursor to show map is being dragged. Default is `null`
    # (default cursor).
    #
    dragMoveCursor: null

    # ### `shortcuts`
    #
    # Whether keyboard shortcuts are enabled. Default is `true`.
    #
    shortcuts: true

    # ### `wheel`
    #
    # Whether scroll wheel zooming is enabled. Default is `true`.
    #
    wheeel: true

    # ### `mapMaker`
    #
    # Whether [Map Maker](http://www.google.com/mapmaker) tiles are used
    # instead of normal map tiles. Default is `false`
    #
    mapMaker: false

    # ### `#mapTypeControl`
    #
    # Position of the map type control. Any of the following values:
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
    mapTypeControl: true

    # ### `#mapControlStyle`
    #
    # The style of the map type control. Can be any of the following:
    #
    #  + 'dropdown_menu'
    #  + 'horizontal_bar'
    #  + `null` (default style)
    #
    # Default is `null`.
    #
    mapControlStyle: null

    # ### `#mapTypes`
    #
    # The map types that are allowed. Should be an array that includes one or
    # more of the following:
    #
    #  + 'hybrid'
    #  + 'roadmap'
    #  + 'sattelite'
    #  + 'terrain'
    #
    # The the value is set to `null`, uses the defaults.
    #
    # Default is `null`.
    #
    mapTypes: null

    # ### `#panControl`
    #
    # Position of the pan control. Any of the following values:
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
    panControl: true

    # ### `#rotateControl`
    #
    # Position of the rotate control. Any of the following values:
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
    rotateControl: true

    # ### `#scaleControl`
    #
    # Position of the scale control. Any of the following values:
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
    scaleControl: true

    # ### `#zoomControl`
    #
    # Position of the zoom control. Any of the following values:
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
    zoomControl: null

    # ### `#zoomControlStyle`
    #
    # Can be any of the following values:
    #
    #  + 'large'
    #  + 'small'
    #  + `null` (default style)
    #
    # Default is null.
    #
    zoomControlStyle: null

    # ### `#overview`
    #
    # The overview control options. Can be any of the following:
    #
    #  + 'open' (enabled and open by default)
    #  + 'closed' (enabled and closed by default)
    #  + false (disabled)
    #
    # Default is `false`
    #
    overview: false

    # ### `#styles`
    #
    # The map stylers array compliant with `google.maps.MapTypeStyle` object
    # specification. Default is `[]` (empty array).
    #
    styles: []

    # ### `#getCtrlPos(v)`
    #
    # Converts the `MapView` control position string to Maps API version.
    #
    getCtrlPos: (v) ->
      return undefined if not v? or v in [true, false]
      maps.ControlPosition[v.toUpperCase()]

    # ### `#getMapType(v)`
    #
    # Converts the `MapView` map type to Maps API version.
    #
    getMapType: (v) ->
      v or undefined

    # ### `getMapTypes(a)`
    #
    # Convert an array of `MapView` map types to Maps API version.
    getMapTypes: (a) ->
      return undefined if not a? or not a.length
      (@getMapTypes(v) for v in a)

    # ### `#getMapTypeCtrlStyle(v)`
    #
    # Converts the `MapView` map type control style to Maps API version.
    #
    getMapTypeCtrlStyle: (v) ->
      return undefined if v in [true, false]
      v = if not v? then 'DEFAULT' else v.toUpperCase()
      maps.MapTypeControlStyle[v]

    # ### `#getZoomCtrlStyle(v)`
    #
    # Converts the `MapView` zoom control style to Maps API version.
    #
    getZoomCtrlStyle: (v) ->
      v = if not v? then 'DEFAULT' else v.toUpperCase()
      maps.ZoomControlStyle[v]

    # ### `getOverviewOpen(v)`
    #
    # Returns a boolean that is used in `overviewMapControlOptions`. If `v` is
    # `false`, the `null` is returned instead.
    #
    getOverviewOpen: (v) ->
      return undefined if v is false or not v?
      if v is 'open' then true else false

    # ### `#getCoords(lat, long)`
    #
    # Converts the float `lat` and `long` to Maps API `LatLng` object.
    #
    # The `lat` and `long` can be strings and will be converted to floats using
    # `parseFloat`. If The coordinates are not valid numbers, a coordinate for
    # `(0, 0)` will be returned instead.
    #
    getCoords: (lat, long) ->
      lat = parseFloat(lat)
      long = parseFloat(long)
      if isNaN(lat) or isNaN(long)
        new maps.LatLng 0, 0, false
      else
        new maps.LatLng lat, long, false

    # ### `#getMapContainer()`
    #
    # Return the node to use as map container.
    #
    getMapContainer: () ->
      return @el if not @mapContainer?
      mapContainer = @$ @mapContainer
      return @el if not mapContainer.length
      mapContainer[0]

    # ### `#getMapOpts([cfg,] data)`
    #
    # Compiles the options object for use with the Maps API `Map` constructor.
    # The `cfg` argument should contain any overrides for the options defined
    # in the view constructor. It defaults to `{}` if not supplied. The `data`
    # argument should contain the model.
    #
    getMapOpts: (cfg={}, data) ->
      cfg = clone cfg

      # Set the defaults from the view constructor
      ((o) =>
        cfg[o] = this[o] if not cfg[o]?
      ) o for o in [
        'mapType'
        'zoom'
        'minZoom'
        'maxZoom'
        'defaultUI'
        'dblClickZoom'
        'draggable'
        'dragHoverCursor'
        'dragMoveCursor'
        'shortcuts'
        'wheel'
        'mapMaker'
        'mapTypeControl'
        'mapControlStyle'
        'mapTypes'
        'panControl'
        'rotateControl'
        'scaleControl'
        'zoomControl'
        'zoomControlStyle'
        'overview'
        'styles'
        'streetView'
      ]

      # Convert to Google Maps API format
      opts =
        center: data.coords()
        heading: data.heading()
        disableDefaultUI: not cfg.defaultUI
        disableDoubleClickZoom: not cfg.dblClickZoom
        draggable: cfg.draggable
        draggableCursor: cfg.dragHoverCursor
        draggingCursor: cfg.dragMoveCursor
        keyboardShortcuts: cfg.shortcuts
        mapMaker: cfg.mapMaker
        mapTypeControl: !!cfg.mapTypeControl
        mapTypeControlOptions:
          mapTypeIds: @getMapTypes cfg.mapTypes
          position: @getCtrlPos cfg.mapControl
          style: @getMapTypeCtrlStyle cfg.mapControlStyle
        mapTypeId: @getMapType cfg.mapType
        maxZoom: cfg.maxZoom
        minZoom: cfg.minZoom
        noClear: false
        overviewMapControl: !!cfg.overview
        overviewMapControlOptions:
          opened: @getOverviewOpen cfg.overview
        panControl: !!cfg.panControl
        panControlOptions:
          position: @getCtrlPos cfg.panControl
        rotateControl: !!cfg.rotateControl
        rotateControlOptions:
          position: @getCtrlPos cfg.rotateControl
        scaleControl: !!cfg.rotateControl
        scaleControlOptions:
          position: @getCtrlPos cfg.scaleControl
        styles: cfg.styles
        streetViewControl: !!cfg.streetViewControl
        streetViewControlOptions:
          position: @getCtrlPos cfg.streetViewControl
        scrollwheel: cfg.wheel
        zoomControl: !!cfg.zoomControl
        zoomControlOptions:
          position: @getCtrlPos cfg.zoomControl
          style: @getZoomCtrlStyle cfg.zoomControlStyle
        zoom: cfg.zoom

    # ### `#initialize(settings)` ->
    #
    # The settings object may contain a `mapConfig` key that will be used to
    # dynamically specify or override options set in the view constructor.
    #
    # The `mapExtraConfigs` key can be used to supply raw Google Maps API
    # settings. These settings will override any settings that are specified in
    # the view constructor or `mapConfig` keys.
    #
    # The view will also bind its `#render()` method to model's change event so
    # the map will update automatically whenever model data changes.
    #
    initialize: ({@mapExtraConfigs}) ->
      @model.on 'change', @render, this

    # ### `#render(cb)`
    #
    # Renders the map and stores the reference to rendered map as `this.map`.
    #
    # Unlike standard synchronous `#render()` methods, this render method will
    # return `this` before rendering the map. Rendering happens with a slight
    # delay of 1ms, which is not significant, but gives the application enough
    # time to attach `el` to the DOM tree and prevent the map from rendering in
    # a 0-height box (essentially hidden away).
    #
    # A single callback function can be specified which is called as soon as
    # the new map instance is created. The callback will receive three
    # arguments, a reference to the view, a reference to the map instance, and
    # an object containing the configuration used to create the map.
    #
    render: (cb) ->
      if not @map?
        @$el.html if type @template, 'function' then @template() else @template

      setTimeout () =>
        cfg = @getMapOpts @mapExtraConfigs, @model
        if @map?
          @map.setOptions(cfg)
        else
          @map = new maps.Map @getMapContainer(), cfg
        cb(this, @map, cfg) if type cb, 'function'
      , 1

      this

  # ## `MapView`
  #
  # Please see the documentation for [`mapViewMixin`](#mapViewMixin) for more
  # information about this view's API.
  #
  MapView = BaseView.extend mapViewMixin

  # ## Exports
  #
  # This module exports `mixin` and `View` properties.
  #
  mixin: mapViewMixin
  View: MapView

