pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Hyprland

Scope
{
	function getRunningApps(includeAllWorkspaces = false)
	{
		return (includeAllWorkspaces ? Hyprland : Hyprland.focusedWorkspace).toplevels.values.map(x => x.wayland).filter(x => x);
	}

	function isAppActive(desktopId)
	{
		return desktopId && getRunningApps(Config.options.dock.includeAllWorkspaces).some(x => x.appId == desktopId && x.activated)
	}

	function isAppRunning(desktopId)
	{
		return desktopId && getRunningApps(Config.options.dock.includeAllWorkspaces).some(x => x.appId == desktopId);
	}

	function runApp(desktopId, actionId = null)
	{
		if (!desktopId)
			return;

		const entry = DesktopEntries.byId(desktopId);

		if (entry)
		{
			const action = entry.actions.find(x => x.id === actionId);

			var cmd = (action?.command ?? entry.command).join(' ');

			if (action?.runInTerminal ?? entry.runInTerminal)
				Quickshell.execDetached({ command: [ Quickshell.env("TERM"), "-e", cmd ], workingDirectory: Quickshell.env("HOME") });
			else
				Quickshell.execDetached({ command: [ "sh", "-c", cmd ], workingDirectory: Quickshell.env("HOME") });
		}
	}

	function runCommand(command)
	{
		if (!command)
			return;

		Quickshell.execDetached({ command: [ "sh", "-c", command ], workingDirectory: Quickshell.env("HOME") });
	}
}
