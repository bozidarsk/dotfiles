import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Io

Indicator
{
	id: root

	property StyledOverlay overlay: null
	property var device: null

	function update()
	{
		process.running = true;
	}

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
				var value = parseFloat(info[2]) / parseFloat(info[4]);

				icon.source = "icons/display-brightness-symbolic.svg";
				label.text = `${Math.round(value * 100.0)}%`;
				level.value = value;

				if (overlay)
				{
					overlay.icon.source = icon.source;
					overlay.label.text = label.text;
					overlay.level.value = level.value;
				}
			}
		}
	}

	Timer
	{
		id: timer

		interval: 1000
		running: true
		repeat: true

		onTriggered: root.update()
	}
}
