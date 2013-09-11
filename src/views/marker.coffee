# # Marker view
#
# This view provides means for display markers and associated info windows.
#
# This module is in UMD format. It will create
# `ribcageGoogleMaps.views.markerView`, `ribcageGoogleMaps.views.MarkerView`,
# and `ribcageGoogleMaps.viewMixins.MarkerView` globals if not used with and
# AMD loader such as RequireJS.
#

define = ((root) ->
  if typeof root.define is 'function' and root.define.amd
    return define
  else
    require = (dep) ->
      (() ->
        switch dep
          when 'dahelpers' then root.dahelpers
          when 'ribcage/views/base' then root.ribcage.views.baseView
          when '../gmaps' then root.google?.maps
          else null
      )() or throw new Error "Unmet dependency #{dep}"
    (factory) ->
      module = factory(require)
      root.ribcageGoogleMaps.views.markerView = module
      root.ribcageGoogleMaps.views.MarkerView = module.View
      root.ribcageGoogleMaps.viewMixins.MarkerView = module.mixin
) this

define (require) ->

  # This module depends on Google Maps JavaScript API v3 library, Underscore,
  # and `ribcage.views.BaseView`.
  #
  {type, empty} = require 'dahelpers'
  {View: BaseView} = require 'ribcage/views/base'
  maps = require '../gmaps'

  # ::TOC::
  #

  # ## `markerViewMixin`
  #
  # This mixin implements the API for the `MapView`.
  #
  # It should be bound to a single model, and the rendering of the marker and
  # associated info window will be taken care of by it.
  #
  markerViewMixin =

    # ### `#initialize(settings)`
    #
    # The `settings` must contain a `map` key which should be a valid
    # `google.maps.Map` object.
    #
    # The `others` key may be passed that points to the superview that manages
    # a marker collection. This is not used in any way by this view, but may be
    # useful if you are doing something in views that extend this constructor.
    #
    # During initialization, the `#render()` method is bound to model's change
    # event and the view is rerendered each time the model is updated.
    #
    initialize: ({@map, @others}) ->
      @model.on 'change', @render, this

    # ### `#markerShadow`
    #
    # Whether marker has a shadow. Default is `false`.
    #
    markerShadow: false

    # ### `#markerAnimation`
    #
    # The animation for the marker. Any of the following values:
    #
    #  + 'bounce'
    #  + 'drop'
    #  + `null` (do not use animation)
    #
    # Default is `null`.
    #
    markerAnimation: null

    # ### `#markerClickable`
    #
    # Whether marker is clickable. Default is `true`
    #
    markerClickable: true

    # ### `#markerDraggable`
    #
    # Whether marker is draggable. Default is `false`
    #
    markerDraggable: false

    # ### `#markerIcon`
    #
    # Sets the marker icon. Can be the URL of the icon, or `google.maps.Icon`
    # or `google.maps.Symbol` object. Default is `null` (use default icon).
    #
    markerIcon: null

    # ### `#markerShape`
    #
    # Image map definiton of the the marker. Must be compatible with
    # `google.maps.MarkerShape`
    # [specification](https://developers.google.com/maps/documentation/javascript/reference#MarkerShape).
    #
    # Default is `null`.
    #
    markerShape: null

    # ### `#markerSize`
    #
    # Sets the marker size if `#markerIcon` is a string. It should be an array
    # of two integers. Default is `null`.
    #
    markerSize: null

    # ### `#markerOrigin`
    #
    # Origin point within the source image. This is used when using sprites, to
    # specify the top left corner of the icon within the sprite. It should be
    # an array of x and y coordinates. Default is `null`.
    #
    markerOrigin: null

    # ### `#markerImageSize`
    #
    # Portion of the source image to use. This is useful when using sprites, to
    # specify the part of the image the sprite corresponds to, along with
    # `#markerOrigin` property. It should be an array of width and height
    # integers. Default is `null`.
    #
    markerImageSize: null

    # ### `#markerAnchor`
    #
    # Sets the anchor point of the marker relative to the image scaled to
    # `#markerSize`. It should be an array of x and y coordinates. Default is
    # `null` which sets the anchor to middle of the image's bottom edge.
    #
    markerAnchor: null

    # ### `#markerVisible`
    #
    # Whether marker is visible by default. Default is `true`.
    #
    # If you choose to not show the marker by default, you can call the
    # [`#show()`](#show) method to show it.
    #
    markerVisible: true

    # ### `#infoTemplateSource`
    #
    # This attribute holds the template source for the info window. It is
    # rendered by Underscore by default.
    #
    # Default value is '' (empty string).
    #
    infoTemplateSource: ''

    # ### `#infoTemplate(data)`
    #
    # Renders the `#infoTemplateSource` using Underscore.
    #
    infoTemplate: (data) ->
      _.template @infoTemplateSource, data

    # ### `#infoWindowAutoPan`
    #
    # Whether info window will automatically pan whe map is panned. Default is
    # `true`We need models attribute not the whole collection.
    #
    infoWindowAutoPan: true

    # ### `#infoWindowOffset`
    #
    # The offset in pixels from the position at which it is rendered. Default
    # is 0.
    #
    infoWindowOffset: 0

    # ### `#createInfoWindow(data)`
    #
    # Create a `google.maps.InfoWindow` object from given context data.
    #
    createInfoWindow: (data) ->
      cfg =
        content: @infoTemplate data
        disableAutoPan: not @infoWindowAutoPan
        maxWidth: @infoWindowWidth
        pixelOffset: @infoWindowOffset

      if @infoWindow?
        @infoWindow.setOptions cfg
        @infoWindow
      else
        new maps.InfoWindow cfg

    # ### `#getPoint(xy)`
    #
    # Returns a `google.maps.Point` object constructed from an array `xy` that
    # contains the x and y coordinates.
    #
    getPoint: (xy) ->
      return null if empty(xy) or not xy?
      [x, y] = xy
      new maps.Point x, y

    # ### `#getSize(xy)`
    #
    # Returns a `google.maps.Size` object constructed from an array `xy` that
    # cotains the width and height.
    #
    getSize: (xy) ->
      return null if empty(xy) or not xy?
      [x, y] = xy
      new maps.Size x, y, 'px', 'px'

    # ### `#getMarkerIcon()`
    #
    # Returns an object compliant with `google.maps.Icon` specification.
    #
    getMarkerIcon: () ->
      if not type(@markerIcon, 'string')
        @markerIcon
      else
        anchor: @getPoint @markerIconAnchor
        origin: @getPoint @markerOrigin
        scaledSize: @getSize @markerSize
        size: @getSize @markerImageSize
        url: @markerIcon


    # ### `#getMarkerAnim(v)`
    #
    # Returns Maps API compatible animation value.
    #
    getMarkerAnim: (v) ->
      return null if not v?
      maps.Animation[v.toUpperCase()]

    # ### `#onClick()`
    #
    # Click event handler for the marker associated with this view.
    #
    # Default implementation opens an info window if one is assocated with the
    # marker.
    #
    onClick: () ->
      if @infoWindow?
        @infoWindow.open @map, @marker

    # ### `#render()`
    #
    # This method renders the marker into the associated map, and optionally
    # creates an info window if mode contains data for it.
    #
    # Note that new instances are not created if they already exist. In such a
    # case, existing instaces are updated. This means that calling `#render()`
    # multiple times will not result in new markers except for the very first
    # time.
    #
    # You generally shouldn't overload this method.
    #
    render: () ->
      cfg =
        map: @map
        position: @model.coords()
        title: @model.title
        animation: @getMarkerAnim @markerAimation
        flat: not @markerShadow
        clickable: @markerClickable
        draggable: @markerDraggable
        icon: @getMarkerIcon()
        shape: @markerShape
        visible: @markerVisible

      if @marker?
        @marker.setOptions cfg
      else
        @marker = new maps.Marker cfg
        maps.event.addListener @marker, 'click', () =>
          @onClick()

      info = @model.get('info')

      if info? and (k for k of info).length
        @infoWindow = @createInfoWindow info
      else
        @infoWindow = null

      this

    # ### `#show()`
    #
    # Show the marker.
    #
    # This method renders the marker first if it hasn't been rendered before.
    #
    show: () ->
      if not @marker?
        @render()
      @marker.setVisible true

    # ### `#hide()`
    #
    # Hide the marker.
    #
    hide: () ->
      return if not @marker
      @marker.setVisible false

    # ### `#remove()`
    #
    # Completely remove the marker from the map, and unbind any bound events
    # from it.
    #
    remove: () ->
      return if not @marker?
      maps.event.clearListeners @marker
      @marker.setMap null
      @marker = null
      @infoWindow?.setMap null
      @infoWindow = null

  # ## `MarkerView`
  #
  # Please see the documentation for [`markerViewMixin`](#markerviewmixin) for
  # more information about this view's API.
  #
  MarkerView = BaseView.extend markerViewMixin

  # ## Exports
  #
  # This module exports `mixin` and `View` properties.
  #
  mixin: markerViewMixin
  View: MarkerView
