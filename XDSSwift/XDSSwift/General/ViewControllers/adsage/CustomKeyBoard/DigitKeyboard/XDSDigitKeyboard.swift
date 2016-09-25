//
//  XDSDigitKeyboard.swift
//  XDSSwift
//
//  Created by xudosom on 16/9/25.
//  Copyright © 2016年 zhengda. All rights reserved.
//

import UIKit

let xds_digit_title_key = "title";
let xds_digit_subTitle_key = "subTitle";

class XDSDigitKeyboard: UIView, UICollectionViewDataSource, UICollectionViewDelegate {
    weak var inputTextView:UITextInput?;
    
    var collectionView : UICollectionView!;
    var keyboardLayout = XDSDigitKeyboardLayout();
    let keyboardFrame = CGRect(x: 0, y: 0, width: SWIFT_DEVICE_SCREEN_WIDTH, height: 216);
    let xdsDigitKeyboardData = [
        [[xds_digit_title_key:"1", xds_digit_subTitle_key:""], [xds_digit_title_key:"2", xds_digit_subTitle_key:"ABC"], [xds_digit_title_key:"3", xds_digit_subTitle_key:"DEF"]],
        [[xds_digit_title_key:"4", xds_digit_subTitle_key:"GHI"], [xds_digit_title_key:"5", xds_digit_subTitle_key:"JKL"], [xds_digit_title_key:"6", xds_digit_subTitle_key:"MNO"]],
        [[xds_digit_title_key:"7", xds_digit_subTitle_key:"PQRS"], [xds_digit_title_key:"8", xds_digit_subTitle_key:"TUV"], [xds_digit_title_key:"9", xds_digit_subTitle_key:"WXYZ"]],
        [[xds_digit_title_key:xds_title_english_switch, xds_digit_subTitle_key:""], [xds_digit_title_key:"0", xds_digit_subTitle_key:""], [xds_digit_title_key:xds_title_delete, xds_digit_subTitle_key:""]],
        ];
    
    deinit {
        NSLog("\(XDSDigitKeyboard.self)===> deinit");
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
        collectionView.register(XDSDigitKeyboardCell.self, forCellWithReuseIdentifier: xds_digitKeyboardCellIdentifier);
        self.addSubview(collectionView);
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(XDSDigitKeyboard.deviceOrientationDidChange(notification:)),
                                               name: NSNotification.Name.UIDeviceOrientationDidChange,
                                               object: nil);
    }
    
    //MARK:UICollectionViewDataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return xdsDigitKeyboardData.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return xdsDigitKeyboardData[section].count;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: xds_digitKeyboardCellIdentifier, for: indexPath) as! XDSDigitKeyboardCell;
        let dict = xdsDigitKeyboardData[indexPath.section][indexPath.row];
        cell.setTitle(text: dict[xds_digit_title_key], subTitle: dict[xds_digit_subTitle_key]);
        return cell;
    }
    
    //MARK:UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true);
        let dict = xdsDigitKeyboardData[indexPath.section][indexPath.row];
        let letter = dict[xds_digit_title_key];
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
        if letter == xds_title_english_switch{//切换英文
            
        }else if letter == xds_title_delete {//删除
            inputTextView?.deleteBackward();
        }else{
            inputTextView?.insertText(letter);//输入
        }
    }
}
