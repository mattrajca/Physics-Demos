//
//  MicMonitor.m
//  Turbine
//
//  Copyright Matt Rajca 2011 - 2013. All rights reserved.
//

#import "MicMonitor.h"

@implementation MicMonitor

@synthesize lastRMS, high, threshold, delegate;

- (void)start {
	// to be implemented by subclasses
}

- (void)stop {
	// to be implemented by subclasses
}

- (void)processRMS {
	if (!high && lastRMS > threshold) {
		[delegate performSelectorOnMainThread:@selector(micMonitorCrossedThreshold:)
								   withObject:self
								waitUntilDone:NO];
		
		high = YES;
	}
	else if (high && lastRMS < threshold) {
		[delegate performSelectorOnMainThread:@selector(micMonitorFellBelowThreshold:)
								   withObject:self
								waitUntilDone:NO];
		
		high = NO;
	}
}

@end
