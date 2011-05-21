//
//  BounceyBallsViewController.h
//  BounceyBalls
//
//  Copyright Matt Rajca 2011. All rights reserved.
//

#import "chipmunk.h"

@interface BounceyBallsViewController : UIViewController < UIAccelerometerDelegate > {
  @private
	cpSpace *_space;
}

@end
