//
//  OCRuntimeViewController.m
//  XDSSwift
//
//  Created by zhengda on 16/9/6.
//  Copyright © 2016年 zhengda. All rights reserved.
//

#import "OCRuntimeViewController.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import "OCRuntimeModel.h"
#import "OCRuntimeModel+Associated.h"

@interface OCRuntimeViewController ()

@end

@implementation OCRuntimeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray * buttonTitles = @[
                               @"动态创建类，为这个类添加属性和方法",
                               @"获取对象的属性，变量，方法名",
                               @"为category添加属性",
                               @"如果调用的方法不存在，则动态添加方法",
                               @"状态栏提示信息",
                               ];
    
    CGFloat centerY = 100;
    CGFloat width = CGRectGetWidth(self.view.bounds);
    for (int i = 0; i < buttonTitles.count; i ++) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0, width - 60, 40);
        [button setTitle:buttonTitles[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        button.center = CGPointMake(width/2, centerY);
        centerY += 65;
        button.tag = i;
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [self.navigationController setNavigationBarHidden:YES animated:YES];
    NSLog(@"+++++++++++++++++++++++++++");
}
- (void)buttonClick:(UIButton *) button{
    switch (button.tag) {
        case 0:
            //    动态创建类，为这个类添加属性和方法
            [self createClassAndAddIvarAndMethodOnRuntime];
            break;
        case 1:
            //获取对象的属性，变量，方法名
            [self getPropertiesAndIvarsAndMethods];
            break;
        case 2:
            //    为category添加属性
            [self addPropertyToCategory];
            break;
        case 3://如果调用的方法不存在，则动态添加方法
            [self addMethodWhenCalledIsnotExit];
            break;
        default:
            [JDStatusBarNotification showSuccess:@"xxxxxxxxxxxxxx"];
            break;
    }
}

#pragma mark - 动态创建类，为这个类添加属性和方法
void sayFunction(id obj, SEL _cmd, NSString * some, NSString * num){
    NSLog(@"%@ = %@ = %@ = %@", object_getIvar(obj, class_getInstanceVariable([obj class], "_age")), [obj valueForKey:@"name"], some, num);
}
- (void)createClassAndAddIvarAndMethodOnRuntime{
    Class Person = objc_allocateClassPair([NSObject class], "Person", 0);
    class_addIvar(Person, "_name", sizeof(NSString *), log2(sizeof(NSString *)), @encode(NSString *));
    class_addIvar(Person, "_age", sizeof(int), sizeof(int), @encode(int));
    
    SEL s = sel_registerName("say::");
    class_addMethod(Person, s, (IMP)sayFunction, "v@:@@");
    
    objc_registerClassPair(Person);
    
    id peopleInstance = [[Person alloc]init];
    [peopleInstance setValue:@"laodu" forKey:@"name"];
    Ivar ageIvar = class_getInstanceVariable(Person, "_age");
    object_setIvar(peopleInstance, ageIvar, @28);
    
    NSString * string1 = @"你好我好大家好";//这里最好以参数的形式传参，避免参数被提起释放
    NSString * string2 = @"yyyy";
    objc_msgSend(peopleInstance, s, string1, string2);
    
    peopleInstance = nil;
    objc_disposeClassPair(Person);
}

#pragma mark - 获取对象的属性，变量，方法名
- (void)getPropertiesAndIvarsAndMethods{
    OCRuntimeModel * model = [[OCRuntimeModel alloc]init];
    model.age = 12;
    model.name = @"laodu";
    NSLog(@"%@", [model allProperties]);
    NSLog(@"%@", [model allIvars]);
    NSLog(@"%@", [model allMethods]);
    [SwiftUtil showAlertViewWithPresentingController:self
                                               title:nil
                                             message:[NSString stringWithFormat:@"allProperties = %@\nallIvars = %@\nallMethods = %@",[model allProperties].description, model.allIvars.description, model.allMethods.description]
                                        buttonTitles:@[@"确定"]
                                            selected:nil];
}

#pragma mark - 为category添加属性
- (void)addPropertyToCategory{
    __block OCRuntimeModel * model = [[OCRuntimeModel alloc]init];
    model.age = 12;
    model.name = @"laodu";
    model.associatedBust = @34;
    model.associatedCallBack = ^(){
        NSLog(@"xxxxxxxxxxxxxxxxxx");
    };
    model.associatedCallBack();
    
    
    NSDictionary * dict = [model allProperties];
    NSLog(@"%@", dict);
//    [JDStatusBarNotification showSuccess:dict.JSONData];
    @weakify(self);
    [SwiftUtil showAlertViewWithPresentingController:self
                                               title:nil
                                             message:dict.description
                                        buttonTitles:@[@"确定"]
                                            selected:^(NSInteger index){
                                                @strongify(self);
                                                [self.navigationController popViewControllerAnimated:YES];
                                            }];
}

#pragma mark - 如果调用的方法不存在，则动态添加方法
- (void)addMethodWhenCalledIsnotExit{
    OCRuntimeModel * model = [[OCRuntimeModel alloc]init];
    [model sing];
}

@end










