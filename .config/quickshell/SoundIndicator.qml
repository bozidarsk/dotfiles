import QtQuick
import Quickshell.Services.Pipewire

Indicator
{
	id: root

	property PwNode device: Pipewire.defaultAudioSink

	function update()
	{
		if (!root.device || !root.device.audio)
		{
			root.icons = [ "icons/image-missing-symbolic.svg" ];
			root.value = 0;

			return;
		}

		if (root.device.isSink)
		{
			if (root.device.audio.muted)
			{
				root.icons = [ "icons/audio-volume-muted-symbolic.svg" ];
			}
			else
			{
				root.icons =
				[
					"icons/audio-volume-low-symbolic.svg",
					"icons/audio-volume-medium-symbolic.svg",
					"icons/audio-volume-high-symbolic.svg",
				];
			}
		}
		else
		{
			if (root.device.audio.muted)
			{
				root.icons = [ "icons/microphone-sensitivity-muted-symbolic.svg" ];
			}
			else
			{
				root.icons =
				[
					"icons/microphone-sensitivity-low-symbolic.svg",
					"icons/microphone-sensitivity-medium-symbolic.svg",
					"icons/microphone-sensitivity-high-symbolic.svg",
				];
			}
		}

		root.value = root.device.audio.volume;
	}

	Component.onCompleted: IpcHandlers.sound.update.connect(() => root.update())

	Timer
	{
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
