//
//  Utilities.h
//  PlainProgress
//
//  Created by Gome on 15/1/16.
//  Copyright (c) 2015年 xude. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@class ZDProgressHUD;

@interface XDSUtilities : NSObject
+(void)setUserDefaultWithValue:(id)value forKey:(NSString *)key;
+(id)valueForKey:(NSString *)key;

#pragma mark - 格式化日期
+ (NSString*)formatDate:(NSDate *)date withFormat:(NSString *)format;//NSDate转String
+ (NSString*)TimeInterval:(NSString *)TimeInterval withFormat:(NSString *)format;//时间戳转时间
#pragma mark - 计算时间 例如：刚刚、几秒钟前、几分钟前
+ (NSString *)calculateTime:(NSString *)dateString;
+ (NSString *)calculateTimeWithhour:(NSString *)dateString ;
+(NSString *)getChinaDate:(NSString *)dateString;

#pragma mark - 常用控件封装
#pragma mark UILabel
+ (UILabel *)labelWithFrame:(CGRect)frame
              textAlignment:(NSTextAlignment)textAlignment
                       font:(UIFont *)font text:(NSString *)text
                  textColor:(UIColor *)textColor;
#pragma mark UIImageView
+ (UIImageView *)imageViewWithFrame:(CGRect)frame
                              image:(UIImage *)image;
#pragma mark UIButton
+ (UIButton *)buttonWithFrame:(CGRect)frame
                  normalImage:(UIImage *)normalImage
                   pressImage:(UIImage *)pressImage
                        title:(NSString *)title
             titleNormalColor:(UIColor *)titleNormalColor
              titlePressColor:(UIColor *)titlePressColor
                         font:(UIFont *)font
                 cornerRadius:(CGFloat)cornerRadius
                       target:(id)target
                     selector:(SEL)selector;
#pragma mark UIAlertView，iOS8以后使用UIAlertController
+ (void)alertViewWithPresentingController:(UIViewController *)presentingController
                                    title:(NSString *)title
                                  message:(NSString *)message
                             buttonTitles:(NSArray *)buttonTitles
                                    block:(void (^)(NSInteger))block;

#pragma  mark - 设置导航栏
+(void)title:(NSString *)title navigationItem:(UINavigationItem *)navigationItem;
+(void)leftNavigaitonBarButtons:(UINavigationItem *)navigationItem
                         target:(id)target
                         action:(SEL)action;//设置导航栏的返回按钮
+(void)leftNavigaitonBarButtons:(UINavigationItem *)navigationItem
                          title:(NSString *)title
                         target:(id)target
                         action:(SEL)action;//设置导航栏的左侧按钮

+(void)rightNavigaitonBarButtons:(UINavigationItem *)navigationItem
                           title:(NSString *)title
                          target:(id)target
                          action:(SEL)action;//设置导航栏的右侧按钮
+(void)rightNavigaitonBarButtons:(UINavigationItem *)navigationItem
                       imageName:(NSString *)imageName
                          target:(id)target action:(SEL)action;//设置导航栏菜单按钮

#pragma mark - HUD
+ (void)showHud:(UIView*)rootView text:(NSString*)text;//显示HUD
+(void)hideHud:(UIView*)rootView;
+ (void)showHudSuccess:(NSString *)success rootView:(UIView *)rootView  imageName:(NSString *)imageName;//成功时，一秒后消隐
+ (void)showHudFailed:(NSString *)failed rootView:(UIView *)rootView  imageName:(NSString *)imageName;//失败时，一秒后消隐
+ (void)showHud:(NSString *)text rootView:(UIView *)rootView hideAfter:(NSInteger)delayTime;

+(NSString *)deviceUUID;//设备标识，目前使用UDID存KeyChain
+(BOOL)isAPPFirstUsed;//是否第一次使用APP
+(int)DeviceHeightFrame;//导航栏高度
+(int)statusBarHeight;//状态栏高度

+ (NSMutableAttributedString *)attributedStringWithString:(NSString *)string subString:(NSString *)subString color:(UIColor *)color;
+ (NSString *)pathForUserGesturepassword;//存放手势密码的文件路径
#pragma mark - runtime机制为对象属性赋值，将网络请求的数据全部转为NSString类型
+ (void)setPropertyWithClass:(Class)aClass object:(id)object keyedValues:(NSDictionary *)keyedValues;

+ (NSString *)stringFromidString:(id)idString;//处理网络请求的数据，防止NSNull值
+ (NSDictionary *)detailNullStringFromidDictionary:(NSDictionary *)dic;////处理字典中NSNull值，反正数据存储奔溃

//格式话小数 四舍五入类型
//NSLog(@"----%@---",[XDSUtilities decimalwithFormat:@"0.0000" floatV:0.334]);
+ (NSString *)decimalwithFormat:(NSString *)format  floatV:(float)floatV;
+ (NSString *)formatStringToSaveWithString:(NSString *)string digit:(NSInteger)digit decimalStyle:(BOOL)flag;//金额千分位显示

//判断是否为整形：
+ (BOOL)isPureInt:(NSString*)string;
//判断是否为浮点形：
+ (BOOL)isPureFloat:(NSString*)string;

typedef NS_ENUM(NSInteger, CalculateType){
    CalculateTypeAdding,//加
    CalculateTypeSubtracting,//减
    CalculateTypeMultiplying,//乘
    CalculateTypeDividing,//除
};
//高精度的加减乘除
+ (NSString *)calculateWithFirstValue:(NSString *)firstValue
                          secondValue:(NSString *)secondValue
                                 type:(CalculateType)type;

//获取字符串的宽度
+ (CGFloat)widthForString:(NSString *)value
              limitHeight:(CGFloat)limitHeight
                     font:(UIFont *)font;
//获得字符串的高度
+ (CGFloat)heightForString:(NSString *)value
                limitWidth:(CGFloat)limitWidth
                      font:(UIFont *)font;
@end
