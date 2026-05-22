import QtQuick
import QtQuick.Layouts
import Quickshell

RowLayout
{
	id: root

	required property string relativeLayerNamespace
	readonly property int count: repeater.model?.length ?? 0

	spacing: Config.options.dock.spacing

	Repeater
	{
		id: repeater

		model: Utils.getRunningApps(Config.options.dock.includeAllWorkspaces)
			.filter(x =>
				!pinnedApps.children
				.map(x => x.desktop ?? "")
				.includes(x.appId)
			)
			.map(x =>
				x.appId
			)

		DockAppButton
		{
			id: current

			required property string modelData

			contextMenu.relativeLayerNamespace: root.relativeLayerNamespace
			contextMenu.relativeTo: current

			desktop: modelData

			Layout.fillHeight: true
			Layout.preferredWidth: height
		}
	}
}
