//
//  XDSKeyboard.swift
//  XDSSwift
//
//  Created by zhengda on 16/9/28.
//  Copyright © 2016年 zhengda. All rights reserved.
//

import UIKit

typealias xds_keyboardCallBack = (String) -> Void;
enum XDSKeyboardType : Int {
    case digit = 1;
    case english = 2;
    case sign = 3;
}
class XDSKeyboard: UIView {
    weak var inputTextView:UITextInput?;
    var digitKeyboard : XDSDigitKeyboard?;
    var englishKeyboard : XDSEnglishKeyboard?;
    var signKeyboard : XDSSignKeyboard?;
    var rootKeyboard : XDSRootKeyboard?;
    
    deinit {
        NSLog("\(self.self) ==> deinit");
    }

    internal init(inputView:UITextInput!, type:XDSKeyboardType){
        super.init(frame:keyboardFrame);
        self.inputTextView = inputView;
        self.setInputKeyboard();
        self.createKeyboardUI(type: type);
    }
    private override init(frame: CGRect) {
        super.init(frame:keyboardFrame);
    }
    init() {
        super.init(frame: keyboardFrame);
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   //UI
    private func createKeyboardUI(type:XDSKeyboardType){
        self.digitKeyboard = XDSDigitKeyboard(callback: { [unowned self](letter:String) in
            self.clickLetterButton(letter: letter);
        })
        self.englishKeyboard = XDSEnglishKeyboard(callback: {[unowned self] (letter:String) in
            self.clickLetterButton(letter: letter);
        });
        self.signKeyboard = XDSSignKeyboard(callback: {[unowned self] (letter:String) in
            self.clickLetterButton(letter: letter);
        });

        switch type {
        case .digit:
            self.addSubview(digitKeyboard!);
            break
        case .english:
            self.addSubview(englishKeyboard!);
            break;
            
        case .sign:
            self.addSubview(signKeyboard!);
            break;
        }
        
        self.rootKeyboard = self.subviews.first as? XDSRootKeyboard;
    }
    
    //MARK:setInputTextView
    private func setInputKeyboard(){
        if self.inputTextView is UITextField {
            let textField = self.inputTextView as! UITextField;
            textField.inputView = self;
        }else if self.inputTextView is UITextView{
            let textView = self.inputTextView as! UITextView;
            textView.inputView = self;
        }
    }
    
    //MARK:Click Letter Button
    private func clickLetterButton(letter:String!){
        if letter == xds_title_digit_switch{//切换数字
            self.transferKeyboard(from: rootKeyboard!, to: digitKeyboard!);

        }else if letter == xds_title_english_switch{//切换英文
            self.transferKeyboard(from: rootKeyboard!, to: englishKeyboard!);
            
        }else if letter == xds_title_sign_switch{//切换符号
            self.transferKeyboard(from: rootKeyboard!, to: signKeyboard!);
            
        }else if letter == xds_title_delete {//删除
            inputTextView?.deleteBackward();
            
        }else if letter == xds_title_space{//输入空格
            inputTextView?.insertText(" ");
            
        }else{
            inputTextView?.insertText(letter);//输入
            
        }
    }
    
    //MARK:切换键盘
    private func transferKeyboard(from:XDSRootKeyboard, to:XDSRootKeyboard){
        UIView.transition(from: from,
                          to: to,
                          duration: 0.0,
                          options: UIViewAnimationOptions.transitionCrossDissolve) {
                            (finish:Bool) in
                            self.rootKeyboard = to;
        };
    }
    
}
