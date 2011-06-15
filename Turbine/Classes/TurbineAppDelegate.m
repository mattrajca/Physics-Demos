//
//  TurbineAppDelegate.m
//  Turbine
//
//  Copyright Matt Rajca 2011. All rights reserved.
//

#import "TurbineAppDelegate.h"

#import "TurbineViewController.h"

@interface TurbineAppDelegate ()

- (UIWindow *)window;
- (TurbineViewController *)viewController;

@end


@implementation TurbineAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	[[self window] makeKeyAndVisible];
	return YES;
}

- (UIWindow *)window {
	if (!_window) {
		_window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
		_window.rootViewController = [self viewController];
	}
	
	return _window;
}

- (TurbineViewController *)viewController {
	if (!_viewController) {
		_viewController = [[TurbineViewController alloc] init];
	}
	
	return _viewController;
}

- (void)dealloc {
	[_window release];
	[_viewController release];
	
	[super dealloc];
}

@end
