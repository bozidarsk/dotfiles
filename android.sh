sudo pacman -Sy jdk-openjdk
installaur android-sdk android-sdk-cmdline-tools-latest android-sdk-build-tools android-sdk-platform-tools android-emulator

export PATH="$ANDROID_SDK_ROOT/cmdline-tools/latest/bin:$PATH"
ANDROID_TOOLS="$ANDROID_SDK_ROOT/cmdline-tools/latest/bin"

sudo $ANDROID_TOOLS/sdkmanager --install "system-images;android-36;google_apis_playstore;x86_64" "platforms;android-36"

$ANDROID_TOOLS/avdmanager create avd --name games --package "system-images;android-36;google_apis_playstore;x86_64" --device pixel_9

# PlayStore.enabled=yes
# disk.dataPartition.path=
# disk.dataPartition.size=8G
# hw.camera.back=none
# hw.camera.front=none
# hw.cpu.ncore=8
# hw.gpu.enabled=yes
# hw.gpu.mode=host
# hw.keyboard=yes
# hw.ramSize=8G
# userdata.useQcow2=no
