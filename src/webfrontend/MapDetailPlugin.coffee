class MapDetailPlugin extends DetailSidebarPlugin

	getButtonLocaKey: ->
		"map.detail.plugin.button"

	prefName: ->
		"detail_sidebar_show_map"

	isAvailable: ->
		if not @__getConfiguration().enabled
			return false

		assets = @_detailSidebar.object.getAssetsForBrowser("detail")
		return assets and assets.length > 0

	isDisabled: ->
		markersOptions = @__getMarkerOptions()
		markersOptions.length == 0

	hideDetail: ->
		@_detailSidebar.mainPane.empty("top")

	renderObject: ->
		if @__map
			@__map.destroy()
			@__mapFullscreen?.destroy()
		markersOptions = @__getMarkerOptions()
		if markersOptions.length == 0
			return

		@__map = new CUI.LeafletMap
			class: "ez5-detail-map-plugin"
			clickable: false,
			markersOptions: markersOptions,
			zoomToFitAllMarkersOnInit: true,
			zoomControl: false

		zoomButtons = @__getZoomButtons()
		@__zoomButtonbar = new CUI.Buttonbar(class: "ez5-detail-map-plugin-zoom-buttons", buttons: zoomButtons)
		@__zoomButtonbar.addButton(
			loca_key: "map.detail.plugin.fullscreen.open.button"
			group: "fullscreen"
			onClick: =>
				@__mapFullscreen = new MapFullscreen(
					map: @__map
					zoomButtons: zoomButtons
					onClose: => @showDetail()
				)
				@__mapFullscreen.render()
		)

	showDetail: ->
		if not @__map
			return
		@_detailSidebar.mainPane.replace([@__zoomButtonbar, @__map], "top")
		@__map.resize()

	__getMarkerOptions: ->
		assets = @_detailSidebar.object.getAssetsForBrowser("detail")

		markersOptions = []
		for asset in assets
			gps_location = asset.value.technical_metadata.gps_location
			if gps_location and gps_location.latitude and gps_location.longitude
				do(asset) =>
					options =
						position:
							lat: gps_location.latitude,
							lng: gps_location.longitude
						cui_onClick: =>
							CUI.Events.trigger
								node: @_detailSidebar.container
								type: "asset-browser-show-asset"
								info:
									value: asset.value

					if asset.value.versions.small
						iconSize = ez5.fitRectangle(asset.value.versions.small.width, asset.value.versions.small.height, 30, 30)
						options.icon = L.icon(iconUrl: asset.value.versions.small.url, iconSize: iconSize)

					markersOptions.push(options)

		markersOptions

	__getZoomButtons: ->
		[
			loca_key: "map.detail.plugin.zoom.plus.button"
			group: "zoom"
			onClick: =>
				@__map.zoomIn()
		,
			loca_key: "map.detail.plugin.zoom.reset.button"
			group: "zoom"
			onClick: =>
				@__map.zoomToFitAllMarkers()
		,
			loca_key: "map.detail.plugin.zoom.minus.button"
			group: "zoom"
			onClick: =>
				@__map.zoomOut()
		]

	__getConfiguration: ->
		ez5.session.getBaseConfig().system["detail_map"] or {}

ez5.session_ready =>
	DetailSidebar.plugins.registerPlugin(MapDetailPlugin)