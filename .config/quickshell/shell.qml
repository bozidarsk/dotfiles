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

	IpcHandler
	{
		target: "shell"

		function reload()
		{
			Quickshell.reload(false);
		}
	}
}
