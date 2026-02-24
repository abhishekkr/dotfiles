# .bashrc

alias ruboto='jruby -S ruboto'

[ -z $Android_SDK_tools ] && export PATH=$PATH:$Android_SDK_tools

export ANDROID_LOCATION=/opt
export ANDROID_HOME=$ANDROID_LOCATION/android-sdk
export ANDROID_AVD_HOME=$HOME/.android/avd

[ -d "${ANDROID_HOME}/tools" ] && export PATH=$PATH:$ANDROID_HOME/tools

alias android-avd="android avd &"

##### PhoneGap: http://phonegap.com/

alias phonegap-get="npm install -g phonegap"

alias phonegap-new="phonegap create"

alias phonegap-droid="phonegap run android"


##### Apache Cordova: http://cordova.apache.org/

alias cordova-get="npm install -g cordova"

alias cordova-new="phonegap create"

alias cordova-droid="cordova platform add android ; cordova emulate android"

#####

available-avd-name(){
  /opt/android-sdk/tools/bin/avdmanager list avd | grep 'Name: ' | tail -1 | awk '{print $2}'
}
alias avd-name-available="available-avd-name"

start-available-avd(){
  pushd /opt/android-sdk/emulator
  export PATH="${PWD}/bin64:${PATH}"
  ./emulator -avd $(available-avd-name)
  popd
}
alias avd-start-available="start-available-avd"
alias init.avd="start-available-avd"

enable-flutter-config(){
  export ANDROID_HOME=/opt/android-sdk
  export ANDROID_LOCATION=/opt
  export ANDROID_SDK_ROOT="${ANDROID_HOME}"

  export GRADLE_USER_HOME="${HOME}/.gradle"
  export JAVA_OPTIONS="-Xms1280m -Xmx2280m"

  export FLUTTER_HOME="/opt/flutter"

  export PATH="${FLUTTER_HOME}/bin:${PATH}"
  export PATH="${ANDROID_HOME}/tools/bin:${ANDROID_HOME}/tools:${ANDROID_HOME}/build-tools/28.0.0:${ANDROID_HOME}/platform-tools:${ANDROID_HOME}/emulator:${ANDROID_HOME}/tools:${PATH}"
  export PATH="$PATH":"${FLUTTER_HOME}/.pub-cache/bin"

  export LD_LIBRARY_PATH="${ANDROID_HOME}/tools/lib:${LD_LIBRARY_PATH}"
}
alias init.flutter="enable-flutter-config"

adb-screen-record(){
  local FILENAME="${1:-mobileusage.mp4}"
  adb shell screenrecord "/sdcard/$FILENAME"
}

adb-fetch-record(){
  local FILENAME="${1:-mobileusage.mp4}"
  adb pull "/sdcard/$FILENAME"
}

adb-delete-record(){
  local FILENAME="${1:-mobileusage.mp4}"
  adb shell rm "/sdcard/$FILENAME"
}

adb-fetch-n-delete-record(){
  local FILENAME="${1:-mobileusage.mp4}"
  adb-fetch-record "${FILENAME}"
  adb-delete-record "${FILENAME}"
}

android-emulator-fetch(){
  avdmanager create avd -n Pixel35 -k "system-images;android-35;google_apis;x86_64" --device "pixel"
}
android-emulator(){
  emulator -avd Pixel35
}
android-emulator-wiped(){
  emulator -avd Pixel35 -wipe-data
}
flutter-run-on-pixel(){
  flutter run --build --hot -d 'Pixel35'
}
