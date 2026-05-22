import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Wayland

Scope
{
	id: root

	default property alias content: container.children

	property string layerNamespace: ""
	required property string relativeLayerNamespace
	required property Item relativeTo

	property int direction: Edges.Top
	property int margin: 0
	property int padding: 0

	property alias implicitWidth: background.implicitWidth
	property alias implicitHeight: background.implicitHeight
	property alias radius: background.radius
	property alias border: background.border

	readonly property bool isOpen: window.visible

	function open(position = null)
	{
		if (position && !root.relativeTo)
		{
			popup.x = position.x;
			popup.y = position.y;
		}

		window.visible = true;
		container.focus = true;
		background.focus = false;
		process.running = true;
	}

	function close()
	{
		window.visible = false;
		container.focus = false;
		background.focus = true;
	}

	function update()
	{
		process.running = true;
	}

	PanelWindow
	{
		id: window

		visible: false
		aboveWindows: true
		focusable: true
		exclusionMode: ExclusionMode.Ignore

		WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive
		WlrLayershell.namespace: root.layerNamespace

		surfaceFormat.opaque: false
		color: 'transparent'

		anchors.top: true
		anchors.left: true
		anchors.right: true
		anchors.bottom: true

		Process
		{
			id: process

			command: [ "sh", "-c", `hyprctl layers | grep -E 'namespace: ${root.relativeLayerNamespace}' | sed -E 's/\\s+Layer [^:]+: [^:]+: ([0-9]+) ([0-9]+).+/\\1, \\2/'` ]
			running: root.relativeTo && root.relativeLayerNamespace && root.relativeLayerNamespace !== ""

			stdout: StdioCollector
			{
				waitForEnd: true

				onStreamFinished:
				{
					const offset = text.split(',').map(x => parseInt(x));
					var pos = root.relativeTo.mapToGlobal(0, 0);

					switch (root.direction)
					{
						case Edges.Top:
							pos.x -= popup.width / 2.0;
							pos.x += root.relativeTo.width / 2.0;
							pos.y -= popup.height;
							pos.y -= root.margin;
							break;
						default:
							console.log(`StyledPopup: Not implemented direction Edges.${root.direction}`);
							return;
					}

					pos.x += offset[0];
					pos.y += offset[1];

					popup.x = Math.min(Math.max(pos.x, root.margin), window.screen.width - (popup.width + root.margin));
					popup.y = Math.min(Math.max(pos.y, root.margin), window.screen.height - (popup.height + root.margin));
				}
			}
		}

		MouseArea
		{
			anchors.fill: parent
			acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton

			onClicked: root.close()
		}

		Item
		{
			id: popup

			implicitWidth: background.implicitWidth + 2*root.padding + 2*background.border.width
			implicitHeight: background.implicitHeight + 2*root.padding + 2*background.border.width

			MouseArea
			{
				anchors.fill: parent

				hoverEnabled: true

				onPositionChanged:
				{
					if (root.isOpen && !container.children.some(x => x.focus))
						container.focus = true;
				}
			}

			Rectangle
			{
				id: background

				anchors.fill: parent

				color: Config.style.background

				opacity: root.isOpen ? 1 : 0
				scale: root.isOpen ? 1 : 0.94

				Behavior on opacity { NumberAnimation { duration: 180; easing.type: Easing.OutCubic } }
				Behavior on scale { NumberAnimation { duration: 180; easing.type: Easing.OutCubic } }
			}

			Item
			{
				id: container

				anchors.fill: parent
				anchors.margins: root.padding + background.border.width

				focus: true
				Keys.forwardTo: container.children
				Keys.onEscapePressed: root.close()
			}
		}
	}
}
