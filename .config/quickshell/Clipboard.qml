import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Io

StyledPopup
{
	id: root

	property list<var> regularItems: []
	property list<var> pinnedItems: []

	direction: Edges.Top

	margin: Config.options.clipboard.margin
	padding: Config.options.clipboard.padding
	radius: Config.options.clipboard.border.radius
	border.width: Config.options.clipboard.border.size
	border.color: Config.style.border

	implicitWidth: Math.max(100, items.implicitWidth)
	implicitHeight: items.implicitHeight

	onIsOpenChanged: root.update()

	onRegularItemsChanged: root.update()
	onPinnedItemsChanged: root.update()

	ColumnLayout
	{
		id: items

		anchors.fill: parent

		spacing: 5

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

			onTextEdited:
			{
				pinnedRepeater.model = root.pinnedItems.filter(x => x.value.toLowerCase().includes(input.text.toLowerCase()));
				regularRepeater.model = root.regularItems.filter(x => x.value.toLowerCase().includes(input.text.toLowerCase()));
				root.update();
			}

			Layout.fillWidth: true
		}

		Repeater
		{
			id: pinnedRepeater

			model: root.pinnedItems
			delegateModelAccess: DelegateModel.ReadWrite

			onModelChanged:
			{
				root.update();
				json.items = root.pinnedItems;
			}

			StyledButton
			{
				implicitWidth: pinnedLabels.implicitWidth + 2*pinnedLabels.anchors.margins
				implicitHeight: pinnedLabels.implicitHeight + 2*pinnedLabels.anchors.margins

				onClicked:
				{
					if (modelData.type === "text")
					{
						clipboardText.setText(modelData.value);
						Utils.runCommand("cat '" + clipboardText.path + "' | wl-copy");
					}
					else
					{
						clipboardImage.setText(modelData.value);
						Utils.runCommand("cat '" + clipboardImage.path + "' | base64 -d | wl-copy");
					}

					root.close();
				}

				RowLayout
				{
					id: pinnedLabels

					anchors.fill: parent
					anchors.margins: 5

					spacing: 20

					Label
					{
						horizontalAlignment: Text.AlignHLeft
						verticalAlignment: Text.AlignVCenter

						maximumLineCount: 1
						color: Config.style.text
						text:
						{
							if (modelData.type === "text")
								return (modelData.value.length > Config.options.clipboard.maxLength) ? modelData.value.substring(0, Config.options.clipboard.maxLength) + "..." : modelData.value;
							else
								return "Image";
						}

						Layout.fillWidth: true
						Layout.fillHeight: true
					}

					RowLayout
					{
						spacing: 5

						Layout.alignment: Qt.AlignRight
						Layout.fillHeight: true

						MouseArea
						{
							Layout.alignment: Qt.AlignRight
							Layout.fillHeight: true
							Layout.preferredWidth: height

							onClicked:
							{
								root.regularItems.unshift({ value: modelData.value, type: modelData.type });
								root.pinnedItems.splice(index, 1);
							}

							Image
							{
								anchors.fill: parent

								opacity: 1.0

								source: "icons/view-pin-symbolic.svg"
								sourceSize.width: this.height
								sourceSize.height: this.height
								fillMode: Image.Stretch
							}
						}

						MouseArea
						{
							Layout.alignment: Qt.AlignRight
							Layout.fillHeight: true
							Layout.preferredWidth: height

							onClicked:
							{
								root.pinnedItems.splice(index, 1);
							}

							Image
							{
								anchors.fill: parent

								source: "icons/edit-delete-symbolic.svg"
								sourceSize.width: this.height
								sourceSize.height: this.height
								fillMode: Image.Stretch
							}
						}
					}
				}

				Layout.fillWidth: true
				Layout.fillHeight: true
			}
		}

		HorizontalSeparator
		{
			visible: root.pinnedItems.length > 0

			Layout.fillWidth: true
		}

		Repeater
		{
			id: regularRepeater

			model: root.regularItems
			delegateModelAccess: DelegateModel.ReadWrite

			onModelChanged: root.update()

			StyledButton
			{
				implicitWidth: regularLabels.implicitWidth + 2*regularLabels.anchors.margins
				implicitHeight: regularLabels.implicitHeight + 2*regularLabels.anchors.margins

				onClicked:
				{
					if (modelData.type === "text")
					{
						clipboardText.setText(modelData.value);
						Utils.runCommand("cat '" + clipboardText.path + "' | wl-copy");
					}
					else
					{
						clipboardImage.setText(modelData.value);
						Utils.runCommand("cat '" + clipboardImage.path + "' | base64 -d | wl-copy");
					}

					root.close();
				}

				RowLayout
				{
					id: regularLabels

					anchors.fill: parent
					anchors.margins: 5

					spacing: 20

					Label
					{
						horizontalAlignment: Text.AlignHLeft
						verticalAlignment: Text.AlignVCenter

						maximumLineCount: 1
						color: Config.style.text
						text:
						{
							if (modelData.type === "text")
								return (modelData.value.length > Config.options.clipboard.maxLength) ? modelData.value.substring(0, Config.options.clipboard.maxLength) + "..." : modelData.value;
							else
								return "Image";
						}

						Layout.fillWidth: true
						Layout.fillHeight: true
					}

					RowLayout
					{
						spacing: 5

						Layout.alignment: Qt.AlignRight
						Layout.fillHeight: true

						MouseArea
						{
							Layout.alignment: Qt.AlignRight
							Layout.fillHeight: true
							Layout.preferredWidth: height

							onClicked:
							{
								root.pinnedItems.push({ value: modelData.value, type: modelData.type });
								root.regularItems.splice(index, 1);
							}

							Image
							{
								anchors.fill: parent

								opacity: 0.5

								source: "icons/view-pin-symbolic.svg"
								sourceSize.width: this.height
								sourceSize.height: this.height
								fillMode: Image.Stretch
							}
						}

						MouseArea
						{
							Layout.alignment: Qt.AlignRight
							Layout.fillHeight: true
							Layout.preferredWidth: height

							onClicked:
							{
								root.regularItems.splice(index, 1);
							}

							Image
							{
								anchors.fill: parent

								source: "icons/edit-delete-symbolic.svg"
								sourceSize.width: this.height
								sourceSize.height: this.height
								fillMode: Image.Stretch
							}
						}
					}
				}

				Layout.fillWidth: true
				Layout.fillHeight: true
			}
		}

		HorizontalSeparator
		{
			visible: root.regularItems.length > 0

			Layout.fillWidth: true
		}

		StyledButton
		{
			id: clearHistory

			implicitWidth: clearItems.implicitWidth + 2*clearItems.anchors.margins
			implicitHeight: clearItems.implicitHeight + 2*clearItems.anchors.margins

			Layout.fillWidth: true
			Layout.fillHeight: true

			onClicked:
			{
				root.regularItems = [];
				root.update();
			}

			RowLayout
			{
				id: clearItems

				anchors.fill: parent
				anchors.margins: 5

				spacing: 10

				Image
				{
					Layout.fillHeight: true
					Layout.preferredWidth: height

					source: "icons/user-trash-symbolic.svg"
					sourceSize.width: this.height
					sourceSize.height: this.height
					fillMode: Image.Stretch
				}

				Label
				{
					horizontalAlignment: Text.AlignHLeft
					verticalAlignment: Text.AlignVCenter

					text: "Clear History"
					color: Config.style.text

					Layout.alignment: Qt.AlignLeft
					Layout.fillWidth: true
					Layout.fillHeight: true
				}
			}
		}

		onVisibleChanged:
		{
			input.text = "";
			pinnedRepeater.model = root.pinnedItems;
			regularRepeater.model = root.regularItems;
		}

		Keys.forwardTo: [ input ]
		Keys.onUpPressed: prev()
		Keys.onDownPressed: next()
		Keys.onTabPressed: next()
		Keys.onBacktabPressed: prev()

		Keys.onReturnPressed:
		{
			var item = items.children.filter(x => x.clicked).find(x => x.focus);

			if (item)
			{
				item.clicked();
				item.focus = false;
			}
		}

		function prev()
		{
			var allItems = items.children.filter(x => x.clicked);
			var index = allItems.findIndex(x => x.focus);

			if (index === 0 || index === -1)
				index = allItems.length;

			allItems[index - 1].focus = true;
		}

		function next()
		{
			var allItems = items.children.filter(x => x.clicked);
			var index = allItems.findIndex(x => x.focus);

			if (index === allItems.length - 1 || index === -1)
				index = -1;

			allItems[index + 1].focus = true;
		}
	}

	Item
	{
		FileView
		{
			path: Quickshell.env("HOME") + "/.local/share/clipboard-pinned.json";
			blockLoading: true

			adapter: JsonAdapter
			{
				id: json

				property list<var> items: root.pinnedItems
			}

			onAdapterUpdated: writeAdapter()

			Component.onCompleted:
			{
				root.pinnedItems = JSON.parse(this.text()).items;
				root.update();
			}
		}

		FileView
		{
			id: clipboardText

			path: "/tmp/clipboard-text"
			blockLoading: true
			blockWrites: true
		}

		FileView
		{
			id: clipboardImage

			path: "/tmp/clipboard-image"
			blockLoading: true
			blockWrites: true
		}

		IpcHandler
		{
			target: "clipboard"

			function storeText()
			{
				clipboardText.reload();
				var value = clipboardText.text();

				if (!root.regularItems.some(x => x.type === "text" && x.value === value))
					root.regularItems.unshift(
						{
							type: "text",
							value: value
						}
					);
			}

			function storeImage()
			{
				clipboardImage.reload();
				var value = clipboardImage.text();

				if (!root.regularItems.some(x => x.type === "image" && x.value === value))
					root.regularItems.unshift(
						{
							type: "image",
							value: value
						}
					);
			}

			function clear()
			{
				root.regularItems = [];
			}

			function open()
			{
				root.open();
			}
		}
	}
}
