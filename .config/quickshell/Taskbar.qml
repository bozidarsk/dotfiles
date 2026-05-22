import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Wayland

PanelWindow
{
	id: root

	property var modelData
	property string layerNamespace: "dock"

	aboveWindows: true
	focusable: false

	WlrLayershell.layer: WlrLayer.Top
	WlrLayershell.namespace: root.layerNamespace

	color: 'transparent'

	margins.left: Config.options.dock.margin
	margins.right: Config.options.dock.margin
	margins.bottom: Config.options.dock.margin
	anchors.bottom: true
	anchors.left: true
	anchors.right: true

	implicitHeight: Config.options.dock.height + 2*Config.options.dock.padding + 2*Config.options.dock.border.size

	Rectangle
	{
		id: background

		anchors.fill: parent

		color: Config.style.background
		border.color: Config.style.border
		border.width: Config.options.dock.border.size
		radius: Config.options.dock.border.radius

		RowLayout
		{
			id: items

			anchors.fill: parent
			anchors.margins: Config.options.dock.padding + Config.options.dock.border.size

			spacing: Config.options.dock.padding

			RowLayout
			{
				id: left

				spacing: Config.options.dock.padding

				Layout.alignment: Qt.AlignLeft
				Layout.fillHeight: true

				AppLauncherButton
				{
					id: appLauncherButton

					launcher: appLauncher

					contextMenu.relativeLayerNamespace: root.layerNamespace
					contextMenu.relativeTo: appLauncherButton

					Layout.fillHeight: true
					Layout.preferredWidth: height
				}

				VerticalSeparator
				{
					Layout.fillHeight: true
				}

				PinnedApps
				{
					id: pinnedApps

					Layout.fillHeight: true

					relativeLayerNamespace: root.layerNamespace
				}

				VerticalSeparator
				{
					Layout.fillHeight: true
					visible: openedApps.visible
				}

				OpenedApps
				{
					id: openedApps

					Layout.fillHeight: true
					visible: openedApps.count > 0

					relativeLayerNamespace: root.layerNamespace
				}
			}

			RowLayout
			{
				id: right

				spacing: 5

				Layout.alignment: Qt.AlignRight
				Layout.fillHeight: true

				ColorPickerButton
				{
					id: colorPickerButton

					Layout.fillHeight: true
					Layout.preferredWidth: height
				}

				ClipboardButton
				{
					id: clipboardButton

					clipboard: Clipboard
					{
						id: clipboard

						relativeLayerNamespace: root.layerNamespace
						relativeTo: clipboardButton
					}

					Layout.fillHeight: true
					Layout.preferredWidth: height
				}

				LanguagesButton
				{
					id: languagesButton

					languages: Languages
					{
						id: languages

						relativeLayerNamespace: root.layerNamespace
						relativeTo: languagesButton
					}

					Layout.fillHeight: true
					Layout.preferredWidth: height

					IpcHandler
					{
						target: "languages"

						function update()
						{
							languagesButton.update();
						}
					}
				}

				ControlsButton
				{
					id: controlsButton

					controls: Controls
					{
						id: controls

						soundIndicator.overlay: StyledOverlay
						{
							id: soundOverlay

							implicitWidth: 130
							implicitHeight: 25

							label.visible: false

							IpcHandler
							{
								target: "sound"

								function update()
								{
									controls.soundIndicator.update();
									controlsButton.soundIndicator.update();
									soundOverlay.open();
								}
							}
						}

						brightnessIndicator.overlay: StyledOverlay
						{
							id: brightnessOverlay

							implicitWidth: 130
							implicitHeight: 25

							icon.source: "icons/display-brightness-symbolic.svg"
							label.visible: false

							IpcHandler
							{
								target: "brightness"

								function update()
								{
									controls.brightnessIndicator.update();
									brightnessOverlay.open();
								}
							}
						}

						relativeLayerNamespace: root.layerNamespace
						relativeTo: controlsButton
					}

					Layout.fillHeight: true
				}

				DateButton
				{
					id: dateButton

					date: Date
					{
						id: date

						relativeLayerNamespace: root.layerNamespace
						relativeTo: dateButton
					}

					Layout.fillHeight: true

					IpcHandler
					{
						target: "date"

						function update()
						{
							dateButton.update();
						}
					}
				}
			}
		}
	}

	AppLauncher
	{
		id: appLauncher

		margin: Config.options.dock.padding + Config.options.dock.border.size + Config.options.appLauncher.margin

		relativeLayerNamespace: root.layerNamespace
		relativeTo:
		{
			switch (Config.options.appLauncher.position)
			{
				case 0: return background;
				case 1: return appLauncherButton;
				case 2: return items;
				default: return null;
			}
		}
	}

	IpcHandler
	{
		target: "appLauncher"

		function open() { appLauncher.open(); }
		function close() { appLauncher.close(); }

		function toggle()
		{
			if (appLauncher.isOpen)
				appLauncher.close();
			else
				appLauncher.open();
		}

		function run(index: int)
		{
			const appButtons = pinnedApps.children.filter(x => x.clicked).concat(openedApps.children.filter(x => x.clicked))

			if (index < 0 || index >= appButtons.length)
				return;

			appButtons[index].clicked();
		}
	}
}
