//
//  OCRuntimeModel.h
//  XDSSwift
//
//  Created by zhengda on 16/9/7.
//  Copyright © 2016年 zhengda. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OCRuntimeModel : NSObject{
    NSString *_occupation;
    NSString *_nationality;
}
@property (nonatomic, copy) NSString *name;
@property (nonatomic) NSUInteger age;

- (NSDictionary *)allProperties;
- (NSDictionary *)allIvars;
- (NSDictionary *)allMethods;

- (int)count;

@end
