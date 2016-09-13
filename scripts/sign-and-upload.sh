#!/bin/sh
if [[ "$TRAVIS_PULL_REQUEST" != "false" ]]; then
  echo "This is a pull request. No deployment will be done."
  exit 0
fi
if [[ "$TRAVIS_BRANCH" != "master" ]]; then
  echo "Testing on a branch other than master. No deployment will be done."
  exit 0
fi

# 描述文件地址
PROVISIONING_PROFILE="$HOME/Library/MobileDevice/Provisioning Profiles/$PROFILE_NAME.mobileprovision"
OUTPUTDIR="$PWD/build/Release-iphoneos"
# PROVISIONING_PROFILE="$HOME/scripts/profile/$PROFILE_NAME.mobileprovision"
# APPNAME="TravisCIDemo"
# DEVELOPER_NAME="iPhone Distribution: Shanghai Modern Elite Commerce Consultation Co., Ltd."



buildDay=$(date +%Y%m%d)
buildTime=$(date +%Y%m%d%H%M)

#
buildConfiguration="QA"
buildPath="../ArchiveProduction/QA/${buildDay}/Auto_QA_${buildTime}.xcarchive"
ipaName="$OUTPUTDIR/$APPNAME.ipa"


FIRTOKEN="8704df07c19ce50562ef8f9759be339d"

UKEY="188f1fda795bf1e30b9b253d1430a7e2"
APIKEY="f3729af8659d9367ab09075a5519ff48"

echo "***************************"
echo "*        Signing          *"
echo "***************************"

echo "xcodebuild ipa"

xcrun -log -sdk iphoneos PackageApplication "$OUTPUTDIR/TravisCIDemo.app" -o "$OUTPUTDIR/TravisCIDemo.ipa" -sign "$DEVELOPER_NAME" -embed "$PROVISIONING_PROFILE"


RELEASE_DATE=`date '+%Y-%m-%d %H:%M:%S'`
RELEASE_NOTES="Build: $TRAVIS_BUILD_NUMBER\nUploaded: $RELEASE_DATE"


echo "***************************"
echo "*        Upload          *"
echo "***************************"

curl -F "file=@$OUTPUTDIR/$APPNAME.ipa" -F "uKey=$UKEY" -F "_api_key=$APIKEY" https://www.pgyer.com/apiv1/app/upload

