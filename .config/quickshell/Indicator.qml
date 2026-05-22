import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell

Item
{
	id: root

	property alias icon: icon
	property alias label: label
	property alias level: level

	property bool readonly: false // if the user can move the slider (TODO)

	implicitWidth: items.implicitWidth
	implicitHeight: items.implicitHeight

	RowLayout
	{
		id: items

		anchors.fill: parent

		spacing: (label.visible || level.visible) ? 10 : 0

		StyledButton
		{
			implicitWidth: icon.implicitWidth + 2*icon.anchors.margins
			implicitHeight: icon.implicitHeight + 2*icon.anchors.margins

			enabled: root.enabled

			Layout.fillHeight: true
			Layout.preferredWidth: height

			Image
			{
				id: icon

				anchors.fill: parent
				anchors.margins: 5

				source: "icons/image-missing-symbolic.svg"
				sourceSize.width: height
				sourceSize.height: height
				fillMode: Image.Stretch
			}
		}

		ColumnLayout
		{
			Label
			{
				id: label

				horizontalAlignment: Text.AlignHCenter
				verticalAlignment: Text.AlignVCenter

				text: ""
				color: Config.style.text

				Layout.fillWidth: true
				Layout.alignment: Qt.AlignCenter
			}

			Item
			{
				id: level

				property real value: 0.0

				implicitHeight: 3

				onValueChanged: fg.anchors.rightMargin = level.width * (1.0 - level.value)

				Rectangle
				{
					id: bg

					anchors.fill: parent

					color: Config.style.border
					radius: 10
				}

				Rectangle
				{
					id: fg

					anchors.fill: parent

					color: Config.style.active
					radius: 10
				}

				Layout.fillWidth: true
			}

			Layout.fillWidth: true
			Layout.fillHeight: true
		}
	}
}
