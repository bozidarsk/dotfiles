import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Io

StyledPopup
{
	id: root

	property var xkbLayouts

	direction: Edges.Top

	margin: Config.options.languages.margin
	padding: Config.options.languages.padding
	radius: Config.options.languages.border.radius
	border.width: Config.options.languages.border.size
	border.color: Config.style.border

	implicitWidth: items.implicitWidth
	implicitHeight: items.implicitHeight

	onIsOpenChanged: process.running = true

	ColumnLayout
	{
		id: items

		anchors.fill: parent

		Repeater
		{
			id: repeater

			model: []

			StyledButton
			{
				implicitWidth: labels.implicitWidth + 2*labels.anchors.margins
				implicitHeight: labels.implicitHeight + 2*labels.anchors.margins

				onClicked:
				{
					Utils.runCommand("hyprctl switchxkblayout all " + modelData.index);
					Utils.runCommand("quickshell ipc call languages update");
					root.close();
				}

				RowLayout
				{
					id: labels

					anchors.fill: parent
					anchors.margins: 5

					spacing: 20

					Label
					{
						horizontalAlignment: Text.AlignHLeft
						verticalAlignment: Text.AlignVCenter

						text: modelData.description
						color: Config.style.text

						Layout.fillWidth: true
						Layout.fillHeight: true
					}

					Label
					{
						horizontalAlignment: Text.AlignHLeft
						verticalAlignment: Text.AlignVCenter

						text: modelData.layout
						color: Config.style.text

						Layout.fillHeight: true
						Layout.preferredWidth: height
						Layout.alignment: Qt.AlignRight
					}
				}

				Layout.fillWidth: true
				Layout.fillHeight: true
			}
		}
	}

	Item
	{
		Process
		{
			id: process

			command: [ "hyprctl", "-j", "devices" ]
			running: true

			stdout: StdioCollector
			{
				waitForEnd: true

				onStreamFinished:
				{
					var json = JSON.parse(this.text);

					var layouts = json.keyboards[0].layout.split(", ");
					var variants = json.keyboards[0].variant.split(", ");

					if (layouts.length !== variants.length)
						return;

					var languages = [];

					for (var i = 0; i < layouts.length; i++)
					{
						var xkbLayout = root.xkbLayouts.find(x => x.layout === layouts[i] && x.variant === variants[i]);

						languages.push(
							{
								layout: xkbLayout.layout,
								description: xkbLayout.description,
								index: i
							}
						);
					}

					repeater.model = languages;
					root.update();
				}
			}
		}
	}

	Item
	{
		Process
		{
			command: [ "sh", "-c", "xkbcli list | grep '\\- layout:' -A 5 | grep -vE '^\\s+iso[0-9]+' | sed -E 's/- (layout:)/  \\1/' | sed -E 's/description: (.+)/description: \"\\1\\\"/' | tr -d '\\n' | perl -pe \"s/\\s*layout: '([^']+)'\\s+variant: '([^']*)'\\s+brief: '([^']*)'\\s+description: \\\"([^\\\"]*)\\\"\\s*/{ \\\"layout\\\": \\\"\\1\\\", \\\"variant\\\": \\\"\\2\\\", \\\"brief\\\": \\\"\\3\\\", \\\"description\\\": \\\"\\4\\\" },\n/g\"" ]
			running: true

			stdout: StdioCollector
			{
				waitForEnd: true

				onStreamFinished: root.xkbLayouts = JSON.parse("[" + this.text + "{}" + "]")
			}
		}
	}
}
