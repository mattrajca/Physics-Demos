//
//  MicMonitorAU.h
//  Turbine
//
//  Copyright Matt Rajca 2011 - 2013. All rights reserved.
//

#import <AudioToolbox/AudioToolbox.h>
#import "MicMonitor.h"

@interface MicMonitorAU : MicMonitor {
  @public
	AudioComponentInstance _au;
}

@end
