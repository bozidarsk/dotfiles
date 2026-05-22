import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell

StyledPopup 
{
	id: root

	default property alias content: container.children
	property alias spacing: container.spacing

	direction: Edges.Top

	padding: Config.options.contextMenu.padding
	radius: Config.options.contextMenu.border.radius
	border.width: Config.options.contextMenu.border.size
	border.color: Config.style.border

	implicitWidth: container.implicitWidth
	implicitHeight: container.implicitHeight

	ColumnLayout 
	{
		id: container

		anchors.horizontalCenter: parent.horizontalCenter
		anchors.verticalCenter: parent.verticalCenter

		spacing: Config.options.contextMenu.spacing

		Component.onCompleted: 
		{
			var maxWidth = 0;

			for (const child of container.children)
				if (maxWidth < child.implicitWidth)
					maxWidth = child.implicitWidth;

			for (var child of container.children)
				child.implicitWidth = maxWidth;
		}

		Keys.onUpPressed: prev()
		Keys.onDownPressed: next()
		Keys.onTabPressed: next()
		Keys.onBacktabPressed: prev()

		Keys.onReturnPressed: 
		{
			var item = container.children.filter(x => x.clicked).find(x => x.focus);

			if (item) 
			{
				item.clicked();
				item.focus = false;
			}
		}

		function prev() 
		{
			var items = container.children.filter(x => x.clicked);
			var index = items.findIndex(x => x.focus);

			if (index === 0 || index === -1)
				index = items.length;

			items[index - 1].focus = true;
		}

		function next() 
		{
			var items = container.children.filter(x => x.clicked);
			var index = items.findIndex(x => x.focus);

			if (index === items.length - 1 || index === -1)
				index = -1;

			items[index + 1].focus = true;
		}
	}
}
