import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell

Item
{
	id: root

	property bool hasIcon: true
	property bool hasLabel: true
	property bool hasLevel: true

	property StyledOverlay overlay: null

	property list<string> icons: []
	property real value: 0

	implicitWidth: items.implicitWidth
	implicitHeight: items.implicitHeight

	onValueChanged: private.update()
	onIconsChanged: private.update()

	Scope
	{
		id: private

		function update()
		{
			icon.source = root.icons[Math.round((root.icons.length - 1) * root.value)] ?? "icons/image-missing-symbolic.svg";
			label.text = `${Math.round(root.value * 100.0)}%`;
			level.value = root.value;

			if (root.overlay)
			{
				root.overlay.icon.source = icon.source;
				root.overlay.label.text = label.text;
				root.overlay.level.value = level.value;
			}
		}
	}

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

				visible: root.hasIcon

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

				visible: root.hasLabel

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

				visible: root.hasLevel

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
