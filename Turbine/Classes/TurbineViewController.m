//
//  TurbineViewController.m
//  Turbine
//
//  Copyright Matt Rajca 2011. All rights reserved.
//

#import "TurbineViewController.h"

#import "MicMonitorAU.h"
#import "MicMonitorAV.h"

#import "TurbineScene.h"

@implementation TurbineViewController {
	TurbineScene *_turbineScene;
}

- (void)loadView {
	self.view = [self turbineView];
}

- (void)viewDidLoad {
	[super viewDidLoad];
	
	[[self monitor] start];
}

- (SKView *)turbineView {
	if (!_turbineView) {
		_turbineView = [[SKView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 1024.0f, 748.0f)];
		_turbineView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
		
		_turbineScene = [[TurbineScene alloc] initWithSize:_turbineView.bounds.size];
		[_turbineView presentScene:_turbineScene];
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
	[_turbineScene accelerate];
}

- (void)micMonitorFellBelowThreshold:(MicMonitor *)monitor {
	[_turbineScene deaccelerate];
}

@end
