import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell

Scope
{
	id: root

	property alias icon: icon
	property alias level: level
	property alias label: label

	required property int implicitWidth
	required property int implicitHeight
	property int x: (window.screen.width - window.implicitWidth) / 2
	property int y: window.screen.height - 150
	property int padding: 10
	property int duration: 1500

	readonly property bool isOpen: window.visible

	function open()
	{
		window.visible = true;
		timer.restart();
	}

	function close()
	{
		window.visible = false;
	}

	PanelWindow
	{
		id: window

		visible: false
		aboveWindows: true
		focusable: false

		anchors.top: true
		anchors.left: true
		margins.top: root.y
		margins.left: root.x

		implicitWidth: root.implicitWidth + 2*root.padding + 2*background.border.width
		implicitHeight: root.implicitHeight + 2*root.padding + 2*background.border.width

		color: 'transparent'

		Rectangle
		{
			id: background

			anchors.fill: parent

			color: Config.style.background
			radius: Config.options.contextMenu.border.radius
			border.width: Config.options.contextMenu.border.size
			border.color: Config.style.border

			opacity: window.visible ? 1 : 0
			scale: window.visible ? 1 : 0.94

			Behavior on opacity { NumberAnimation { duration: 180; easing.type: Easing.OutCubic } }
			Behavior on scale { NumberAnimation { duration: 180; easing.type: Easing.OutCubic } }
		}

		RowLayout
		{
			anchors.fill: parent
			anchors.margins: root.padding + background.border.width

			spacing: 10

			Image
			{
				id: icon

				source: "icons/image-missing-symbolic.svg"
				sourceSize.width: root.implicitHeight
				sourceSize.height: root.implicitHeight
				fillMode: Image.Stretch

				Layout.fillHeight: true
				Layout.preferredWidth: height
			}

			ColumnLayout
			{
				Label
				{
					id: label

					text: ""
					color: Config.style.text

					Layout.fillWidth: true
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
			}
		}
	}

	Timer
	{
		id: timer

		interval: root.duration
		running: true

		onTriggered: root.close()
	}
}
