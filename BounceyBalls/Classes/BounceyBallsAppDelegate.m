//
//  BounceyBallsAppDelegate.m
//  BounceyBalls
//
//  Copyright Matt Rajca 2011. All rights reserved.
//

#import "BounceyBallsAppDelegate.h"

#import "BounceyBallsViewController.h"

@implementation BounceyBallsAppDelegate

@synthesize window = _window;
@synthesize viewController = _viewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	self.window.rootViewController = self.viewController;
	[self.window makeKeyAndVisible];
	
	return YES;
}

- (void)dealloc {
	[_window release];
	[_viewController release];
	
	[super dealloc];
}

@end
