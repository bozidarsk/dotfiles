import QtQuick
import Quickshell

StyledButton
{
	id: root

	required property string desktop

	contextMenu: AppContextMenu
	{
		desktop: root.desktop
	}

	tooltip: StyledTooltip
	{
		relativeTo: root
		direction: Edges.Top
		offset: Config.options.dock.padding + Config.options.dock.border.size
		text: DesktopEntries.byId(root.desktop).name
	}

	onClicked:
	{
		if (Utils.isAppRunning(root.desktop))
		{
			const windows = Utils.getRunningApps(Config.options.dock.includeAllWorkspaces).filter(x => x.appId == root.desktop);

			windows[(windows.findIndex(x => x.activated) + 1) % windows.length]?.activate();
		}
		else
		{
			Utils.runApp(root.desktop);
		}
	}

	MouseArea
	{
		anchors.fill: parent

		acceptedButtons: Qt.MiddleButton

		onPressed: Utils.runApp(root.desktop)
	}

	Item
	{
		anchors.fill: parent

		Image
		{
			id: image

			anchors.fill: parent
			anchors.margins: Config.options.dock.iconPadding

			source: Config.options.appIcons.find(x => x.desktop === root.desktop)?.icon ?? Quickshell.iconPath(DesktopEntries.byId(root.desktop)?.icon, "image-missing-symbolic")
			fillMode: Image.Stretch
		}

		HorizontalSeparator
		{
			anchors.bottom: parent.bottom
			anchors.left: parent.left
			anchors.right: parent.right

			anchors.leftMargin: root.radius
			anchors.rightMargin: root.radius

			color:
			{
				if (Utils.isAppActive(root.desktop)) return Config.style.active;
				if (Utils.isAppRunning(root.desktop)) return Config.style.selected;

				return 'transparent';
			}
		}
	}
}
