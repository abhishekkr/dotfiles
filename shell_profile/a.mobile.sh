# .bashrc

alias ruboto='jruby -S ruboto'

[ -z $Android_SDK_tools ] && export PATH=$PATH:$Android_SDK_tools

export ANDROID_LOCATION=/opt
export ANDROID_HOME=$ANDROID_LOCATION/android-sdk

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
