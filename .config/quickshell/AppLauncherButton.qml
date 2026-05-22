import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell

StyledButton
{
	required property AppLauncher launcher

	color: (focus || launcher.isOpen) ? Config.style.hovered : 'transparent'

	onClicked: launcher.open();

	contextMenu: StyledContextMenu
	{
		id: menu

		property int labelPadding: 5

		Repeater
		{
			model: Config.options.appLauncher.contextMenuOptions

			StyledButton
			{
				required property var modelData

				onClicked:
				{
					menu.close();

					Quickshell.execDetached({ command: [ "sh", "-c", modelData.command ] });
				}

				implicitWidth: label.implicitWidth + 2*menu.labelPadding
				implicitHeight: label.implicitHeight + 2*menu.labelPadding

				Layout.fillWidth: true

				Label
				{
					id: label

					anchors.fill: parent
					anchors.margins: menu.labelPadding

					horizontalAlignment: Text.AlignHLeft
					verticalAlignment: Text.AlignVCenter

					text: modelData.name
					color: Config.style.text
				}
			}
		}
	}

	Image
	{
		id: image

		anchors.fill: parent
		anchors.margins: Config.options.appLauncher.iconPadding

		source: Config.options.appLauncher.icon ?? "icons/image-missing-symbolic.svg"
		fillMode: Image.Stretch
	}
}
