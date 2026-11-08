import QtQuick
import Quickshell.Services.UPower

Indicator
{
	id: root

	property UPowerDevice device: UPower.devices.values.filter(x => x.nativePath === "BAT1")[0]

	function update()
	{
		if (!root.device || root.device.type !== UPowerDeviceType.Battery)
		{
			root.icons = [ "icons/image-missing-symbolic.svg" ];
			root.value = 0;

			return;
		}

		root.icons = (root.device.state === UPowerDeviceState.Charging)
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

		root.value = root.device.percentage;
	}

	Component.onCompleted: IpcHandlers.battery.update.connect(() => root.update())

	Timer
	{
		interval: 1000
		running: true
		repeat: true

		onTriggered: root.update()
	}
}
