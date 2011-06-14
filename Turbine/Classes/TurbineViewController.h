//
//  TurbineViewController.h
//  Turbine
//
//  Copyright Matt Rajca 2011. All rights reserved.
//

@class MicMonitor, TurbineView;

@interface TurbineViewController : UIViewController {
  @private
	TurbineView *_turbineView;
	MicMonitor *_monitor;
}

@end
