//
//  XDSMasterViewController.m
//  NLAppEngine
//
//  Copyright © 2017 NeuLion. All rights reserved.
//

#import "XDSMasterViewController.h"

@interface XDSMasterViewController ()

@end

@implementation XDSMasterViewController

+ (XDSMasterViewController *)sharedRootViewController
{
    static XDSMasterViewController *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    if (self.mainViewController) {
        return self.mainViewController.preferredStatusBarStyle;
    }else {
        UIViewController * childVC = [self.childViewControllers lastObject];
        if (childVC) {
            return childVC.preferredStatusBarStyle;
        }else {
            return UIStatusBarStyleDefault;
        }
    }
    
}

#pragma mark -
#pragma mark Public methods

- (void)setMainViewController:(UIViewController *)mainViewController
{
    if ([mainViewController isEqual:_mainViewController]) {
        return;
    }
    
    if(_mainViewController) {
        [_mainViewController removeFromParentViewController];
        if (_mainViewController.view.superview) {
            [_mainViewController.view removeFromSuperview];
        }
    }
    
    if (mainViewController) {
        [self addChildViewController:mainViewController];
        [self.view addSubview:mainViewController.view];
    }
    
    _mainViewController = mainViewController;
    
    [_mainViewController setNeedsStatusBarAppearanceUpdate];
}

#pragma mark -
#pragma mark Private methods

@end
