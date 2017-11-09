//
//  ComPlaceholdSplashViewController.m
//  NLAppEngine
//
//  Copyright (c) 2014 NeuLion. All rights reserved.
//

#import "XDSPlaceholdSplashViewController.h"

#if TARGET_OS_IOS
static UIStatusBarStyle splashVCStatusBarStyle = UIStatusBarStyleDefault;
#endif

@interface XDSPlaceholdSplashViewController ()

@property (nonatomic, strong) UIImageView * splashImageView;

@end

@implementation XDSPlaceholdSplashViewController

- (void)dealloc
{
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (!self.isCustomView) {
//        self.splashImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
//        [self.view addSubview:self.splashImageView];
//
//        NSString * imageName = [self getCurrentLaunchImageName];
//        self.splashImageView.image = [UIImage imageNamed:imageName];
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"LaunchScreen" bundle:nil];
        UIViewController *lanchVC = [storyboard instantiateViewControllerWithIdentifier:@"LaunchScreenViewController"];
        lanchVC.view.frame = self.view.bounds;
        [self.view addSubview:lanchVC.view];
        [self addChildViewController:lanchVC];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

#if TARGET_OS_IOS
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        return UIDeviceOrientationIsLandscape((UIDeviceOrientation)interfaceOrientation);
    }else {
        return UIDeviceOrientationIsPortrait((UIDeviceOrientation)interfaceOrientation);
    }
}

-(BOOL)shouldAutorotate
{
    return NO;
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    if (UIUserInterfaceIdiomPad == UI_USER_INTERFACE_IDIOM()) {
        return UIInterfaceOrientationMaskLandscape;
    }else {
        return UIInterfaceOrientationMaskPortrait;
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return splashVCStatusBarStyle;
}

#endif

-(NSString *)getCurrentLaunchImageName
{
    NSString *currentImageName = nil;
    
    CGSize viewSize = self.view.bounds.size;
    NSArray *imageDicts = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"UILaunchImages"];
    
#if TARGET_OS_IOS
    UIInterfaceOrientation orientation = self.preferredInterfaceOrientationForPresentation;
    NSString* viewOrientation = @"Portrait";
    
    if(UIInterfaceOrientationIsLandscape(orientation)){
        viewSize = CGSizeMake(viewSize.height, viewSize.width);
        viewOrientation = @"Landscape";
    }
    for (NSDictionary * dic in imageDicts) {
        CGSize imageSize = CGSizeFromString(dic[@"UILaunchImageSize"]);
        NSString *orientation = dic[@"UILaunchImageOrientation"];
        if(CGSizeEqualToSize(viewSize, imageSize) && [orientation isEqualToString:viewOrientation]){
            currentImageName = dic[@"UILaunchImageName"];
        }
    }
    
    return currentImageName;
#endif
    
    return nil;
}

#if TARGET_OS_IOS

+(NSString *)getCurrentLaunchImageNameWithImageSize:(CGSize)size orientation:(UIInterfaceOrientation)orientation
{
    NSString *currentImageName = nil;
    
    CGSize viewSize = size;
    NSArray *imageDicts = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"UILaunchImages"];
    
    NSString* viewOrientation = @"Portrait";
    
    if(UIInterfaceOrientationIsLandscape(orientation)){
        viewSize = CGSizeMake(viewSize.height, viewSize.width);
        viewOrientation = @"Landscape";
    }
    
    for (NSDictionary * dic in imageDicts) {
        CGSize imageSize = CGSizeFromString(dic[@"UILaunchImageSize"]);
        NSString *orientation = dic[@"UILaunchImageOrientation"];
        if(CGSizeEqualToSize(viewSize, imageSize) && [orientation isEqualToString:viewOrientation]){
            currentImageName = dic[@"UILaunchImageName"];
        }
    }
    
    return currentImageName;

}

+(void)setSplashVCStatusBarStyle:(UIStatusBarStyle)style
{
    splashVCStatusBarStyle = style;
}

#endif

@end

