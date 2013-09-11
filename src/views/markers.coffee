# # MarkersView
#
# This is a superview that renders multiple marker views for a collection of
# markers.
#
# This module is in UMD format. It will create
# `ribcageGoogleMaps.views.markersView`, `ribcageGoogleMaps.views.MarkersView`,
# and `ribcageGoogleMaps.viewMixins.MarkerView` globals if not used with an AMD
# loader such as RequireJS.
#

define = ((root) ->
  if typeof root.define is 'function' and root.define.amd
    return define
  else
    require = (dep) ->
      (() ->
        switch dep
          when 'ribcage/views/base' then root.ribcage.views.baseView
          when './marker' then root.ribcageGoogleMaps.views.markerView
          else null
      )() or throw new Error "Unmet dependency #{dep}"
    (factory) ->
      module = factory(require)
      root.ribcageGoogleMaps.views.markersView = module
      root.ribcageGoogleMaps.views.MarkersView = module.View
      root.ribcageGoogleMaps.viewMixins.MarkersView = module.mixin
) this

define (require) ->

  # This module depends on `ribcage.views.BaseView` and
  # `ribcageGoogleMaps.views.MarkerView`.
  #
  {View: BaseView} = require 'ribcage/views/base'
  {View: MarkerView} = require './marker'

  # ## `markersViewMixin`
  #
  # This mixin implements the API for the `MarkersView`.
  #
  # The subview used for each marker can be specified or dinamically
  # calculated. It defaults to the default `MarkerView`.
  #
  markersViewMixin =

    # ### `#initialize(settings)`
    #
    # The settings should contain a `map` key which points to a valid
    # `google.maps.Map` object.
    #
    # During initalization, the `change`, `add`, and `remove` events triggered
    # on the collection are bound to `#render()` method, which causes the view
    # to renrender all markers.
    #
    initialize: ({@map}) ->
      @collection.on 'change', @render, this

    # ### `markerView`
    #
    # View used for rendering each marker. Default is `MarkerView`.
    #
    markerView: MarkerView

    # ### `#getMarkerView(attributes)`
    #
    # Returns a view to be used for rendering markers. It is passed an
    # `attributes` object which contains the model's attributes.
    #
    # Default implementation returns the `#markerView` attribute.
    #
    getMarkerView: (attributes) ->
      @markerView

    # ### `#childViews`
    #
    # This property houses all child views.
    #
    childViews: []

    # ### `#render()`
    #
    # Renders all marker views.
    #
    render: () ->
      @remove()
      @childViews = (
        ((m) =>
          View = @getMarkerView m.toJSON()
          marker = new View
            model: m
            map: @map
            others: this
          marker.render()
          marker
        ) m for m in @collection.models
      )

      this

    # ### `#remove()`
    #
    # Removes all child views and their markers.
    #
    remove: () ->
      view.remove() for view in @childViews
      @childViews = []

  # ## `MarkersView`
  #
  # Please see documentation for [`markersViewMixin`](#markersViewMixin) for
  # more information about this view's API.
  #
  MarkersView = BaseView.extend markersViewMixin

  # ## Exports
  #
  # This module exports `mixin` and `View` properties.
  #
  mixin: markersViewMixin
  View: MarkersView
