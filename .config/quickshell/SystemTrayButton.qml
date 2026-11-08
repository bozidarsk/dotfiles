import QtQuick

StyledButton
{
	id: root

	property SystemTray systemTray: null

	implicitWidth: icon.implicitWidth + 2*Config.options.systemTray.button.padding
	implicitHeight: icon.implicitHeight + 2*Config.options.systemTray.button.padding

	radius: Config.options.systemTray.button.radius

	onClicked: systemTray?.open()

	Image
	{
		id: icon

		anchors.fill: parent
		anchors.margins: Config.options.systemTray.button.padding

		source: "icons/go-up-symbolic.svg"
		sourceSize.width: this.height
		sourceSize.height: this.height
		fillMode: Image.Stretch
	}
}
