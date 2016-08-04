#!/bin/sh


#archiveName="XDSSwift"
#workspaceName="XDSSwift.xcworkspace"
#scheme="XDSSwift"
#CODE_SIGN_IDENTITY="iPhone Developer: mu he (FX98SJ5KRZ)"
#PROVISIONING_PROFILE="1a41a70c-a26e-4d3d-91bf-889445490895"
#exportOptionsPlistPath = "BuildScript/AdHocExportOptions.plist"
#configuration="Release"
#exportOptionsPlist="BuildScript/AdHocExportOptions.plist"
#xcarchivePath="build/${archiveName}.xcarchive"
#ipaPath="build/${archiveName}.ipa"
#
#
##build clean
#xcodebuild clean -configuration "$configuration" -alltargets

##exportOptionsPlist   method = development  -->OK
#xcodebuild -workspace "$workspaceName" -scheme "$scheme" -archivePath "$xcarchivePath" archive
#xcodebuild -exportArchive -archivePath "$xcarchivePath" -exportPath "$ipaPath" -exportOptionsPlist "$exportOptionsPlistPath" CODE_SIGN_IDENTITY="$CODE_SIGN_IDENTITY" PROVISIONING_PROFILE="$PROVISIONING_PROFILE"
#
#####################################
###发布到fir.i.
#####################################
##
#firApiToken="a29be0d51c2bfb85b53d1f6cf67fb2e5"
#fir publish "$ipaPath" -T "$firApiToken"
#osascript -e 'display notification "Release To Fir.im" with title "Upload Complete!"'
#
#
#
#
#
#
#
#osascript -e 'display notification "Release To Fir.im" with title "xxxxxxxxxxxx!"'

##exportOptionsPlist   method = development  -->OK
xcodebuild archive -workspace "XDSSwift.xcworkspace" -scheme "XDSSwift" -configuration "Release" -archivePath "build/XDSSwift.xcarchive"

xcodebuild -exportArchive -archivePath "build/XDSSwift.xcarchive" -exportPath "build/XDSSwift.ipa" -exportOptionsPlist "BuildScript/AdHocExportOptions.plist" CODE_SIGN_IDENTITY="iPhone Developer: mu he (FX98SJ5KRZ)" PROVISIONING_PROFILE="1a41a70c-a26e-4d3d-91bf-889445490895"

firApiToken="a29be0d51c2bfb85b53d1f6cf67fb2e5"
fir publish "build//XDSSwift/XDSSwift.ipa" -T "$firApiToken"
osascript -e 'display notification "Release To Fir.im" with title "Upload Complete!"'

