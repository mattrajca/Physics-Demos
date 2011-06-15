//
//  MicMonitorAU.h
//  Turbine
//
//  Copyright Matt Rajca 2011. All rights reserved.
//

#import <AudioToolbox/AudioToolbox.h>
#import "MicMonitor.h"

@interface MicMonitorAU : MicMonitor {
  @public
	AudioComponentInstance _au;
}

@end
