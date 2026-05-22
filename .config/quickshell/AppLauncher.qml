import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell

StyledPopup
{
	id: root

	property var modelData

	property list<DesktopEntry> desktopEntries:
	{
		const source = DesktopEntries.applications.values;
		var destination = [];

		for (var i = 0; i < source.length; i++)
			destination.push(source[i]);

		destination.sort((a, b) => (a.name.toLowerCase() > b.name.toLowerCase()) ? 1 : -1);

		return destination;
	}

	direction: Edges.Top

	margin: Config.options.appLauncher.margin
	padding: Config.options.appLauncher.padding
	radius: Config.options.appLauncher.border.radius
	border.width: Config.options.appLauncher.border.size
	border.color: Config.style.border

	implicitWidth: rows.implicitWidth
	implicitHeight: rows.implicitHeight

	ColumnLayout
	{
		id: rows

		anchors.fill: parent
		spacing: Config.options.appLauncher.padding

		ScrollView
		{
			id: scroll

			implicitWidth: Config.options.appLauncher.scrollWidth
			implicitHeight: Config.options.appLauncher.scrollHeigth

			ScrollBar.horizontal.interactive: false
			ScrollBar.vertical.interactive: true

			onVisibleChanged: ScrollBar.vertical.position = 0

			ColumnLayout
			{
				id: apps

				spacing: 5

					Repeater
				{
					id: repeater

					model: root.desktopEntries

					StyledButton
					{
						id: button

						required property DesktopEntry modelData

						property int size: 12
						property int padding: 5

						onClicked:
						{
							root.close();
							Utils.runApp(modelData.id);
						}

						implicitWidth: scroll.implicitWidth
						implicitHeight: label.implicitHeight + 2*button.padding

						contextMenu: AppContextMenu
						{
							relativeLayerNamespace: ""
							relativeTo: null

							desktop: modelData.id

							onSelected: root.close()
						}

						RowLayout
						{
							anchors.fill: parent
							spacing: 0

							Item
							{
								implicitWidth: label.implicitHeight + 2*button.padding

								Image
								{
									id: image

									anchors.fill: parent
									anchors.margins: button.padding

									source: Config.options.appIcons.find(x => x.desktop === modelData.id)?.icon ?? Quickshell.iconPath(modelData.icon, "image-missing-symbolic")
									fillMode: Image.Stretch
								}

								Layout.fillHeight: true
							}

							Label
							{
								id: label

								horizontalAlignment: Text.AlignHLeft
								verticalAlignment: Text.AlignVCenter

								font.pixelSize: button.size
								text: modelData.name
								color: Config.style.text

								Layout.fillWidth: true
								Layout.fillHeight: true
							}
						}
					}
				}
			}
		}

		TextField
		{
			id: input

			padding: 10
			focus: true

			cursorVisible: true
			placeholderText: "Search..."
			placeholderTextColor: Config.style.text
			color: Config.style.text

			background: Rectangle
			{
				color: Config.style.hovered
				radius: 10
			}

			onTextEdited: repeater.model = root.desktopEntries.filter(x => x.name.toLowerCase().includes(input.text.toLowerCase()))

			Layout.fillWidth: true
		}

		onVisibleChanged:
		{
			input.text = "";
			repeater.model = root.desktopEntries;
		}

		Keys.forwardTo: [ input ]
		Keys.onUpPressed: prev()
		Keys.onDownPressed: next()
		Keys.onTabPressed: next()
		Keys.onBacktabPressed: prev()

		Keys.onMenuPressed:
		{
			var item = apps.children.filter(x => x.clicked).find(x => x.focus);

			if (item)
				item.contextMenu.open(mapToGlobal(item.x, item.y));
		}

		Keys.onReturnPressed:
		{
			var items = apps.children.filter(x => x.clicked);
			var item = items.find(x => x.focus);

			if (item)
			{
				item.clicked();
				item.focus = false;
			}
			else
			{
				items[0].clicked();
				items[0].focus = false;
			}
		}

		function prev()
		{
			var items = apps.children.filter(x => x.clicked);
			var index = items.findIndex(x => x.focus);

			if (index === 0 || index === -1)
				index = items.length;

			items[index - 1].focus = true;

			ensureVisible(items[index - 1]);
		}

		function next()
		{
			var items = apps.children.filter(x => x.clicked);
			var index = items.findIndex(x => x.focus);

			if (index === items.length - 1 || index === -1)
				index = -1;

			items[index + 1].focus = true;

			ensureVisible(items[index + 1]);
		}

		function ensureVisible(item)
		{
			var flickable = scroll.contentItem;

			var pos = item.mapToItem(flickable.contentItem, 0, 0);
			var itemTop    = pos.y;
			var itemBottom = pos.y + item.height;
			var viewTop    = flickable.contentY;
			var viewBottom = flickable.contentY + flickable.height;

			if (itemTop < viewTop)
				flickable.contentY = itemTop;
			else if (itemBottom > viewBottom)
				flickable.contentY = itemBottom - flickable.height;
		}
	}
}
