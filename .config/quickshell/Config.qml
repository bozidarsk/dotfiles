pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Scope
{
	readonly property alias options: options
	readonly property alias style: style
	readonly property alias file: file

	FileView
	{
		id: file

		path: Quickshell.shellDir + "/config.json"
		watchChanges: true

		onFileChanged: reload()
		onAdapterUpdated: writeAdapter()
		Component.onCompleted: writeAdapter()

		JsonAdapter
		{
			property var style: JsonObject
			{
				id: style

				property var background: '#ee181818'
				property var border: '#454951'
				property var hovered: '#373940'
				property var selected: '#606267'
				property var active: '#89a3c2'
				property var text: 'lightgray'
			}

			property var options: JsonObject
			{
				id: options

				property list<JsonObject> appIcons:
				[
					JsonObject
					{
						property var desktop: "nemo"
						property var icon: "file:///usr/share/icons/hicolor/scalable/apps/nemo.svg"
					},
					JsonObject
					{
						property var desktop: "dev.zed.Zed"
						property var icon: "file:///usr/share/icons/hicolor/512x512/apps/zed.png"
					},
				]

				property var date: JsonObject
				{
					property var format: "%H:%M%n%d/%m/%Y"
					property var margin: 5
					property var padding: 10

					property var border: JsonObject
					{
						property var size: 1
						property var radius: 10
					}

					property var button: JsonObject
					{
						property var padding: 10
						property var radius: 20
					}
				}

				property var controls: JsonObject
				{
					property var margin: 5
					property var padding: 10

					property var border: JsonObject
					{
						property var size: 1
						property var radius: 10
					}

					property var button: JsonObject
					{
						property var padding: 8
						property var spacing: 2
						property var radius: 20
					}
				}

				property var languages: JsonObject
				{
					property var margin: 5
					property var padding: 10

					property var border: JsonObject
					{
						property var size: 1
						property var radius: 10
					}

					property var button: JsonObject
					{
						property var padding: 14
						property var radius: 20
					}
				}

				property var clipboard: JsonObject
				{
					property var margin: 5
					property var padding: 10
					property var maxLength: 30

					property var border: JsonObject
					{
						property var size: 1
						property var radius: 10
					}

					property var button: JsonObject
					{
						property var padding: 14
						property var radius: 20
					}
				}

				property var colorPicker: JsonObject
				{
					property var button: JsonObject
					{
						property var padding: 14
						property var radius: 20
					}
				}

				property var contextMenu: JsonObject
				{
					property var spacing: 5
					property var padding: 5

					property var border: JsonObject
					{
						property var size: 1
						property var radius: 10
					}
				}

				property var appLauncher: JsonObject
				{
					property var margin: 5
					property var padding: 10
					property var position: 1 // 0, 1, 2
					property var icon: "icons/distro-arch.svg"
					property var iconPadding: 10
					property var scrollWidth: 250
					property var scrollHeigth: 400

					property var border: JsonObject
					{
						property var size: 2
						property var radius: 10
					}

					property list<JsonObject> contextMenuOptions:
					[
						JsonObject
						{
							property var name: "Reload Shell"
							property var command: "quickshell ipc call shell reload"
						},
						JsonObject
						{
							property var name: "Exit"
							property var command: "hyprctl dispatch exit"
						},
						JsonObject
						{
							property var name: "Restart"
							property var command: "reboot"
						},
						JsonObject
						{
							property var name: "Power Off"
							property var command: "poweroff"
						},
					]
				}

				property var dock: JsonObject
				{
					property var height: 45
					property var spacing: 10
					property var margin: 10
					property var padding: 8
					property var iconPadding: 5
					property var includeAllWorkspaces: false

					property var border: JsonObject
					{
						property var size: 1
						property var radius: 10
					}

					property var tooltip: JsonObject
					{
						property var margin: 5
						property var padding: 8
					}

					property var apps:
					[
						"Alacritty",
						"nemo",
						"zen",
						"dev.zed.Zed",
						"unityhub",
						"blender",
						"com.obsproject.Studio",
					]
				}
			}
		}
	}
}
