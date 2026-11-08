pragma Singleton

import QtQuick
import Quickshell

Scope
{
	readonly property alias shell: shell
	readonly property alias appLauncher: appLauncher
	readonly property alias languages: languages
	readonly property alias clipboard: clipboard
	readonly property alias controls: controls
	readonly property alias date: date
	readonly property alias sound: sound
	readonly property alias battery: battery
	readonly property alias brightness: brightness
	readonly property alias rfkill: rfkill
	readonly property alias touchpadtoggle: touchpadtoggle

	Scope
	{
		id: shell

		signal update()
	}

	Scope
	{
		id: appLauncher

		signal toggle()
		signal run(index: int)
	}

	Scope
	{
		id: languages

		signal update()
	}

	Scope
	{
		id: clipboard

		signal toggle()
	}

	Scope
	{
		id: controls

		signal toggle()
	}

	Scope
	{
		id: date

		signal toggle()
	}

	Scope
	{
		id: sound

		signal update()
	}

	Scope
	{
		id: battery

		signal update()
	}

	Scope
	{
		id: brightness

		signal update()
	}

	Scope
	{
		id: rfkill

		signal update()
	}

	Scope
	{
		id: touchpadtoggle

		signal update(state: bool)
	}
}
