//
//  XDSSignKeyboard.swift
//  XDSSwift
//
//  Created by xudosom on 16/9/25.
//  Copyright © 2016年 zhengda. All rights reserved.
//

import UIKit

let xds_sign_keyboard_letters:[[String]] = [
    ["!", "@", "#", "$", "%", "^", "&", "*", "(", ")"],
    ["'", "\"", "=", "_", ":", ";", "?", "~", "|", "·"],
    ["+", "-", "\\", "/", "[", "]","{", "}", xds_title_delete],
    [xds_title_digit_switch, ",", ".", "<", ">", "€", "฿", "¥", xds_title_english_switch]
];

class XDSSignKeyboard: XDSRootKeyboard, UICollectionViewDataSource, UICollectionViewDelegate {
    weak var inputTextView:UITextInput?;
    
    var signKeyboardCallback : xds_keyboardCallBack?;
    
    var collectionView : UICollectionView!;
    var keyboardLayout = XDSSignKeyboardLayout();
    
    deinit {
        NSLog("XDSEnglishKeyboard===> deinit")
    }
    
    internal init(callback:@escaping xds_keyboardCallBack){
        super.init(frame:keyboardFrame);
        self.signKeyboardCallback = callback;
        self.createSignKeyboardUI();
    }
    
    private override init(frame: CGRect) {
        super.init(frame:keyboardFrame);
    }
    private init() {
        super.init(frame: keyboardFrame);
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createSignKeyboardUI() {
        self.collectionView = UICollectionView(frame: self.bounds, collectionViewLayout: keyboardLayout);
        collectionView.backgroundColor = UIColor.orange;
        collectionView.showsVerticalScrollIndicator = false;
        collectionView.showsHorizontalScrollIndicator = false;
        collectionView.isPagingEnabled = true;
        collectionView.bounces = false;
        collectionView.dataSource = self;
        collectionView.delegate = self;
        collectionView.register(XDSEnglishKeyboardCell.self, forCellWithReuseIdentifier: xds_englishKeyboardCellIdentifier);
        self.addSubview(collectionView);
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(XDSSignKeyboard.deviceOrientationDidChange(notification:)),
                                               name: NSNotification.Name.UIDeviceOrientationDidChange,
                                               object: nil);
    }
    
    //MARK:UICollectionViewDataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return xds_sign_keyboard_letters.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return xds_sign_keyboard_letters[section].count;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: xds_englishKeyboardCellIdentifier, for: indexPath) as! XDSEnglishKeyboardCell;
        cell.setTitle(text: xds_sign_keyboard_letters[indexPath.section][indexPath.row]);
        return cell;
    }
    
    //MARK:UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true);
        let letter = xds_sign_keyboard_letters[indexPath.section][indexPath.row];
        NSLog("letter = \(letter)");
        if self.signKeyboardCallback != nil{
            self.signKeyboardCallback!(letter);
        }
    }
    
    //MARK:NSNotification.Name.UIDeviceOrientationDidChange
    @objc private func deviceOrientationDidChange(notification: Notification){
        collectionView.frame = self.bounds;
        collectionView.reloadData();
    }
    
}
