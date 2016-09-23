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
//        self.createEnglishKeyboard();
//        self.createEnglishKeyboardWithAotoLayout();
    }
    
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: SWIFT_DEVICE_SCREEN_WIDTH, height: 216));
//        self.createEnglishKeyboard();
//        self.createEnglishKeyboardWithAotoLayout();
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NSLog("yyyyyyyyyyyy")
    }
    
    //MARK: 纯英文键盘
    private func createEnglishKeyboardWithAotoLayout(){
        NSLog("xxxxxxxxxx");
        let marginGap = CGFloat(4.0);//边缘边距
        let horizontalGap = marginGap * 2;//按钮水平间距
        let verticalGap = CGFloat(15.0);

        let buttonHeight = (self.frame.height - verticalGap*4)/4;
        let lowerLetters:[Array<String>] = [
            ["q", "w", "e", "r", "t", "y", "u", "i", "o", "p"],
            [ "a", "s", "d", "f", "g", "h", "j", "k", "l"],
            ["z", "x", "c", "v", "b", "n", "m"]];
        
        let gap_horizontal_key = "horizontalGap";
        let gap_vertical_key = "verticalGap";
        let gap_margin_key = "marginGap";

        //间距的metrics信息
        let metrics = [gap_horizontal_key:horizontalGap,
                       gap_vertical_key:verticalGap,
                       gap_margin_key:marginGap];
        var buttonTag = 0;
        var lastButton:UIButton?;
        var last_button_view_key = "";
//        var constraintArr = [NSLayoutConstraint]();
        var buttonArr = [UIButton]();
        for index in 0..<lowerLetters.count{
            let letters = lowerLetters[index];
            NSLog("\(index) = \(letters)");
            var viewsDict:[String:UIButton] = ["xxx":UIButton()];
            var VFLString_horizontal = "H:";
            var firstButton_onCurrentLine:UIButton? = nil;//用于约束当前行的第一个按钮（右边距）
            var lastLineButton_onCurrentLine:UIButton? = nil;//用于约束前行的最后一个按钮（左边距）
            
            for i in 0..<letters.count{
                let aLetter = letters[i];
//                let button = self.createButton(frame: CGRect.zero, title: aLetter, tag: buttonTag);
                let button = UIButton(type: .custom);
                button.frame = frame;
                button.translatesAutoresizingMaskIntoConstraints = false;
                button.backgroundColor = UIColor.lightGray;
                button.setTitle(aLetter, for: .normal);
                button.layer.cornerRadius = 5.0;
                button.layer.masksToBounds = true;
                button.tag = buttonTag;
                
                self.addSubview(button);
                let button_view_key = "button\(buttonTag)";//用于约束的视图key
                buttonTag += 1;//按钮的tag
                buttonArr.append(button);
                
                if lastButton == nil {
                    let firstButton_left_constraint = NSLayoutConstraint(item: button,
                                                                         attribute: .left,
                                                                         relatedBy: .equal,
                                                                         toItem: self,
                                                                         attribute: .left,
                                                                         multiplier: 1.0,
                                                                         constant: marginGap);
//                    constraintArr.append(firstButton_left_constraint);
                    self.addConstraint(firstButton_left_constraint);
                    VFLString_horizontal.append("[\(button_view_key)]");
//                    let VFLString_vertical = "V:|-\(verticalGap*3/4)-[\(button_view_key)(==\(buttonHeight))]";
//                    let constraints = NSLayoutConstraint.constraints(withVisualFormat: VFLString_vertical,
//                                                                     options: .alignAllCenterX,
//                                                                     metrics: metrics,
//                                                                     views: [button_view_key:button]);
//                    constraintArr += constraints;
                    firstButton_onCurrentLine = button;
                }
//                else if(firstButton_onCurrentLine == nil){//添加右边距
//                    firstButton_onCurrentLine = button;
//                    let firstButton_left_constraints = NSLayoutConstraint.constraints(withVisualFormat: VFLString_horizontal,
//                                                                                options: .alignAllCenterY,
//                                                                                metrics: metrics,
//                                                                                views: viewsDict);
//                    
//                }
                else{
                    VFLString_horizontal.append("-\(gap_horizontal_key)-[\(button_view_key)(==\(last_button_view_key))]");
                    let equalHeight = NSLayoutConstraint(item: button,
                                                         attribute: .height,
                                                         relatedBy: .equal,
                                                         toItem: lastButton,
                                                         attribute: .height,
                                                         multiplier: 1.0,
                                                         constant: 0);
//                    constraintArr.append(equalHeight);
                    self.addConstraint(equalHeight);
                }
                
                
                lastButton = button;
                last_button_view_key = button_view_key;
                viewsDict[last_button_view_key] = button;
            }
//            VFLString_horizontal.append("-\(gap_margin_key)-|");
            let constraints_horizontal = NSLayoutConstraint.constraints(withVisualFormat: VFLString_horizontal,
                                                              options: .alignAllCenterY,
                                                              metrics: metrics,
                                                              views: viewsDict);
//            constraintArr += constraints_horizontal;
//            self.addConstraints(constraintArr);
//            constraintArr.removeAll();
            
            self.addConstraints(constraints_horizontal);
            let first = buttonArr.first;
            let last = buttonArr.last;
            let firstButton_right_constraint = NSLayoutConstraint(item: last,
                                                                 attribute: .right,
                                                                 relatedBy: .equal,
                                                                 toItem: self,
                                                                 attribute: .right,
                                                                 multiplier: 1.0,
                                                                 constant: 0);
//            constraintArr.append(firstButton_right_constraint);
            self.addConstraint(firstButton_right_constraint);
            
//            let equalMargin = NSLayoutConstraint(item: last,
//                                                                  attribute: .right,
//                                                                  relatedBy: .equal,
//                                                                  toItem: first,
//                                                                  attribute: .left,
//                                                                  multiplier: 1.0,
//                                                                  constant: 0);
//            //            constraintArr.append(firstButton_right_constraint);
//            self.addConstraint(equalMargin);
            
            buttonArr.removeAll();
            break;
        }
        
        //创建空格
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
                let _ = self.createButton(frame: frame, title: aLetter, tag: buttonTag);
                originX += (buttonWidth + horizontalGap*2);
                buttonTag += 1;
            }
            originY += (verticalGap + buttonHeight);
        }
        
        //创建空格
    }
    
    
    private func createButton(frame:CGRect, title:String, tag:Int) -> UIButton{
        let button = UIButton(type: .custom);
        button.frame = frame;
        button.translatesAutoresizingMaskIntoConstraints = false;
        button.backgroundColor = UIColor.lightGray;
        button.setTitle(title, for: .normal);
        button.layer.cornerRadius = 5.0;
        button.layer.masksToBounds = true;
        button.tag = tag;
        return button;
    }
}
