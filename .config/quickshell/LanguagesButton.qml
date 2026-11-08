import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Io

StyledButton
{
	id: root

	property Languages languages: null

	implicitWidth: label.contentWidth + 2*Config.options.languages.button.padding
	implicitHeight: label.contentHeight + 2*Config.options.languages.button.padding

	radius: Config.options.languages.button.radius

	onClicked: languages?.open()

	function update()
	{
		process.running = true;
	}

	Component.onCompleted: IpcHandlers.languages.update.connect(() => root.update())

	Label
	{
		id: label

		anchors.fill: parent
		anchors.margins: Config.options.languages.button.padding

		horizontalAlignment: Text.AlignHCenter
		verticalAlignment: Text.AlignVCenter

		text: "en"
		color: Config.style.text
		// font.pixelSize: this.height / 2

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

					const keyboard = json.keyboards.find(x => x.main);

					label.text = keyboard.layout.split(", ")[keyboard.active_layout_index];
				}
			}
		}

		Timer
		{
			id: timer

			interval: 1000
			running: true
			repeat: true

			onTriggered: process.running = true
		}
	}
}
