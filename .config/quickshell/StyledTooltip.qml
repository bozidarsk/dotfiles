import QtQuick
import QtQuick.Controls
import Quickshell

Scope
{
	id: root

	required property Item relativeTo

	property string text: ""
	property int direction: Edges.Top
	property int offset: 0

	property alias visible: window.visible

	PopupWindow
	{
		id: window

		anchor.item: root.relativeTo
		anchor.gravity: root.direction
		anchor.edges: Edges.None
		anchor.adjustment: PopupAdjustment.None

		anchor.rect.x:
		{
			var x = 0.0;

			switch (root.direction)
			{
				case Edges.Top: x = Math.floor(root.relativeTo.width / 2.0); break;
				default: console.log(`StyledTooltip: Not implemented direction Edges.${root.direction}`); return 0;
			}

			return Math.min(Math.max(x, 0.0), window.screen.width - window.implicitWidth);
		}

		anchor.rect.y:
		{
			var y = 0.0;

			switch (root.direction)
			{
				case Edges.Top: y = -(root.offset + background.border.width + Config.options.dock.tooltip.margin); break;
				default: console.log(`StyledTooltip: Not implemented direction Edges.${root.direction}`); return 0;
			}

			return Math.min(Math.max(y, 0.0), window.screen.height - window.implicitHeight);
		}

		implicitWidth: background.implicitWidth
		implicitHeight: background.implicitHeight

		color: 'transparent'

		Rectangle
		{
			id: background

			implicitWidth: label.implicitWidth + 2*Config.options.dock.tooltip.padding + 2*background.border.width
			implicitHeight: label.implicitHeight + 2*Config.options.dock.tooltip.padding + 2*background.border.width

			color: Config.style.background
			radius: Config.options.contextMenu.border.radius
			border.width: Config.options.contextMenu.border.size
			border.color: Config.style.border

			Label
			{
				id: label

				anchors.fill: parent
				anchors.margins: Config.options.dock.tooltip.padding + background.border.width

				horizontalAlignment: Text.AlignHCenter
				verticalAlignment: Text.AlignVCenter

				color: Config.style.text
				text: root.text
			}
		}
	}
}
