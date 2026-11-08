import QtQuick
import Quickshell.Io

Indicator
{
	id: root

	property string device: null

	function update()
	{
		process.running = true;
	}

	Component.onCompleted: IpcHandlers.brightness.update.connect(() => root.update())

	Process
	{
		id: process

		command: root.device ? [ "brightnessctl", "--machine", "-d", root.device, "info" ] : [ "brightnessctl", "--machine", "--class", "backlight", "info" ]
		running: true

		stdout: StdioCollector
		{
			waitForEnd: true

			onStreamFinished:
			{
				var info = this.text.split(',');

				root.icons = [ "icons/display-brightness-symbolic.svg" ];
				root.value = parseFloat(info[2]) / parseFloat(info[4]);
			}
		}
	}

	Timer
	{
		interval: 1000
		running: true
		repeat: true

		onTriggered: root.update()
	}
}
