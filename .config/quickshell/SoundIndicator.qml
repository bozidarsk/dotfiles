import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Io
import Quickshell.Services.Pipewire

Indicator
{
	id: root

	property StyledOverlay overlay: null
	property PwNode device: Pipewire.defaultAudioSink ?? null

	function update()
	{
		if (!root.device || !root.device.audio)
		{
			icon.source = "icons/image-missing-symbolic.svg";
			label.text = "0%";
			level.value = 0;

			if (overlay)
			{
				overlay.icon.source = icon.source;
				overlay.label.text = label.text;
				overlay.level.value = level.value;
			}

			return;
		}

		if (root.device.isSink)
		{
			if (root.device.audio.muted)
			{
				icon.source = "icons/audio-volume-muted-symbolic.svg";
			}
			else
			{
				const icons =
				[
					"icons/audio-volume-low-symbolic.svg",
					"icons/audio-volume-medium-symbolic.svg",
					"icons/audio-volume-high-symbolic.svg",
				];

				icon.source = icons[Math.round((icons.length - 1) * root.device.audio.volume)];
			}
		}
		else if (root.device.isSource)
		{
			if (root.device.audio.muted)
			{
				icon.source = "icons/microphone-sensitivity-muted-symbolic.svg";
			}
			else
			{
				const icons =
				[
					"icons/microphone-sensitivity-low-symbolic.svg",
					"icons/microphone-sensitivity-medium-symbolic.svg",
					"icons/microphone-sensitivity-high-symbolic.svg",
				];

				icon.source = icons[Math.round((icons.length - 1) * root.device.audio.volume)];
			}
		}

		label.text = `${Math.round(root.device.audio.volume * 100.0)}%`;
		level.value = root.device.audio.volume;

		if (overlay)
		{
			overlay.icon.source = icon.source;
			overlay.label.text = label.text;
			overlay.level.value = level.value;
		}
	}

	Timer
	{
		id: timer

		interval: 1000
		running: true
		repeat: true

		onTriggered: root.update()
	}

	PwObjectTracker
	{
		objects: [ root.device ]
	}
}
