//
//  XDSEnglishKeyboardViewAndModel.swift
//  XDSSwift
//
//  Created by xudosom on 16/9/25.
//  Copyright © 2016年 zhengda. All rights reserved.
//

import UIKit

class XDSEnglishKeyboardViewAndModel: NSObject {
    
    private let xds_english_keyboard_lowercase_letters:[[String]] = [
        ["q","w","e","r","t","y","u","i","o","p"],
        ["a","s","d","f","g","h","j","k","l"],
        [xds_title_shift,"z","x","c","v","b","n","m", xds_title_delete],
        [xds_title_digit_switch, xds_title_space, xds_title_sign_switch]
    ];
    private let xds_english_keyboard_uppercase_letters:[[String]] = [
        ["Q","W","E","R","T","Y","U","I","O","P"],
        ["A","S","D","F","G","H","K","L","L"],
        [xds_title_shift,"Z","X","C","V","B","N","M", xds_title_delete],
        [xds_title_digit_switch, xds_title_space, xds_title_sign_switch]
    ];
    
    private var collectionView:UICollectionView?;
    internal var xds_english_keyboard_letters : [[String]]!;
    internal var isUppercase = false;
    
    deinit {
        NSLog("\(XDSEnglishKeyboardViewAndModel.self)===> deinit");
    }
    override init() {
        super.init();
        self.xds_english_keyboard_letters = xds_english_keyboard_lowercase_letters;
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    internal func setCollectionView(_ collectionView:UICollectionView?){
        self.collectionView = collectionView;
    }
    internal func transferToUpper(){
        self.xds_english_keyboard_letters = xds_english_keyboard_uppercase_letters;
        self.isUppercase = true;
        self.collectionView?.reloadData();
    }
    
    internal func transferToLower(){
        self.xds_english_keyboard_letters = xds_english_keyboard_lowercase_letters;
        self.isUppercase = false;
        self.collectionView?.reloadData();
    }
}
