import QtQuick
import QtQuick.Controls
import Quickshell

StyledContextMenu
{
	id: root

	required property string desktop
	property int labelPadding: 5

	signal selected(var desktop, var action);

	readonly property list<DesktopAction> actions: DesktopEntries.byId(root.desktop)?.actions ?? []

	Repeater
	{
		model: root.actions

		StyledButton
		{
			required property DesktopAction modelData

			onClicked:
			{
				root.close();
				root.selected(root.desktop, modelData.id);

				Utils.runApp(root.desktop, modelData.id);
			}

			implicitWidth: label.implicitWidth + 2*root.labelPadding
			implicitHeight: label.implicitHeight + 2*root.labelPadding

			Label
			{
				id: label

				anchors.fill: parent
				anchors.margins: root.labelPadding

				horizontalAlignment: Text.AlignHLeft
				verticalAlignment: Text.AlignVCenter

				text: modelData.name
				color: Config.style.text
			}
		}
	}

	HorizontalSeparator
	{
		visible: root.actions.length !== 0
		implicitHeight: Config.options.contextMenu.border.size
	}

	StyledButton
	{
		onClicked:
		{
			root.close();
			root.selected(root.desktop, null);

			Utils.runApp(root.desktop);
		}

		implicitWidth: defaultLabel.implicitWidth + 2*root.labelPadding
		implicitHeight: defaultLabel.implicitHeight + 2*root.labelPadding

		Label
		{
			id: defaultLabel

			anchors.fill: parent
			anchors.margins: root.labelPadding

			horizontalAlignment: Text.AlignHLeft
			verticalAlignment: Text.AlignVCenter

			text: "New Window"
			color: Config.style.text
		}
	}

	HorizontalSeparator
	{
		visible: Utils.isAppRunning(root.desktop)
		implicitHeight: Config.options.contextMenu.border.size
	}

	StyledButton
	{
		visible: Utils.isAppRunning(root.desktop)

		onClicked:
		{
			root.close();
			root.selected(null, null);

			Utils.getRunningApps(Config.options.dock.includeAllWorkspaces).filter(x => x.appId == root.desktop).forEach(x => x.close());
		}

		implicitWidth: quitLabel.implicitWidth + 2*root.labelPadding
		implicitHeight: quitLabel.implicitHeight + 2*root.labelPadding

		Label
		{
			id: quitLabel

			anchors.fill: parent
			anchors.margins: root.labelPadding

			horizontalAlignment: Text.AlignHLeft
			verticalAlignment: Text.AlignVCenter

			text: "Quit"
			color: Config.style.text
		}
	}
}
