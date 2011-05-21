//
//  BounceyBallsAppDelegate.h
//  BounceyBalls
//
//  Copyright Matt Rajca 2011. All rights reserved.
//

@class BounceyBallsViewController;

@interface BounceyBallsAppDelegate : NSObject < UIApplicationDelegate > {

}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet BounceyBallsViewController *viewController;

@end
