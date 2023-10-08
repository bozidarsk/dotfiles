if ([System.IO.Directory]::Exists("E:\Google Drive")) { [System.IO.Directory]::Delete("E:\Google Drive"); }

$MethodDefinition = @'
	[DllImport("user32.dll")] public static extern uint ShowWindow(IntPtr hWnd, uint nCmdShow);
'@
$winapi = Add-Type -MemberDefinition $MethodDefinition -Name 'User32' -Namespace 'Win32' -PassThru

function StartProcess([string] $name, [string] $arguments) 
{
	[System.Diagnostics.Process] $process = [System.Diagnostics.Process]::Start($name, $arguments);
	[System.Threading.Thread]::Sleep(300); # wait for the process to create a window
	[System.Console]::WriteLine($process.MainWindoHandle);
	$winapi::ShowWindow($process.MainWindowHandle, 0);
}

StartProcess "rclone" "mount `"Google Drive:`" `"E:\Google Drive`""