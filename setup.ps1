curl http://gist.githubusercontent.com/bozidarsk/0fd6584ed7b52e5b24768569e49728be/raw/0cae895abf7f391f840fc153dbded9e799a9b33a/.gitignore -o $HOME\.gitignore

[System.IO.Directory]::CreateDirectory("$env:APPDATA\Sublime Text");
Move-Item -Path .\Packages -Destination "$env:APPDATA\Sublime Text"

move .\onstartup.ps1 "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup"
$env:Path += "E:\Programs"

choco install 7zip arduino-cli blender chrome-remote-desktop-host discord dotnet dotnet-sdk git glfw3 GoogleChrome InkScape microsoft-teams minecraft-launcher obs-studio openjdk potplayer python3 rclone spotify steam sublimetext4 unity-hub winfsp

git config --global user.email "bozidarkabahcijski@gmail.com"
git config --global user.name "bozidarsk"
git config --global --add safe.directory "*"
git config --global init.defaultBranch main
git config --global credential.helper store
git config --global core.excludesfile $HOME\.gitignore
git config --global core.autocrlf false
git config --global push.autoSetupRemote true

pause
