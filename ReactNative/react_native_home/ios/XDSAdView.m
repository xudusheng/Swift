//
//  XDSAdView.m
//  Ad_Demo
//
//  Created by zhengda on 16/10/24.
//  Copyright © 2016年 zhengda. All rights reserved.
//

#import "XDSAdView.h"

@implementation XDSAdView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        //万普广告初始化
        [JOYConnect getConnect:@"38114b15225bf7aa06eb8c4feca73677"
                           pid:@"appstore"
                        userID:nil];
        [JOYConnect sharedJOYConnect].delegate = self;
        self.backgroundColor = [UIColor redColor];
    }
    return self;
}


//JOYConnectDelegate
- (void)onConnectSuccess;{
    NSLog(@"===============================连接成功");
    [JOYConnect showBan:nil adSize:E_SIZE_414x70 showX:0 showY:20];
}
- (void)onConnectFailed:(NSString *)error;{
    NSLog(@"===============================连接失败:%@",error);
}


- (void)onBannerShow{//仅第一次调用的时候通知
    NSLog(@"===============================广告条展示");
}
- (void)onBannerShowFailed:(NSString *)error{
    NSLog(@"===============================广告条展示失败:%@",error);
}
- (void)onBannerClick{
    NSLog(@"===============================点击广告条");
}
- (void)onBannerClose{
    NSLog(@"===============================关闭广告条");
}



@end
