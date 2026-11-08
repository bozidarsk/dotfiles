import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Io

StyledButton
{
	id: root

	implicitWidth: icon.implicitWidth + 2*Config.options.annotate.button.padding
	implicitHeight: icon.implicitHeight + 2*Config.options.annotate.button.padding

	radius: Config.options.annotate.button.radius

	onClicked: Utils.runCommand("noctalia msg annotate");

	Image
	{
		id: icon

		anchors.fill: parent
		anchors.margins: Config.options.annotate.button.padding

		source: "icons/document-edit-symbolic.svg"
		sourceSize.width: this.height
		sourceSize.height: this.height
		fillMode: Image.Stretch
	}
}
