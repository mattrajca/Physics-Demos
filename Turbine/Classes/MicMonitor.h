//
//  MicMonitor.h
//  Turbine
//
//  Copyright Matt Rajca 2011. All rights reserved.
//

@interface MicMonitor : NSObject {
  @public
	CGFloat lastRMS;
}

@property (nonatomic, assign) CGFloat lastRMS;

@property (nonatomic, assign) BOOL high;
@property (nonatomic, assign) CGFloat threshold;

@property (nonatomic, assign) id delegate;

- (void)start;
- (void)stop;

- (void)processRMS;

@end


@interface NSObject (MicMonitorDelegate)

- (void)micMonitorCrossedThreshold:(MicMonitor *)monitor;
- (void)micMonitorFellBelowThreshold:(MicMonitor *)monitor;

@end
