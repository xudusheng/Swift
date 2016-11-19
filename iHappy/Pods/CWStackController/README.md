# CWStackController

CWStackController is a UINavigationController like custom container view controller which provides fullscreen pan gesture support to POP and PUSH , inspired by [Netease News](https://itunes.apple.com/cn/app/id425349261) and used in my recent app [cnBeta Reader](https://itunes.apple.com/cn/app/id885800972).

![demo gif](/demo.gif)

## Usage

CWStackController's APIs are pretty much like UINavigationController's which make it very easy to use:

	// Init
	- (instancetype)initWithRootViewController:(UIViewController *)rootViewController;

	// Push
	- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated;

	// Pop
	- (UIViewController *)popViewControllerAnimated:(BOOL)animated;
	- (NSArray *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated;
	- (NSArray *)popToRootViewControllerAnimated:(BOOL)animated;

	// Accessing
	@property (nonatomic) NSArray *viewControllers;
	- (void)setViewControllers:(NSArray *)viewControllers animated:(BOOL)animated;
	@property (nonatomic, readonly) UIViewController *topViewController;

**Enable to push new controller through pan gesture**:

Assume you have a view controller A is in the CWStackController stack, you want push a new view controller B into stack through pan gesture, all you need is let A confirms to `CWStackProtocol` and implements `- (UIViewController *)nextViewController`:

	// A.m
	- (UIViewController *)nextViewController
	{
		return B;
	}

You can customize the threshold to trigger a push or pop through pan gesture, the duration for animations and the shadow.

**Work with scroll view:**

CWStackController works well with scroll view now, if you want have scroll view in the child view controller and you want to PUSH or POP by drag it, you need to set scroll view to CWStackController instance using it's API:

	- (void)setContentScrollView:(UIScrollView *)scrollView;

See *Demo* project for more details.

## Installation

There are two options:

1. CWStackController is available as `CWStackController` in CocoaPods.
2. Drag *CWStackController* folder from demo project into your Xcode project.

## Requirement

* iOS 5.0 or higher
* ARC

## License

CWStackController is available under the MIT license. See the LICENSE file for more info.


	


