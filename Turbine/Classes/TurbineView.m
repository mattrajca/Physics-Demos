//
//  TurbineView.m
//  Turbine
//
//  Copyright Matt Rajca 2011. All rights reserved.
//

#import "TurbineView.h"

@implementation TurbineView

#define ACCEL 500
#define DEACCEL -100
#define WIND 400

#define INTERVAL 1.0f/60

@synthesize phase = _phase;

- (void)setup {
	_background = [[Sprite alloc] initWithImage:[UIImage imageNamed:@"Sky.jpg"]];
	
	_base = [[Sprite alloc] initWithImage:[UIImage imageNamed:@"Base"]];
	_base.position = CGPointMake(340.0f, 348.0f);
	
	_turbine = [[Sprite alloc] initWithImage:[UIImage imageNamed:@"Turbine"]];
	_turbine.position = CGPointMake(211.0f, 186.0f);
}

- (void)dealloc {
	[_background release];
	[_base release];
	[_turbine release];
	
	[super dealloc];
}

- (void)update {
	if (_phase == TurbinePhaseIdle)
		return;
	
	if (_phase == TurbinePhaseAccelerating) {
		CGFloat d = _d + 0.5f * ACCEL * (_t * _t);
		_t += INTERVAL;
		
		CGFloat vel = ACCEL * _t;
		
		if (vel > WIND) {
			_phase = TurbinePhaseConstant;
			_lastV = vel;
			_d = d;
			_t = 0;
		}
		
		_turbine.rotation = d;
	}
	else if (_phase == TurbinePhaseConstant) {
		CGFloat d = _d + _lastV * _t;
		_t += INTERVAL;
		
		_turbine.rotation = d;
	}
	else if (_phase == TurbinePhaseDeaccelerating) {
		CGFloat d = _d + _lastV * _t + 0.5f * DEACCEL * (_t * _t);
		_t += INTERVAL;
		
		CGFloat vel = _lastV + DEACCEL * _t;
		
		if (vel < 0) {
			[self unschedule];
			
			_t = _lastV = 0;
			_phase = TurbinePhaseIdle;
			_d = d;
		}
		else {
			_turbine.rotation = d;
		}
	}
}

- (void)accelerate {
	_d += _lastV * _t;
	_t = 0;
	_phase = TurbinePhaseAccelerating;
}

- (void)deaccelerate {
	_d += _lastV * _t;
	_t = 0;
	_phase = TurbinePhaseDeaccelerating;
}

- (void)draw {
	[_background draw];
	[_base draw];
	[_turbine draw];
}

@end
