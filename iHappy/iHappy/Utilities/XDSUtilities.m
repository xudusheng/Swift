//
//  Utilities.m
//  PlainProgress
//
//  Created by Gome on 15/1/16.
//  Copyright (c) 2015年 xude. All rights reserved.
//

#import <objc/runtime.h>
#import "XDSKeychain.h"
#import "ZDProgressHUD.h"
#import "OCAlertView.h"
#import "XDSUtilities.h"

@implementation XDSUtilities
#pragma mark NSUserDefault使用封装
+(void)setUserDefaultWithValue:(id)value forKey:(NSString *)key{
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:value forKey:key];
    [userDefaults synchronize];
}

+(id)valueForKey:(NSString *)key{
    return [[NSUserDefaults standardUserDefaults]objectForKey:key];
}


#pragma mark - 格式化日期
+ (NSString*)formatDate:(NSDate *)date withFormat:(NSString *)format{//NSDate转String
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = format;
    return [formatter stringFromDate:date];
}

+ (NSString*)TimeInterval:(NSString *)TimeInterval withFormat:(NSString *)format{//时间戳转时间
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:[TimeInterval longLongValue]/1000.0f];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = format;
    return [formatter stringFromDate:date];
}

#pragma mark - 计算时间 例如：刚刚、几秒钟前、几分钟前
+ (NSString *)calculateTime:(NSString *)dateString{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
    NSDate *destDate= [dateFormatter dateFromString:dateString];
    
    NSTimeInterval secondsInterval = [destDate timeIntervalSinceNow];
    NSInteger secondsInt = -secondsInterval;//目标时间距离当前有多少秒
    NSString *destDateString;
    if (secondsInt < 0) {
        destDateString = [NSString stringWithFormat:@"刚刚"];
        return destDateString;
    }
    if (secondsInt >= 24*60*60) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat: @"yyyy-MM-dd"];
        destDateString = [dateFormatter stringFromDate:destDate];
    }else{
        NSInteger residualTimeHour = secondsInt/60/60;
        if (residualTimeHour == 0) {
            NSInteger residualTimeMinute = secondsInt/60;
            if (residualTimeMinute == 0) {
                NSInteger residualTimesecond = secondsInt;
                if (residualTimesecond == 0) {
                    destDateString = [NSString stringWithFormat:@"刚刚"];
                }else{
                    destDateString = [NSString stringWithFormat:@"%ld秒前", (long)residualTimesecond];
                }
                
            }else{
                destDateString = [NSString stringWithFormat:@"%ld分钟前", (long)residualTimeMinute];
            }
        }else{
            destDateString = [NSString stringWithFormat:@"%ld小时前", (long)residualTimeHour];
        }
    }
    return destDateString;
}

+ (NSString *)calculateTimeWithhour:(NSString *)dateString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
    NSDate *destDate= [dateFormatter dateFromString:dateString];
    
    NSTimeInterval secondsInterval = [destDate timeIntervalSinceNow];
    NSInteger secondsInt = -secondsInterval;//目标时间距离当前有多少秒
    NSString *destDateString;
    if (secondsInt < 0) {
        destDateString = [NSString stringWithFormat:@"刚刚"];
        return destDateString;
    }
    if (secondsInt >= 24*60*60) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
        destDateString = [dateFormatter stringFromDate:destDate];
    }else{
        NSInteger residualTimeHour = secondsInt/60/60;
        if (residualTimeHour == 0) {
            NSInteger residualTimeMinute = secondsInt/60;
            if (residualTimeMinute == 0) {
                NSInteger residualTimesecond = secondsInt;
                if (residualTimesecond == 0) {
                    destDateString = [NSString stringWithFormat:@"刚刚"];
                }else{
                    destDateString = [NSString stringWithFormat:@"%d秒前",(int)residualTimesecond];
                }
                
            }else{
                destDateString = [NSString stringWithFormat:@"%d分钟前",(int)residualTimeMinute];
            }
        }else{
            destDateString = [NSString stringWithFormat:@"%d小时前",(int)residualTimeHour];
        }
    }
    return destDateString;
}

+(NSString *)getChinaDate:(NSString *) dateString{
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc]init];//定义NSDateFormatter用来显示格式
    [dateformatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];//设定格式
    NSCalendar *cal = [NSCalendar currentCalendar];//定义一个NSCalendar对象
    
    NSDate *todate = [dateformatter dateFromString:dateString];
    
    NSDate *today = [NSDate date];//得到当前时间
    //用来得到具体的时差
    unsigned int unitFlags;
    unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | kCFCalendarUnitSecond;

    NSDateComponents *comps = [cal components:unitFlags fromDate:today toDate:todate options:0];
    
    if ([comps year]>0) {
        return [NSString stringWithFormat:@"%d年%d月%d天",(int)[comps year], (int)[comps month], (int)[comps day]];
    }else if ([comps month]>0) {
        return [NSString stringWithFormat:@"%d月%d天%d小时",(int)[comps month],(int)[comps day],(int)[comps hour]];
    }else if ([comps day]>0) {
        return [NSString stringWithFormat:@"%d天%d小时%d分",(int)[comps day],(int)[comps hour],(int)[comps minute]];
    }else if ([comps hour]>0) {
        return [NSString stringWithFormat:@"%d小时%d分",(int)[comps hour],(int)[comps minute]];
    }else if ([comps minute]>0) {
        return [NSString stringWithFormat:@"%d分钟",(int)[comps minute]];
    }else if ([comps second]>0){
        return @"1分";
    }else {
        return @"已过期";
    }
}



#pragma mark - 常用控件封装

#pragma mark UILabel
+ (UILabel *)labelWithFrame:(CGRect)frame textAlignment:(NSTextAlignment)textAlignment font:(UIFont *)font text:(NSString *)text textColor:(UIColor *)textColor{
    UILabel * label = [[UILabel alloc]initWithFrame:frame];
    label.backgroundColor = [UIColor clearColor];
    label.text = text;
    label.textAlignment = textAlignment;
    label.font = font;
    label.textColor = textColor;
    return label;
}

#pragma mark UIImageView
+ (UIImageView *)imageViewWithFrame:(CGRect)frame image:(UIImage *)image{
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:frame];
    imageView.userInteractionEnabled = YES;
    imageView.image = image;
    return imageView;
}

#pragma mark UIButton
+ (UIButton *)buttonWithFrame:(CGRect)frame normalImage:(UIImage *)normalImage pressImage:(UIImage *)pressImage title:(NSString *)title titleNormalColor:(UIColor *)titleNormalColor titlePressColor:(UIColor *)titlePressColor font:(UIFont *)font cornerRadius:(CGFloat)cornerRadius target:(id)target selector:(SEL)selector{
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    [button setBackgroundImage:normalImage forState:UIControlStateNormal];
    [button setBackgroundImage:pressImage forState:UIControlStateHighlighted];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateHighlighted];
    [button setTitleColor:titleNormalColor forState:UIControlStateNormal];
    [button setTitleColor:titlePressColor forState:UIControlStateHighlighted];
    button.titleLabel.font = font;//字体大小
    button.layer.cornerRadius = cornerRadius;//导角
    button.layer.masksToBounds = YES;
    button.exclusiveTouch = YES;
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    return button;
}

#pragma mark UIAlertView，iOS8以后使用UIAlertController
+ (void)alertViewWithPresentingController:(UIViewController *)presentingController title:(NSString *)title message:(NSString *)message buttonTitles:(NSArray *)buttonTitles block:(void (^)(NSInteger))block{
    OCAlertView * alertView = [OCAlertView shareInstance];
    [alertView presentingController:presentingController title:title message:message buttonTitles:buttonTitles block:block];
    [alertView alertShow];
}
#pragma  mark - 设置导航栏
+(void)title:(NSString *)title navigationItem:(UINavigationItem *)navigationItem{
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 20)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:18.0f];
    titleLabel.text = title;
    titleLabel.textColor = [UIColor blackColor];
    navigationItem.titleView = titleLabel;
}

+(void)leftNavigaitonBarButtons:(UINavigationItem *)navigationItem target:(id)target action:(SEL)action{//设置导航栏菜单按钮
    UIBarButtonItem * item = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"ico_back"] style:UIBarButtonItemStylePlain target:target action:action];
    navigationItem.leftBarButtonItem = item;
//    UIButton * backButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    backButton.frame = CGRectMake(0, 0, 20 * 0.6, 34 * 0.6);
//    [backButton setBackgroundImage:bundleImage(@"ico_back") forState:UIControlStateNormal];
//    [backButton setBackgroundImage:bundleImage(@"ico_back") forState:UIControlStateHighlighted];
//    [backButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc]initWithCustomView:backButton];
//    backBarButton.style = UIBarButtonItemStylePlain;
//    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
//                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
//                                       target:nil action:nil];
//    if (IOS7) {
//        negativeSpacer.width = -5;
//    }else{
//        negativeSpacer.width = 5;
//    }
//    navigationItem.leftBarButtonItems = @[negativeSpacer, backBarButton];
}
+(void)leftNavigaitonBarButtons:(UINavigationItem *)navigationItem title:(NSString *)title target:(id)target action:(SEL)action{//设置导航栏的左侧文字按钮
    UIBarButtonItem * leftBarButton = [[UIBarButtonItem alloc]initWithTitle:title style:UIBarButtonItemStylePlain target:target action:action];
    leftBarButton.style = UIBarButtonItemStylePlain;
    navigationItem.leftBarButtonItem = leftBarButton;
}

+(void)rightNavigaitonBarButtons:(UINavigationItem *)navigationItem title:(NSString *)title target:(id)target action:(SEL)action{//设置导航栏菜单按钮
    UIBarButtonItem * rightBarButton = [[UIBarButtonItem alloc]initWithTitle:title style:UIBarButtonItemStyleDone target:target action:action];
    rightBarButton.style = UIBarButtonItemStylePlain;
    navigationItem.rightBarButtonItem = rightBarButton;
}

+(void)rightNavigaitonBarButtons:(UINavigationItem *)navigationItem imageName:(NSString *)imageName target:(id)target action:(SEL)action{//设置导航栏菜单按钮
    UIButton * rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(0, 0, 44, 44);
    [rightButton setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [rightButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    //width为负数时，相当于btn向右移动width数值个像素，由于按钮本身和边界间距为5pix，所以width设为-5时，间距正好调整
    //为0；width为正数时，正好相反，相当于往左移动width数值个像素
    negativeSpacer.width = -10;
    navigationItem.rightBarButtonItems = @[negativeSpacer, rightBarButton];
    rightBarButton.style = UIBarButtonItemStylePlain;
}


#pragma mark - HUD
+ (void)showHud:(UIView*)rootView text:(NSString*)text {
    ZDProgressHUD *HUD = [ZDProgressHUD showHUDAddedTo:rootView animated:YES];
    HUD.backgroundColor = [UIColor colorWithRed:0.1f green:0.1f blue:0.1f alpha:0.5f];
//    HUD.backgroundColor = kClearColor;
    HUD.detailsLabelText = text;
    HUD.color = [UIColor colorWithRed:239.0f/255.0f green:239.0f/255.0f blue:239.0f/255.0f alpha:1.0f];
//    HUD.color = kClearColor;
}
+(void)hideHud:(UIView*)rootView{
    ZDProgressHUD * hud = [ZDProgressHUD HUDForView:rootView];
    if (hud) {
        hud.removeFromSuperViewOnHide = YES;//加上这一句，否则出现严重内存泄露   许杜生 2015.07.07  20：04
        [hud hide:YES];
    }
}

+ (void)showHudSuccess:(NSString *)success rootView:(UIView *)rootView imageName:(NSString *)imageName{
    ZDProgressHUD *zd_HUD = [[ZDProgressHUD alloc] initWithView:rootView];
    zd_HUD.backgroundColor =  imageName?[UIColor colorWithRed:0.1f green:0.1f blue:0.1f alpha:0.5f]:[UIColor clearColor];
    zd_HUD.color = [UIColor colorWithWhite:0 alpha:0.7];
    [rootView addSubview:zd_HUD];
    
    UIImageView * customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName?imageName:@"zzzzz"]];//消除警告CUICatalog: Invalid asset name supplied:   在ios7中设置imageView的image时，实例化image时不能传nil,(self.imageView.image = [UIImage imageNamed:nil] 上图所报的错，就是因为这句话)。
    zd_HUD.customView = customView;
    zd_HUD.mode = ZDProgressHUDModeCustomView;
    if (imageName) {
        zd_HUD.detailsLabelText = success;
    }else{
        zd_HUD.labelText = success;
    }
    zd_HUD.removeFromSuperViewOnHide = YES;
    [zd_HUD show:YES];
    [zd_HUD hide:YES afterDelay:1.0];
}

+ (void)showHudFailed:(NSString *)failed rootView:(UIView *)rootView imageName:(NSString *)imageName{
    ZDProgressHUD *zd_HUD = [[ZDProgressHUD alloc] initWithView:rootView];
    zd_HUD.backgroundColor =  imageName?[UIColor colorWithRed:0.1f green:0.1f blue:0.1f alpha:0.5f]:[UIColor clearColor];
    zd_HUD.color = [UIColor colorWithWhite:0 alpha:0.7];
    [rootView addSubview:zd_HUD];
    UIImageView * customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName?imageName:@"zzzzz"]];//消除警告CUICatalog: Invalid asset name supplied:
    zd_HUD.customView = customView;
    zd_HUD.mode = ZDProgressHUDModeCustomView;
    if (imageName) {
        zd_HUD.detailsLabelText = failed;
    }else{
        zd_HUD.labelText = failed;
    }
    zd_HUD.removeFromSuperViewOnHide = YES;
    [zd_HUD show:YES];
    [zd_HUD hide:YES afterDelay:1.0];
    //    [gome_HUD release];//aa00
}
+ (void)showHud:(NSString *)text rootView:(UIView *)rootView hideAfter:(NSInteger)delayTime{
    ZDProgressHUD *zd_HUD = [[ZDProgressHUD alloc] initWithView:rootView];
    zd_HUD.backgroundColor =  [UIColor clearColor];
    zd_HUD.color = [UIColor colorWithWhite:0 alpha:0.7];
    [rootView addSubview:zd_HUD];
//    UIImageView * customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName?imageName:@"zzzzz"]];//消除警告CUICatalog: Invalid asset name supplied:
//    zd_HUD.customView = customView;
    zd_HUD.mode = ZDProgressHUDModeCustomView;
        zd_HUD.labelText = text;
    zd_HUD.removeFromSuperViewOnHide = YES;
    [zd_HUD show:YES];
    [zd_HUD hide:YES afterDelay:delayTime];
}
#pragma mark - 设备标识
+(NSString *)deviceUUID{
    NSString * UUID = [XDSKeychain passwordForService:kAppIdentifier account:kAppIdentifier];
    if (!UUID || [UUID isEqualToString:@""]) {
        //iOS中获取UUID的代码如下
        CFUUIDRef puuid = CFUUIDCreate( nil );
        CFStringRef uuidString = CFUUIDCreateString( nil, puuid );
        NSString * result = (NSString *)CFBridgingRelease(CFStringCreateCopy( NULL, uuidString));
        CFRelease(puuid);
        CFRelease(uuidString);
        [XDSKeychain setPassword:result forService:kAppIdentifier account:kAppIdentifier];
    }
    NSString * uuid = [XDSKeychain passwordForService:kAppIdentifier account:kAppIdentifier]?[XDSKeychain passwordForService:kAppIdentifier account:kAppIdentifier]:@"";
    NSString * deviceUUID = [[NSString alloc]initWithString:uuid];
    return deviceUUID;
}

#pragma mark - 是否第一次使用这个应用
+(BOOL)isAPPFirstUsed{
    NSString * identifier = @"isFirstUsed";
    NSString * isFirstUsed = [XDSKeychain passwordForService:identifier account:identifier];
    if (!isFirstUsed || [isFirstUsed isEqualToString:@""]) {
        return [XDSKeychain setPassword:@"1" forService:identifier account:identifier];
    }
    return NO;
}
#pragma mark - 设备高度
+(int)DeviceHeightFrame{
    if (ISUPPER_IOS7) {
        return 64;
    }else{
        return 44;
    }
}

+(int)statusBarHeight{
    if (ISUPPER_IOS7) {
        return 0;
    }
    return 20;
}

+ (NSMutableAttributedString *)attributedStringWithString:(NSString *)string subString:(NSString *)subString color:(UIColor *)color{
    NSString * bigString = [NSString stringWithFormat:@"%@%@", string, subString];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:bigString];
    NSRange redTextRange = [bigString rangeOfString:subString];
    [str addAttribute:NSForegroundColorAttributeName value:color range:redTextRange];
    return str;
}

+ (NSString *)pathForUserGesturepassword//存放手势密码的文件路径
{
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"gesture.plist"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        [[NSFileManager defaultManager] createFileAtPath:path contents:nil attributes:nil];
    }
    return path;
}

#pragma mark - runtime机制为对象属性赋值，将网络请求的数据全部转为NSString类型
+ (void)setPropertyWithClass:(Class)aClass object:(id)object keyedValues:(NSDictionary *)keyedValues{
    unsigned int count;
    Ivar *properties = class_copyIvarList(aClass, &count);
    for(int i = 0; i < count; i++)
    {
        Ivar ivar = properties[i];
        const char *_propertyName = ivar_getName(ivar); // 获取变量名
        NSString * propertyName = [[NSString stringWithFormat:@"%s", _propertyName] substringFromIndex:1];
        id obj = keyedValues[propertyName];
        NSString * value = @"";
        if ([obj isKindOfClass:[NSNumber class]]) {
            NSString * numString = [NSString stringWithFormat:@"%@", obj];
            if([numString rangeOfString:@"."].location == NSNotFound){
                value = numString;
            }else{
                value = ([obj doubleValue] >= 0)?[NSString stringWithFormat:@"%@", obj]:@"0.00";
            }
        }else if ([obj isKindOfClass:[NSString class]]){
            value = obj;
        }
        object_setIvar(object, ivar, value);//修改变量的值
    }
    free(properties);
}
//格式话小数 四舍五入类型
//NSLog(@"----%@---",[XDSUtilities decimalwithFormat:@"0.0000" floatV:0.334]);
+ (NSString *) decimalwithFormat:(NSString *)format  floatV:(float)floatV{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    
    [numberFormatter setPositiveFormat:format];
    return  [numberFormatter stringFromNumber:[NSNumber numberWithFloat:floatV]];
}

//金额千分位显示
+ (NSString *)formatStringToSaveWithString:(NSString *)string digit:(NSInteger)digit decimalStyle:(BOOL)flag
{
    if (!string.length) return @" ";
    if (flag) {
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        formatter.numberStyle = NSNumberFormatterDecimalStyle;
        string = [formatter stringFromNumber:[NSNumber numberWithDouble:string.doubleValue]];
    }
    
    NSArray *arr = [string componentsSeparatedByString:@"."];
    if (arr.count == 1) {
        if (!digit) return string;
        
        string = [string stringByAppendingString:@"."];
        for (int i = 0; i < digit; i ++) {
            string = [string stringByAppendingString:@"0"];
        }
        return string;
    } else {
        NSString *beforeString = arr[0];
        NSString *afterString = arr[1];
        
        if (digit == 0) {
            return [string componentsSeparatedByString:@"."][0];
        } else if (afterString.length >= digit) {
            return [NSString stringWithFormat:@"%@.%@",beforeString,[afterString substringToIndex:digit]];
        } else {
            NSUInteger c = digit - afterString.length;
            for (int k = 0; k < c; k ++) {
                string = [string stringByAppendingString:@"0"];
            }
            return string;
        }
    }
}

//判断是否为整形：
+ (BOOL)isPureInt:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}
//判断是否为浮点形：
+ (BOOL)isPureFloat:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    float val;
    return[scan scanFloat:&val] && [scan isAtEnd];
}

+ (NSString *)stringFromidString:(id)idString{
    if ([idString isKindOfClass:[NSString class]]) {
        return idString;
    }else if ([idString isKindOfClass:[NSNumber class]]){
        return [NSString stringWithFormat:@"%@", idString];
    }
//    else if ([idString isKindOfClass:[NSNull class]]) {
//        return @"";
//    }
    else{
        return @"";
    }
}

+ (NSDictionary *)detailNullStringFromidDictionary:(NSDictionary *)dic{////处理字典中NSNull值，反正数据存储奔溃
    NSMutableDictionary * multDic = [NSMutableDictionary dictionaryWithDictionary:dic];
    if (multDic) {
        NSArray * keys = multDic.allKeys;
        for (NSString * aKey in keys) {
            id value = multDic[aKey];
            if (!value || [value isKindOfClass:[NSNull class]]) {
                multDic[aKey] = @"";
            }
        }
    }
    return multDic;
}


//高精度的加减乘除
+ (NSString *)calculateWithFirstValue:(NSString *)firstValue secondValue:(NSString *)secondValue type:(CalculateType)type{
    NSDecimalNumber *firstNumber = [NSDecimalNumber decimalNumberWithString:firstValue];
    NSDecimalNumber *secondNumber = [NSDecimalNumber decimalNumberWithString:secondValue];
    NSDecimalNumber *sumNumber;
    switch (type) {
        case CalculateTypeAdding:
            sumNumber = [firstNumber decimalNumberByAdding:secondNumber];
            break;
        case CalculateTypeSubtracting:
            sumNumber = [firstNumber decimalNumberBySubtracting:secondNumber];
            break;
        case CalculateTypeMultiplying:
            sumNumber = [firstNumber decimalNumberByMultiplyingBy:secondNumber];
            break;
        case CalculateTypeDividing:
            sumNumber = [firstNumber decimalNumberByDividingBy:secondNumber];
            break;
    }
    
    return sumNumber.stringValue;
}

//获取字符串的宽度
+ (CGFloat)widthForString:(NSString *)value limitHeight:(CGFloat)limitHeight font:(UIFont *)font{
    
    CGSize infoSize = CGSizeMake(CGFLOAT_MAX, limitHeight);
    NSDictionary *dic = @{NSFontAttributeName : font};
    CGSize size = [value boundingRectWithSize:infoSize options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:dic context:nil].size;
    return size.width;
}
//获得字符串的高度
+ (CGFloat)heightForString:(NSString *)value limitWidth:(CGFloat)limitWidth font:(UIFont *)font{
    CGSize infoSize = CGSizeMake(limitWidth, CGFLOAT_MAX);
    NSDictionary *dic = @{NSFontAttributeName : font};
    CGSize size = [value boundingRectWithSize:infoSize options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:dic context:nil].size;
    return size.height;
}
@end
