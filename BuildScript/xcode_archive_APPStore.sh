#!/bin/sh
#

#出现过 can't find device 的错误，使用 rvm system 解决掉了
#rvm system

archiveName="Laomoney"
workspaceName="Laomoney.xcworkspace"
scheme="Laomoney"
codeSignIdentity="iPhone Distribution: SHANGHAI ZENDAIAT FINANCIAL INFORMATION SERVICE CO.,LTD. (5E6EZZ7JT4)"
appStoreProvisioningProfile="4c7170e3-d5a5-4318-a32f-bcd07832e7ab"
configuration="Release"
exportOptionsPlist="BuildScript/AppStoreExportOptions.plist"
xcarchivePath="${PWD}/build/${archiveName}.xcarchive"
ipaPath="${PWD}/build/${archiveName}/${scheme}.ipa"
appleid="yanfl@zendaimoney.com"
applepassword="Zendaimoney198"

osascript -e 'display notification "Release To AppStore" with title "Running"'

#build clean
xcodebuild clean -configuration "$configuration" -alltargets
osascript -e 'display notification "Release To AppStore" with title "Clean Complete!"'

#打包 archive
xcodebuild archive -workspace "$workspaceName" -scheme "$scheme" -configuration "$configuration" -archivePath "$xcarchivePath" CODE_SIGN_IDENTITY="$codeSignIdentity" PROVISIONING_PROFILE="$appStoreProvisioningProfile"
osascript -e 'display notification "Release To AppStore" with title "Archive Complete!"'


#导出到ipa
xcodebuild -exportArchive -archivePath $PWD/build/${archiveName}.xcarchive -exportOptionsPlist "$exportOptionsPlist" -exportPath $PWD/build/${archiveName}
osascript -e 'display notification "Release To AppStore" with title "Export Complete!"'

###################################
#发布到iTunesConnect
###################################

altoolPath="/Applications/Xcode.app/Contents/Applications/Application Loader.app/Contents/Frameworks/ITunesSoftwareService.framework/Versions/A/Support/altool"

#validate
"$altoolPath" --validate-app -f "$ipaPath" -u "$appleid" -p "$applepassword" -t ios --output-format xml
osascript -e 'display notification "Release To AppStore" with title "Validate Complete!"'

#upload
"$altoolPath" --upload-app -f "$ipaPath" -u "$appleid" -p "$applepassword" -t ios --output-format xml
osascript -e 'display notification "Release To AppStore" with title "Upload Complete!"'

