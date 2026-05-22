import QtQuick
import Quickshell

Rectangle
{
	id: root

	property StyledContextMenu contextMenu: null
	property StyledTooltip tooltip: null

	signal clicked();

	focus: false
	color: focus ? Config.style.hovered : 'transparent'
	radius: 5

	Behavior on color { ColorAnimation { duration: 100 } }

	HoverHandler
	{
		enabled: root.enabled

		onHoveredChanged: if (tooltip) tooltip.visible = hovered
	}

	MouseArea
	{
		anchors.fill: parent

		hoverEnabled: root.enabled
		enabled: root.enabled

		acceptedButtons: Qt.LeftButton | Qt.RightButton

		onEntered: root.focus = true
		onExited: root.focus = false
		onPositionChanged: root.focus = true

		onPressed: function (mouse)
		{
			switch (mouse.button)
			{
				case Qt.LeftButton:
					root.focus = false;
					root.clicked();
					break
				case Qt.RightButton:
					contextMenu?.open(mapToGlobal(mouse.x, mouse.y));
					break;
			}
		}
	}

	onVisibleChanged: if (!visible) focus = false
}
