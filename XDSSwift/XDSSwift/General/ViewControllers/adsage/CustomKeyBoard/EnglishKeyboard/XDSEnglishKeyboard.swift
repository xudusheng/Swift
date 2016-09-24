//
//  XDSEnglishKeyboard.swift
//  XDSSwift
//
//  Created by xudosom on 16/9/24.
//  Copyright © 2016年 zhengda. All rights reserved.
//

import UIKit

class XDSEnglishKeyboard: UIView, UICollectionViewDataSource, UICollectionViewDelegate {
    var collectionView : UICollectionView!;
    var keyboardLayout = XDSEnglishKeyboardLayout();
    let keyboardFrame = CGRect(x: 0, y: 0, width: SWIFT_DEVICE_SCREEN_WIDTH, height: 216);
    
    weak var inputTextView:UITextInput?;
    
    deinit {
        NSLog("XDSEnglishKeyboard===> deinit")
    }
    
    override init(frame: CGRect) {
        super.init(frame:keyboardFrame);
        self.createEnglishKeyboardUI();
    }
    init() {
        super.init(frame: keyboardFrame);
        self.createEnglishKeyboardUI();
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createEnglishKeyboardUI() {
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
                                               selector: #selector(XDSEnglishKeyboard.deviceOrientationDidChange(notification:)),
                                               name: NSNotification.Name.UIDeviceOrientationDidChange,
                                               object: nil);
    }
    
    //MARK:UICollectionViewDataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return xds_english_keyboard_letters.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return xds_english_keyboard_letters[section].count;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: xds_englishKeyboardCellIdentifier, for: indexPath) as! XDSEnglishKeyboardCell;
        cell.setTitle(text: xds_english_keyboard_letters[indexPath.section][indexPath.row]);
        return cell;
    }

    //MARK:UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true);
        let letter = xds_english_keyboard_letters[indexPath.section][indexPath.row];
        self.clickLetterButton(letter: letter);
        NSLog("letter = \(letter)");
    }
    
    //MARK:NSNotification.Name.UIDeviceOrientationDidChange
    @objc private func deviceOrientationDidChange(notification: Notification){
        collectionView.frame = self.bounds;
        collectionView.reloadData();
    }
    
    //MARK:setInputTextView
    internal func set(inputView:UITextInput!){
        self.inputTextView = inputView;
        if inputView is UITextField {
            let textField = self.inputTextView as! UITextField;
            textField.inputView = self;
        }else if inputView is UITextView{
            let textView = self.inputTextView as! UITextView;
            textView.inputView = self;
        }
    }

    //MARK:Click Letter Button
    private func clickLetterButton(letter:String!){
        if letter == xds_title_shift{//切换大小写
            
        }else if letter == xds_title_digit_switch{//切换数字
            
        }else if letter == xds_title_sign_switch{//切换符号
            
        }else if letter == xds_title_delete {//删除
            inputTextView?.deleteBackward();
        }else if letter == xds_title_space{//输入空格
            inputTextView?.insertText(" ");
        }else{
            inputTextView?.insertText(letter);//输入
        }
    }
}
