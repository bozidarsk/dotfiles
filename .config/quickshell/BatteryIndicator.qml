import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Io
import Quickshell.Services.UPower

Indicator
{
	id: root

	property UPowerDevice device: UPower.devices.values.filter(x => x.nativePath === "BAT1")[0] ?? null

	function update()
	{
		if (!root.device || root.device.type !== UPowerDeviceType.Battery)
		{
			icon.source = "icons/image-missing-symbolic.svg";
			label.text = "0%";
			level.value = 0;

			return;
		}

		const icons = (root.device.state === UPowerDeviceState.Charging)
			? [
			"icons/battery-level-0-charging-symbolic.svg",
			"icons/battery-level-10-charging-symbolic.svg",
			"icons/battery-level-20-charging-symbolic.svg",
			"icons/battery-level-30-charging-symbolic.svg",
			"icons/battery-level-40-charging-symbolic.svg",
			"icons/battery-level-50-charging-symbolic.svg",
			"icons/battery-level-60-charging-symbolic.svg",
			"icons/battery-level-70-charging-symbolic.svg",
			"icons/battery-level-80-charging-symbolic.svg",
			"icons/battery-level-90-charging-symbolic.svg",
			"icons/battery-level-100-charged-symbolic.svg",
			]
			: [
				"icons/battery-level-0-symbolic.svg",
				"icons/battery-level-10-symbolic.svg",
				"icons/battery-level-20-symbolic.svg",
				"icons/battery-level-30-symbolic.svg",
				"icons/battery-level-40-symbolic.svg",
				"icons/battery-level-50-symbolic.svg",
				"icons/battery-level-60-symbolic.svg",
				"icons/battery-level-70-symbolic.svg",
				"icons/battery-level-80-symbolic.svg",
				"icons/battery-level-90-symbolic.svg",
				"icons/battery-level-100-symbolic.svg",
			]
		;

		icon.source = icons[Math.round((icons.length - 1) * root.device.percentage)] ?? "icons/image-missing-symbolic.svg";
		label.text = `${Math.round(root.device.percentage * 100.0)}%`;
		level.value = root.device.percentage;
	}

	Timer
	{
		id: timer

		interval: 1000
		running: true
		repeat: true

		onTriggered: root.update()
	}
}
