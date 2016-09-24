//
//  XDSKeyboardConst.swift
//  XDSSwift
//
//  Created by xudosom on 16/9/24.
//  Copyright © 2016年 zhengda. All rights reserved.
//

import Foundation
//let XDS_TITLE_SHIFT = "shift";//shift按键
//let XDS_TITLE_DELETE = "delete";//delete按钮
//let XDS_TITLE_SPACE = "space";//空格键
//let XDS_TITLE_DIGIT_SWITCH = "123";//切换到数字键盘
//let XDS_TITLE_SIGN_SWITCH = "#+=";//切换到符号键盘

let xds_title_shift = "shift";//shift按键
let xds_title_delete = "delete";//delete按钮
let xds_title_space = "space";//空格键
let xds_title_digit_switch = "123";//切换到数字键盘
let xds_title_sign_switch = "#+=";//切换到符号键盘

let xds_english_keyboard_letters:[[String]] = [
    ["q","w","e","r","t","y","u","i","o","p"],
    ["a","s","d","f","g","h","j","k","l"],
    [xds_title_shift,"z","x","c","v","b","n","m", xds_title_delete],
    [xds_title_digit_switch, xds_title_space, xds_title_sign_switch]
];
