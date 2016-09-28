//
//  XDSEnglishKeyboard.swift
//  XDSSwift
//
//  Created by xudosom on 16/9/24.
//  Copyright © 2016年 zhengda. All rights reserved.
//

import UIKit

class XDSEnglishKeyboard: XDSRootKeyboard, UICollectionViewDataSource, UICollectionViewDelegate {

    var collectionView : UICollectionView!;
    var keyboardLayout : XDSEnglishKeyboardLayout?;
    let keyboardVM = XDSEnglishKeyboardViewAndModel();
    var englishKeyboardCallback : xds_keyboardCallBack?;

    deinit {
        NSLog("XDSEnglishKeyboard===> deinit")
    }
    
    internal init(callback:@escaping xds_keyboardCallBack){
        super.init(frame:keyboardFrame);
        self.englishKeyboardCallback = callback;
        self.createEnglishKeyboardUI();
    }
    
    private override init(frame: CGRect) {
        super.init(frame:frame);
    }
    private init() {
        super.init(frame: keyboardFrame);
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createEnglishKeyboardUI() {
        self.keyboardLayout = XDSEnglishKeyboardLayout(viewAndModel: keyboardVM);
        self.collectionView = UICollectionView(frame: self.bounds, collectionViewLayout: keyboardLayout!);
        collectionView.backgroundColor = UIColor.orange;
        collectionView.showsVerticalScrollIndicator = false;
        collectionView.showsHorizontalScrollIndicator = false;
        collectionView.isPagingEnabled = true;
        collectionView.bounces = false;
        collectionView.dataSource = self;
        collectionView.delegate = self;
        collectionView.register(XDSEnglishKeyboardCell.self, forCellWithReuseIdentifier: xds_englishKeyboardCellIdentifier);
        self.addSubview(collectionView);
        keyboardVM.setCollectionView(collectionView);

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(XDSEnglishKeyboard.deviceOrientationDidChange(notification:)),
                                               name: NSNotification.Name.UIDeviceOrientationDidChange,
                                               object: nil);
    }
    
    //MARK:UICollectionViewDataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return keyboardVM.xds_english_keyboard_letters.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return keyboardVM.xds_english_keyboard_letters[section].count;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: xds_englishKeyboardCellIdentifier, for: indexPath) as! XDSEnglishKeyboardCell;
        cell.setTitle(text: keyboardVM.xds_english_keyboard_letters[indexPath.section][indexPath.row]);
        return cell;
    }

    //MARK:UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true);
        let letter = keyboardVM.xds_english_keyboard_letters[indexPath.section][indexPath.row];
        
        if letter == xds_title_shift{
            keyboardVM.isUppercase ?
                keyboardVM.transferToLower():
                keyboardVM.transferToUpper();
            return;
        }

        if self.englishKeyboardCallback != nil {
            self.englishKeyboardCallback!(letter);
        }
    }
    
    //MARK:NSNotification.Name.UIDeviceOrientationDidChange
    @objc private func deviceOrientationDidChange(notification: Notification){
        collectionView.frame = self.bounds;
        collectionView.reloadData();
    }
}
