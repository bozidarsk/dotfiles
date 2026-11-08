//@ pragma UseQApplication

import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Window
import Quickshell
import Quickshell.Io

// QML_XHR_ALLOW_FILE_READ=1
// QT_SCALE_FACTOR=1

ShellRoot
{
	Variants
	{
		model: Quickshell.screens

		Taskbar
		{
			screen: modelData
		}
	}

	// IpcHandlers {}

	IpcHandler
	{
		target: "shell"

		function reload()
		{
			Quickshell.reload(false);
		}

		function update()
		{
			IpcHandlers.shell.update();
		}
	}

	IpcHandler
	{
		target: "appLauncher"

		function toggle()
		{
			Utils.togglePanel(Config.options.panels.appLauncher);

			IpcHandlers.appLauncher.toggle();
		}

		function run(index: int)
		{
			IpcHandlers.appLauncher.run(index);
		}
	}

	IpcHandler
	{
		target: "languages"

		function update()
		{
			IpcHandlers.languages.update();
		}
	}

	IpcHandler
	{
		target: "clipboard"

		function toggle()
		{
			Utils.togglePanel(Config.options.panels.clipboard);

			IpcHandlers.clipboard.toggle();
		}
	}

	IpcHandler
	{
		target: "controls"

		function toggle()
		{
			Utils.togglePanel(Config.options.panels.controls);

			IpcHandlers.controls.toggle();
		}
	}

	IpcHandler
	{
		target: "date"

		function toggle()
		{
			Utils.togglePanel(Config.options.panels.date);

			IpcHandlers.date.toggle();
		}
	}

	IpcHandler
	{
		target: "sound"

		function update()
		{
			IpcHandlers.sound.update();
		}
	}

	IpcHandler
	{
		target: "battery"

		function update()
		{
			IpcHandlers.battery.update();
		}
	}

	IpcHandler
	{
		target: "brightness"

		function update()
		{
			IpcHandlers.brightness.update();
		}
	}

	IpcHandler
	{
		target: "rfkill"

		function update()
		{
			IpcHandlers.rfkill.update();
		}
	}

	IpcHandler
	{
		target: "touchpadtoggle"

		function update(state: bool)
		{
			IpcHandlers.touchpadtoggle.update(state);
		}
	}
}
