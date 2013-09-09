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
    # During initialization, the `#render()` method is bound to model's change
    # event and the view is rerendered each time the model is updated.
    #
    initialize: ({@map}) ->
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

    # ### `markerShape`
    #
    # Image map definiton of the the marker. Must be compatible with
    # `google.maps.MarkerShape`
    # [specification](https://developers.google.com/maps/documentation/javascript/reference#MarkerShape).
    #
    # Default is `null`.
    #
    markerShape: null

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
      _.template @infoTemplateSource data

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

    # ### `createInfoWindow(data)`
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
      if @infoWindow
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
        icon: @markerIcon
        shape: @markerShape
        visible: @markerVisible

      if @marker?
        @marker.setOptions cfg
      else
        @marker = new maps.Marker cfg
        maps.event.addListener @marker, 'click', () =>
          @onClick()

      if @model.info? and (k for k of @model.info).length
        @infoWindow = @createInfoWindow @model.get 'info'
      else
        @infoWindow = null

    show: () ->
      if not @marker?
        @render()
      @marker.setVisible true

    hide: () ->
      return if not @marker
      @marker.setVisible false

    remove: () ->
      return if not @marker?
      maps.event.clearListeners @marker
      @marker.setMap null
      @marker = null
      @infoWindow?.setMap null
      @infoWindow = null

  MarkerView = BaseView.extend markerViewMixin

  mixin: markerViewMixin
  View: MarkerView
