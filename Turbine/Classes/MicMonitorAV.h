//
//  MicMonitorAV.h
//  Turbine
//
//  Copyright Matt Rajca 2011 - 2013. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "MicMonitor.h"

@interface MicMonitorAV : MicMonitor {
  @private
	AVAudioRecorder *_recorder;
	NSTimer *_timer;
}

@end
