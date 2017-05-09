//
//  XDSMasterViewController.h
//  NLAppEngine
//
//  Copyright © 2017 NeuLion. All rights reserved.
//


@interface XDSMasterViewController : UIViewController

@property (nonatomic, strong) UIViewController * mainViewController;

+ (XDSMasterViewController *)sharedRootViewController;

@end
