//
//  MicMonitorAV.m
//  Turbine
//
//  Copyright Matt Rajca 2011. All rights reserved.
//

#import "MicMonitorAV.h"

@implementation MicMonitorAV

#define FILTER 0.1f

- (id)init {
	self = [super init];
	if (self) {
		self.threshold = 0.7f;
		
		NSDictionary *settings = [NSDictionary dictionaryWithObjectsAndKeys:
								  [NSNumber numberWithInt:kAudioFormatAppleLossless], AVFormatIDKey,
								  [NSNumber numberWithFloat:44100.0f], AVSampleRateKey,
								  [NSNumber numberWithInt:1], AVNumberOfChannelsKey,
								  [NSNumber numberWithInt:AVAudioQualityMax], AVEncoderAudioQualityKey, nil];
		
		_recorder = [[AVAudioRecorder alloc] initWithURL:[NSURL fileURLWithPath:@"/dev/null"]
												settings:settings
												   error:nil];
		_recorder.meteringEnabled = YES;
		
		[_recorder prepareToRecord];
	}
	return self;
}

- (void)dealloc {
	[_recorder release];
	[_timer release];
	
	[super dealloc];
}

- (void)start {
	[_recorder record];
	
	_timer = [[NSTimer scheduledTimerWithTimeInterval:0.05f
											   target:self
											 selector:@selector(tick)
											 userInfo:nil
											  repeats:YES] retain];
}

- (void)tick {
	[_recorder updateMeters];
	
	double peakPowerForChannel = pow(10, (FILTER * [_recorder peakPowerForChannel:0]));
	self->lastRMS = FILTER * peakPowerForChannel + (1.0 - FILTER) * self->lastRMS;
	
	[self processRMS];
}

- (void)stop {
	[_recorder stop];
}

@end
