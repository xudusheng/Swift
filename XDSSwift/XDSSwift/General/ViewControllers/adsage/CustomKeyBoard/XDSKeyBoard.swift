//
//  XDSKeyBoard.swift
//  XDSSwift
//
//  Created by zhengda on 16/9/21.
//  Copyright © 2016年 zhengda. All rights reserved.
//

import UIKit

class XDSKeyBoard: UIView {
    override init(frame: CGRect) {
        super.init(frame: CGRect(x: 0, y: 0, width: SWIFT_DEVICE_SCREEN_WIDTH, height: 216));
        self.createEnglishKeyboard();
    }
    
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: SWIFT_DEVICE_SCREEN_WIDTH, height: 216));
        self.createEnglishKeyboard();
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NSLog("yyyyyyyyyyyy")
    }
    
    //MARK: 纯英文键盘
    private func createEnglishKeyboard(){
        NSLog("xxxxxxxxxx");
        let horizontalGap = CGFloat(5.0);
        let verticalGap = CGFloat(15.0);
        let buttonHeight = (self.frame.height - verticalGap*4)/4;
        let buttonWidth = (self.frame.width - horizontalGap*2*10)/10.0;
        let lowerLetters:[Array<String>] = [
            ["q", "w", "e", "r", "t", "y", "u", "i", "o", "p"],
            [ "a", "s", "d", "f", "g", "h", "j", "k", "l"],
            ["z", "x", "c", "v", "b", "n", "m"]];
        
        var originX = horizontalGap;
        var originY = verticalGap * 3.0 / 4.0;
        var buttonTag = 0;
        for index in 0..<lowerLetters.count{
            let letters = lowerLetters[index];
            NSLog("\(index) = \(letters)");
            originX = (self.frame.width - (buttonWidth + horizontalGap * 2) * letters.count.cgFloatValue()) / 2;
            originX += horizontalGap;
            for i in 0..<letters.count{
                let aLetter = letters[i];
                let frame = CGRect(x: originX, y: originY, width: buttonWidth, height: buttonHeight);
                self.createButton(frame: frame, title: aLetter, tag: buttonTag);
                originX += (buttonWidth + horizontalGap*2);
                buttonTag += 1;
            }
            originY += (verticalGap + buttonHeight);
        }
        
        //创建空格
    }
    
    
    private func createButton(frame:CGRect, title:String, tag:Int){
        let button = UIButton(type: .custom);
        button.frame = frame;
        button.backgroundColor = UIColor.lightGray;
        button.setTitle(title, for: .normal);
        button.layer.cornerRadius = 5.0;
        button.layer.masksToBounds = true;
        button.tag = tag;
        self.addSubview(button);
    }
}
