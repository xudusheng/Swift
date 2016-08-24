//
//  INSGlobleVar.swift
//  iNews
//
//  Created by zhengda on 16/8/24.
//  Copyright © 2016年 zhengda. All rights reserved.
//
import UIKit

private let systemVersion = UIDevice.currentDevice().systemVersion as NSString;
let SWIFT_DEVICE_SYSTEM_VERSION_IOS7 = (systemVersion.floatValue >= 7.0);
let SWIFT_DEVICE_SYSTEM_VERSION_IOS8 = (systemVersion.floatValue >= 8.0);
let SWIFT_DEVICE_SYSTEM_VERSION_IOS9 = (systemVersion.floatValue >= 9.0);
let SWIFT_DEVICE_SYSTEM_VERSION_IOS10 = (systemVersion.floatValue >= 10.0);
let SWIFT_DEVICE_APP_BUNDLE_IDENTIFIER = NSBundle.mainBundle().bundleIdentifier;//本应用的bundle identifier

let SWIFT_DEVICE_SCREEN_WIDTH = UIScreen.mainScreen().bounds.size.width;
let SWIFT_DEVICE_SCREEN_HEIGHT = UIScreen.mainScreen().bounds.size.height;
let SWIFT_DEVICE_SCREEN_BOUNDS = UIScreen.mainScreen().bounds;
