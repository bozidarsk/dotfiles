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

	Component.onCompleted: IpcHandlers.shell.update.connect(() => process.running = true)

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

			Component.onCompleted: IpcHandlers.appLauncher.run.connect(index =>
				{
					var apps = pinnedApps.children.filter(x => x.clicked).concat(openedApps.children.filter(x => x.clicked));

					if (index >= 0 && index < apps.length)
						apps[index].clicked();
				}
			)

			RowLayout
			{
				id: left

				spacing: Config.options.dock.padding

				Layout.alignment: Qt.AlignLeft
				Layout.fillHeight: true

				AppLauncherButton
				{
					id: appLauncherButton

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

				SystemTrayButton
				{
					id: systemTrayButton

					systemTray: SystemTray
					{
						relativeLayerNamespace: root.layerNamespace
						relativeTo: systemTrayButton
					}

					Layout.fillHeight: true
					Layout.preferredWidth: height
				}

				AnnotateButton
				{
					id: annotateButton

					Layout.fillHeight: true
					Layout.preferredWidth: height
				}

				ColorPickerButton
				{
					id: colorPickerButton

					Layout.fillHeight: true
					Layout.preferredWidth: height
				}

				ClipboardButton
				{
					id: clipboardButton

					Layout.fillHeight: true
					Layout.preferredWidth: height
				}

				LanguagesButton
				{
					id: languagesButton

					languages: Languages
					{
						relativeLayerNamespace: root.layerNamespace
						relativeTo: languagesButton
					}

					Layout.fillHeight: true
					Layout.preferredWidth: height
				}

				ControlsButton
				{
					id: controlsButton

					Layout.fillHeight: true

					StyledOverlay
					{
						id: rfkillOverlay

						implicitWidth: 25
						implicitHeight: 25

						icon.source: "icons/airplane-mode-disabled-symbolic.svg"
						level.visible: false
						label.visible: false

						Component.onCompleted: IpcHandlers.rfkill.update.connect(() =>
							{
								rfkillProcess.running = true;
								rfkillOverlay.open();
							}
						)

						Process
						{
							id: rfkillProcess

							command: [ "rfkill", "-J" ]
							running: true

							stdout: StdioCollector
							{
								waitForEnd: true

								onStreamFinished:
								{
									const json = JSON.parse(this.text);
									rfkillOverlay.icon.source = (json.rfkilldevices[0].soft === "unblocked") ? "icons/airplane-mode-disabled-symbolic.svg" : "icons/airplane-mode-symbolic.svg";
								}
							}
						}
					}

					StyledOverlay
					{
						id: touchpadtoggleOverlay

						implicitWidth: 25
						implicitHeight: 25

						icon.source: "icons/input-touchpad-symbolic.svg"
						level.visible: false
						label.visible: false

						Component.onCompleted: IpcHandlers.touchpadtoggle.update.connect(state =>
							{
								touchpadtoggleOverlay.icon.source = state ? "icons/input-touchpad-symbolic.svg" : "icons/touchpad-disabled-symbolic.svg";
								touchpadtoggleOverlay.open();
							}
						)
					}
				}

				DateButton
				{
					id: dateButton

					Layout.fillHeight: true
				}
			}
		}
	}

	Process
	{
		id: process

		command: [ "hyprctl", "-j", "activewindow" ]
		running: false

		stdout: StdioCollector
		{
			waitForEnd: true

			onStreamFinished:
			{
				var json = JSON.parse(this.text);

				console.log(json.fullscreen);

				root.WlrLayershell.layer = (json.fullscreen === 1) ? WlrLayer.Overlay : WlrLayer.Top;
			}
		}
	}
}
