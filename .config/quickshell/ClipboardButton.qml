import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Io

StyledButton
{
	id: root

	property Clipboard clipboard: null

	implicitWidth: icon.implicitWidth + 2*Config.options.clipboard.button.padding
	implicitHeight: icon.implicitHeight + 2*Config.options.clipboard.button.padding

	radius: Config.options.clipboard.button.radius

	onClicked: clipboard?.open()

	Image
	{
		id: icon

		anchors.fill: parent
		anchors.margins: Config.options.clipboard.button.padding

		source: "icons/edit-paste-symbolic.svg"
		sourceSize.width: this.height
		sourceSize.height: this.height
		fillMode: Image.Stretch
	}
}
