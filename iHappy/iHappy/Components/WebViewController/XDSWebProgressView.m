//
//  XDSWebProgressView.m

//  Created by zhengda on 15/11/11.
//  Copyright © 2015年 zhengda. All rights reserved.
//

#import "XDSWebProgressView.h"

@implementation XDSWebProgressView


-(instancetype)initWithFrame:(CGRect)frame progressHeight:(float)height
{
    self=  [super initWithFrame:frame];
    if (self) {
        self.animationFinish=YES;
        self.time = 0.3;
        self.progressHeight = height;
        UIView * view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, height)];
        view.backgroundColor =[UIColor colorWithRed:255/255.0 green:243/255.0 blue:145/255.0 alpha:1.0];
        view.tag = 100;
        self.progressView = view;
        [self addSubview:view];
    }
    return self;
}

-(void)webViewDidStartLoadProgressAnimation
{
    self.isWebStartAnmation = YES;
    [self progressAnimation];
}

-(void)webViewDidFinishLoadProgressAnimation
{
    self.isWebEndAnmation = YES;
    [self progressAnimation];
}

-(void)shouldStartLoadWithRequestProgressAnimation
{
    self.yanshi += 1;
    [self progressAnimation];
}

-(void)progressAnimation
{
    if (self.animationFinish) {
        self.animationFinish = NO;
        [UIView animateWithDuration:self.time delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            
            if (self.isWebStartAnmation) {
                CGRect frame = self.progressView.frame;
                frame.size.width = 1 * self.bounds.size.width;
                self.progressView.frame = frame;
            }else if(self.isWebEndAnmation){
                CGRect frame = self.progressView.frame;
                frame.size.width =  self.bounds.size.width;
                self.progressView.frame = frame;
            }else{
                
                CGRect frame = self.progressView.frame;
                if (frame.size.width>=.5* self.bounds.size.width) {
                    frame.size.width = 0.8 * self.bounds.size.width;
                }else{
                    frame.size.width += 0.25 * self.bounds.size.width;
                }
                self.progressView.frame = frame;
            }
        } completion:^(BOOL finished){
            self.animationFinish =YES;
            if (self.isWebStartAnmation) {
                self.isWebStartAnmation = NO;
                [self progressAnimation];
                return ;
            }
            if (self.isWebEndAnmation) {
                self.isWebEndAnmation = NO;
                self.progressView.frame=CGRectMake(0, 0, 0,   self.progressHeight);
                self.time=0.3;
                return ;
            }
            self.time =.2;
            self.yanshi-=1;
            if (self.yanshi<=0) {
                
            }else{
                [self progressAnimation];
            }
        }];
    }
}


@end
