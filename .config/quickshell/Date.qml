import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Io

StyledPopup
{
	id: root

	property int day
	property int month
	property int year

	direction: Edges.Top

	margin: Config.options.date.margin
	padding: Config.options.date.padding
	radius: Config.options.date.border.radius
	border.width: Config.options.date.border.size
	border.color: Config.style.border

	implicitWidth: items.implicitWidth
	implicitHeight: items.implicitHeight

	onIsOpenChanged:
	{
		root.day = parseInt(Qt.formatDateTime(clock.date, "d"));
		root.month = parseInt(Qt.formatDateTime(clock.date, "M"));
		root.year = parseInt(Qt.formatDateTime(clock.date, "yyyy"));

		buttons.update();
	}

	function previousMonth()
	{
		if (root.month == 1)
		{
			root.month = 12;
			root.year--;
		}
		else
		{
			root.month--;
		}

		buttons.update();
	}

	function nextMonth()
	{
		if (root.month == 12)
		{
			root.month = 1;
			root.year++;
		}
		else
		{
			root.month++;
		}

		buttons.update();
	}

	MouseArea
	{
		anchors.fill: parent

		onWheel: function (wheel)
		{
			if (wheel.angleDelta.y > 0)
				root.previousMonth();
			else
				root.nextMonth();
		}
	}

	ColumnLayout
	{
		id: items

		anchors.fill: parent

		focus: true

		Keys.onLeftPressed: root.previousMonth()
		Keys.onRightPressed: root.nextMonth()

		Label
		{
			text: Qt.formatDateTime(clock.date, "dddd")
			font.pixelSize: 15
			color: Config.style.text

			Layout.fillWidth: true
		}

		Label
		{
			text: Qt.formatDateTime(clock.date, "d MMMM yyyy")
			font.pixelSize: 15
			color: Config.style.text

			Layout.fillWidth: true
		}

		Item
		{
			implicitHeight: 5

			Layout.fillWidth: true
		}

		RowLayout
		{
			StyledButton
			{
				implicitWidth: previous.implicitWidth + 2*previous.anchors.margins
				implicitHeight: previous.implicitHeight + 2*previous.anchors.margins

				onClicked: root.previousMonth()

				Image
				{
					id: previous

					anchors.fill: parent
					anchors.margins: 5

					source: "icons/go-previous-symbolic.svg"
					sourceSize.width: 15
					sourceSize.height: 15
					fillMode: Image.Stretch
				}

				Layout.fillHeight: true
			}

			Label
			{
				horizontalAlignment: Text.AlignHCenter
				verticalAlignment: Text.AlignVCenter

				text: [ "January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December" ][root.month - 1] + ((root.year != Qt.formatDateTime(clock.date, "yyyy")) ? ` ${root.year}` : "")
				color: Config.style.text

				Layout.fillWidth: true
				Layout.fillHeight: true
			}

			StyledButton
			{
				implicitWidth: next.implicitWidth + 2*next.anchors.margins
				implicitHeight: next.implicitHeight + 2*next.anchors.margins

				onClicked: root.nextMonth()

				Image
				{
					id: next

					anchors.fill: parent
					anchors.margins: 5

					source: "icons/go-next-symbolic.svg"
					sourceSize.width: 15
					sourceSize.height: 15
					fillMode: Image.Stretch
				}

				Layout.fillHeight: true
			}

			Layout.fillWidth: true
		}

		GridLayout
		{
			id: buttons

			columns: 7
			columnSpacing: 5
			uniformCellWidths: true

			rows: 1 + 6
			rowSpacing: 5
			uniformCellHeights: true

			function update()
			{
				const items = buttons.children.filter(x => x.clicked);

				var monthDays = [ 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 ];
				var weekdays = [ "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday" ];

				var todayDay = parseInt(Qt.formatDateTime(clock.date, "d"));
				var todayMonth = parseInt(Qt.formatDateTime(clock.date, "M"));
				var todayYear = parseInt(Qt.formatDateTime(clock.date, "yyyy"));

				var isWhole = function(y)
				{
					return ((y % 4 === 0) && (y % 100 !== 0)) || (y % 400 === 0);
				};

				var calculateDays = function(d, m, y)
				{
					var days = d;

					for (var i = 1; i < m; i++)
					{
						days += monthDays[i - 1];

						if (i === 2 && isWhole(y))
							days++;
					}

					for (var i = 0; i < y; i++)
						days += isWhole(i) ? 366 : 365;

					return days;
				};

				var diff = calculateDays(1, root.month, root.year) - calculateDays(todayDay, todayMonth, todayYear);

				var newWeekday = weekdays.indexOf(Qt.formatDateTime(clock.date, "dddd"));
				newWeekday += (diff < 0) ? weekdays.length + (diff % weekdays.length) : diff;
				newWeekday = newWeekday % weekdays.length;

				var itemOffset = 0;

				for (var i = 0; i < newWeekday; i++)
				{
					var value = monthDays[(root.month !== 1) ? (root.month - 1) - 1 : 12 - 1] - newWeekday + 1 + i;
					items[itemOffset].label.text = ((value <= 9) ? "0" : "") + value.toString();
					items[itemOffset].label.color = Config.style.text;
					items[itemOffset].label.opacity = 0.5;
					items[itemOffset].label.font.bold = false;

					itemOffset++;
				}

				for (var i = 1; i <= (monthDays[root.month - 1] + ((root.month === 2 && isWhole(root.year)) ? 1 : 0)); i++)
				{
					items[itemOffset].label.text = ((i <= 9) ? "0" : "") + i.toString();
					items[itemOffset].label.color = Config.style.text;
					items[itemOffset].label.opacity = 1.0;
					items[itemOffset].label.font.bold = true;

					if (i === todayDay && root.month === todayMonth && root.year === todayYear)
					{
						items[itemOffset].label.color = Config.style.active;
					}

					itemOffset++;
				}

				for (var i = 1; itemOffset < items.length; i++)
				{
					items[itemOffset].label.text = ((i <= 9) ? "0" : "") + i.toString();
					items[itemOffset].label.color = Config.style.text;
					items[itemOffset].label.opacity = 0.5;
					items[itemOffset].label.font.bold = false;

					itemOffset++;
				}
			}

			Repeater
			{
				model: [ "M", "T", "W", "T", "F", "S", "S" ]

				Label
				{
					horizontalAlignment: Text.AlignHCenter
					verticalAlignment: Text.AlignVCenter

					text: modelData
					color: Config.style.text

					Layout.fillWidth: true
					Layout.fillHeight: true
				}
			}

			Repeater
			{
				model: 7 * 6

				StyledButton
				{
					property alias label: label

					implicitWidth: label.contentWidth + 2*label.anchors.margins
					implicitHeight: label.contentHeight + 2*label.anchors.margins

					Label
					{
						id: label

						anchors.fill: parent
						anchors.margins: 5

						horizontalAlignment: Text.AlignHCenter
						verticalAlignment: Text.AlignVCenter

						text: "00"
						color: Config.style.text
						font.bold: true
					}
				}
			}
		}
	}

	Item
	{
		SystemClock
		{
			id: clock

			precision: SystemClock.Hours
		}
	}
}
