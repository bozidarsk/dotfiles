import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Io

StyledPopup
{
	id: root

	property alias soundIndicator: soundIndicator
	property alias brightnessIndicator: brightnessIndicator

	direction: Edges.Top
	layerNamespace: "controls"

	margin: Config.options.controls.margin
	padding: Config.options.controls.padding
	radius: Config.options.controls.border.radius
	border.width: Config.options.controls.border.size
	border.color: Config.style.border

	implicitWidth: items.implicitWidth
	implicitHeight: items.implicitHeight

	ColumnLayout
	{
		id: items

		anchors.fill: parent

		spacing: 10

		Component.onCompleted:
		{
			root.implicitWidth = items.implicitWidth;
			root.implicitHeight = items.implicitHeight;
		}

		SoundIndicator
		{
			id: soundIndicator

			overlay: root.soundOverlay

			Layout.fillWidth: true
			Layout.fillHeight: true
		}

		BrightnessIndicator
		{
			id: brightnessIndicator

			overlay: root.brightnessOverlay

			Layout.fillWidth: true
			Layout.fillHeight: true
		}

		GridLayout
		{
			id: buttonGrid

			columns: 2
			columnSpacing: items.spacing
			uniformCellWidths: true

			rows: 2
			rowSpacing: items.spacing
			uniformCellHeights: true

			Layout.fillWidth: true
			Layout.fillHeight: true

			Repeater
			{
				model:
				[
					{
						icon: "icons/network-wireless-symbolic.svg",
						label: "Wi-Fi",
						onClicked: () => console.log("Wi-Fi"),
						menu: wifiMenu
					},
					{
						icon: "icons/bluetooth-symbolic.svg",
						label: "Bluetooth",
						onClicked: () => console.log("Bluetooth"),
						menu: bluetoothMenu
					},
					{
						icon: "icons/airplane-mode-symbolic.svg",
						label: "Airplane Mode",
						onClicked: () => console.log("Airplane Mode"),
						menu: null
					},
					{
						icon: "icons/night-light-symbolic.svg",
						label: "Nightlight",
						onClicked: () => console.log("Nightlight"),
						menu: null
					},
				]

				StyledButton
				{
					implicitWidth: buttonItems.implicitWidth + 2*buttonItems.anchors.margins
					implicitHeight: buttonItems.implicitHeight + 2*buttonItems.anchors.margins

					Layout.fillWidth: true
					Layout.fillHeight: true

					Layout.column: index % buttonGrid.columns
					Layout.row: index / buttonGrid.columns

					onClicked: modelData.onClicked()

					RowLayout
					{
						id: buttonItems

						anchors.fill: parent

						spacing: 8

						Component.onCompleted: if (modelData.menu) modelData.menu.relativeTo = this

						Image
						{

							source: modelData.icon
							sourceSize.width: this.height
							sourceSize.height: this.height
							fillMode: Image.Stretch

							Layout.topMargin: 10
							Layout.bottomMargin: 10
							Layout.leftMargin: 10
							Layout.fillHeight: true
						}

						Label
						{

							horizontalAlignment: Qt.AlignHLeft
							verticalAlignment: Qt.AlignVCenter

							text: modelData.label
							color: Config.style.text

							Layout.topMargin: 10
							Layout.bottomMargin: 10
							Layout.rightMargin: 10
							Layout.fillWidth: true
							Layout.fillHeight: true
						}

						VerticalSeparator
						{
							visible: modelData.menu

							Layout.leftMargin: 8
							Layout.alignment: Qt.AlignRight
							Layout.fillHeight: true
						}

						StyledButton
						{
							implicitWidth: menuButtonIcon.implicitWidth + 2*menuButtonIcon.anchors.margins
							implicitHeight: menuButtonIcon.implicitHeight + 2*menuButtonIcon.anchors.margins

							visible: modelData.menu

							Layout.alignment: Qt.AlignRight
							Layout.fillHeight: true

							onClicked: modelData.menu.open()

							Image
							{
								id: menuButtonIcon

								anchors.fill: parent
								anchors.margins: 10

								fillMode: Image.Stretch
								sourceSize.width: this.height
								sourceSize.height: this.height
								source: "icons/go-next-symbolic.svg"
							}
						}
					}
				}
			}
		}
	}

	Item
	{
		StyledPopup
		{
			id: wifiMenu

			relativeLayerNamespace: root.layerNamespace
			relativeTo: root.relativeTo

			implicitWidth: wifiLabel.contentWidth
			implicitHeight: wifiLabel.contentHeight
			Label { id: wifiLabel; text: "WIFI"; color: 'white' }
		}

		StyledPopup
		{
			id: bluetoothMenu

			relativeLayerNamespace: root.layerNamespace
			relativeTo: root.relativeTo

			implicitWidth: bluetoothLabel.contentWidth
			implicitHeight: bluetoothLabel.contentHeight
			Label { id: bluetoothLabel; text: "BLUETOOTH"; color: 'white' }
		}
	}
}
