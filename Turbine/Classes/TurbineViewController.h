//
//  TurbineViewController.h
//  Turbine
//
//  Copyright Matt Rajca 2011 - 2013. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@class MicMonitor;

@interface TurbineViewController : UIViewController {
  @private
	SKView *_turbineView;
	MicMonitor *_monitor;
}

@end
