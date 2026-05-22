import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Io

StyledButton
{
	id: root

	implicitWidth: icon.implicitWidth + 2*Config.options.colorPicker.button.padding
	implicitHeight: icon.implicitHeight + 2*Config.options.colorPicker.button.padding

	radius: Config.options.colorPicker.button.radius

	onClicked: Utils.runCommand("hyprpicker | wl-copy");

	Image
	{
		id: icon

		anchors.fill: parent
		anchors.margins: Config.options.colorPicker.button.padding

		source: "icons/color-select-symbolic.svg"
		sourceSize.width: this.height
		sourceSize.height: this.height
		fillMode: Image.Stretch
	}
}
