import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Io
import Quickshell.Services.UPower
import Quickshell.Services.Pipewire

StyledButton
{
	id: root

	property Controls controls: null

	property alias soundIndicator: soundIndicator
	property alias batteryIndicator: batteryIndicator

	implicitWidth: icons.implicitWidth + 2*Config.options.controls.button.padding
	implicitHeight: icons.implicitHeight + 2*Config.options.controls.button.padding

	radius: Config.options.controls.button.radius

	onClicked: controls?.open()

	RowLayout
	{
		id: icons

		anchors.fill: parent
		anchors.margins: Config.options.controls.button.padding

		spacing: Config.options.controls.button.spacing

		// Image
		// {
		// 	source: "icons/network-wireless-signal-excellent-symbolic.svg"
		// 	fillMode: Image.Stretch

		// 	Layout.fillHeight: true
		// 	Layout.preferredWidth: height
		// }

		SoundIndicator
		{
			id: soundIndicator

			enabled: false

			label.visible: false
			level.visible: false

			Layout.fillHeight: true
		}

		BatteryIndicator
		{
			id: batteryIndicator

			enabled: false

			label.visible: false
			level.visible: false

			Layout.fillHeight: true
		}
	}
}
