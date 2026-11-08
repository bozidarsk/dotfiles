import QtQuick
import QtQuick.Layouts
import Quickshell.Services.Pipewire

StyledButton
{
	id: root

	property alias audioSourceIndicator: audioSourceIndicator
	property alias audioSinkIndicator: audioSinkIndicator
	property alias batteryIndicator: batteryIndicator

	implicitWidth: icons.implicitWidth + 2*Config.options.controls.button.padding
	implicitHeight: icons.implicitHeight + 2*Config.options.controls.button.padding

	radius: Config.options.controls.button.radius

	onClicked: Utils.togglePanel(Config.options.panels.controls)

	RowLayout
	{
		id: icons

		anchors.fill: parent
		anchors.margins: Config.options.controls.button.padding

		spacing: Config.options.controls.button.spacing

// 		Image
// 		{
// 			source: "icons/network-wireless-signal-excellent-symbolic.svg"
// 			fillMode: Image.Stretch
//
// 			Layout.fillHeight: true
// 			Layout.preferredWidth: height
// 		}

		SoundIndicator
		{
			id: audioSourceIndicator

			device: Pipewire.defaultAudioSource

			enabled: false

			hasLabel: false
			hasLevel: false

			Layout.fillHeight: true
		}

		SoundIndicator
		{
			id: audioSinkIndicator

			enabled: false

			hasLabel: false
			hasLevel: false

			Layout.fillHeight: true
		}

		BatteryIndicator
		{
			id: batteryIndicator

			enabled: false

			hasLabel: false
			hasLevel: false

			Layout.fillHeight: true
		}
	}
}
