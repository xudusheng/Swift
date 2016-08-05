#!/bin/sh

WORKSPACE_NAME="XDSSwift.xcworkspace"
SCHEME_NAME="XDSSwift"
ARCHIVE_FILE_NAME="XDSSwift_AdHoc"
CONFIGURATION="Release"
BUILD_PATH="build_AdHoc"

xcodebuild clean -configuration "$CONFIGURATION" -alltargets
#app-store, ad-hoc, package, enterprise, development, and developer-id
#exportOptionsPlist   method = development  个人开发证书  -->EXPORT SUCCESS
#exportOptionsPlist   method = enterprise  企业发布证书 --> EXPORT SUCCESS
#exportOptionsPlist   method = enterprise  个人开发证书 --> EXPORT FAILED
#exportOptionsPlist   method = ad-hoc  企业发布证书 --> EXPORT FAILED
#exportOptionsPlist   method = app-store  个人开发证书 -->
#exportOptionsPlist   method = app-store  个人发布证书 -->

#CODE_SIGN_IDENTITY="iPhone Developer: mu he (FX98SJ5KRZ)"
#PROVISIONING_PROFILE="1a41a70c-a26e-4d3d-91bf-889445490895"
#企业发布证书
CODE_SIGN_IDENTITY="iPhone Distribution: SHANGHAI ZENDAI INVESTMENT & CONSULTING CO., LTD."
PROVISIONING_PROFILE="fc5b32f1-f96d-40bb-953c-27f751e0eab2"

XCARCHIVE_PATH="${BUILD_PATH}/${ARCHIVE_FILE_NAME}.xcarchive"
xcodebuild -workspace "$WORKSPACE_NAME" -scheme "$SCHEME_NAME" -configuration "$CONFIGURATION"  -archivePath "$XCARCHIVE_PATH"  archive

EXPORT_OPTIONS_PLIST_PATH="BuildScript/AdHocExportOptions.plist"
IPA_PATH="${BUILD_PATH}"
xcodebuild -exportArchive -archivePath "$XCARCHIVE_PATH" -exportPath "$IPA_PATH" -exportOptionsPlist "$EXPORT_OPTIONS_PLIST_PATH" CODE_SIGN_IDENTITY="$CODE_SIGN_IDENTITY" PROVISIONING_PROFILE="$PROVISIONING_PROFILE"

#firApiToken="a29be0d51c2bfb85b53d1f6cf67fb2e5"
#fir publish "${IPA_PATH}/${SCHEME_NAME}.ipa" -T "$firApiToken"
#osascript -e 'display notification "Release To Fir.im" with title "Upload Complete!"'

