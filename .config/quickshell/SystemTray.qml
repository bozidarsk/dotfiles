import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.SystemTray

StyledPopup
{
	id: root

	direction: Edges.Top

	margin: Config.options.systemTray.margin
	padding: Config.options.systemTray.padding
	radius: Config.options.systemTray.border.radius
	border.width: Config.options.systemTray.border.size
	border.color: Config.style.border

	implicitWidth: items.implicitWidth
	implicitHeight: items.implicitHeight

	RowLayout
	{
		id: items

		anchors.fill: parent

		Repeater
		{
			model: SystemTray.items

			StyledButton
			{
				id: button

				implicitWidth: icon.implicitWidth + 2*icon.anchors.margins
				implicitHeight: icon.implicitHeight + 2*icon.anchors.margins

				tooltip: StyledTooltip
				{
					relativeTo: button
					direction: Edges.Top
					offset: Config.options.systemTray.itemPadding
					text: modelData.title
				}

				onClicked:
				{
					const window = Utils.getRunningApps(true).find(x => x.appId === modelData.id);

					root.close();
					window.activate();
				}

				onRightClicked:
				{
					var position = button.mapToGlobal(0, 0);

					modelData.display(root.window, position.x, position.y);
				}

				Image
				{
					id: icon

					anchors.fill: parent
					anchors.margins: Config.options.systemTray.itemPadding

					source: modelData.icon
					sourceSize.width: Config.options.systemTray.itemSize
					sourceSize.height: Config.options.systemTray.itemSize
					fillMode: Image.Stretch
				}

				Layout.fillWidth: true
				Layout.fillHeight: true
			}
		}
	}
}
