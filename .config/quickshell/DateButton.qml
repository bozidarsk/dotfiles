import QtQuick
import QtQuick.Controls
import Quickshell
import Quickshell.Io

StyledButton
{
	id: root

	property Date date: null

	implicitWidth: label.contentWidth + 2*Config.options.date.button.padding
	implicitHeight: label.contentHeight + 2*Config.options.date.button.padding

	radius: Config.options.date.button.radius

	onClicked: date?.open()

	function update()
	{
		process.running = true;
	}

	Label
	{
		id: label

		anchors.fill: parent
		anchors.margins: Config.options.date.button.padding

		horizontalAlignment: Text.AlignHCenter
		verticalAlignment: Text.AlignVCenter

		text: ""
		color: Config.style.text
		// font.pixelSize: this.height / 2

		Process
		{
			id: process

			command: [ "date", `+${Config.options.date.format}` ]
			running: true

			stdout: StdioCollector
			{
				waitForEnd: true

				onStreamFinished: label.text = this.text
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
