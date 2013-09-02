//
//  TurbineViewController.m
//  Turbine
//
//  Copyright Matt Rajca 2011. All rights reserved.
//

#import "TurbineViewController.h"

#import "MicMonitorAU.h"
#import "MicMonitorAV.h"
#import "TurbineView.h"

@interface TurbineViewController ()

- (TurbineView *)turbineView;
- (MicMonitor *)monitor;

@end

@implementation TurbineViewController

- (void)loadView {
	self.view = [self turbineView];
}

- (void)dealloc {
	[_turbineView release];
	[_monitor release];
	
	[super dealloc];
}

- (TurbineView *)turbineView {
	if (!_turbineView) {
		_turbineView = [[TurbineView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 1024.0f, 748.0f)];
		_turbineView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
	}
	
	return _turbineView;
}

- (MicMonitor *)monitor {
	if (!_monitor) {
		_monitor = [[MicMonitorAU alloc] init];
		_monitor.delegate = self;
	}
	
	return _monitor;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

- (void)micMonitorCrossedThreshold:(MicMonitor *)monitor {
	[_turbineView schedule];
	[_turbineView accelerate];
}

- (void)micMonitorFellBelowThreshold:(MicMonitor *)monitor {
	[_turbineView deaccelerate];
}

- (void)viewDidAppear:(BOOL)animated {
	[[self monitor] start];
}

@end
