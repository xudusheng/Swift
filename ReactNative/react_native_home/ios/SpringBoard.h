//
//  SpringBoard.h
//  react_native_home
//
//  Created by xudosom on 2016/10/23.
//  Copyright © 2016年 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RCTBridgeModule.h"
typedef void (^loginSuccessBlock)(NSString * userName, NSString * password);
@interface SpringBoard : NSObject<RCTBridgeModule>

@end
