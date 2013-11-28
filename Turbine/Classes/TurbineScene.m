//
//  TurbineScene.m
//  Turbine
//
//  Copyright Matt Rajca 2011 - 2013. All rights reserved.
//

#import "TurbineScene.h"

@implementation TurbineScene

#define ACCEL 5.0
#define DEACCEL -2.5
#define WIND 10.0

#define INTERVAL 1.0f/60

- (instancetype)initWithSize:(CGSize)size {
	self = [super initWithSize:size];
	if (self) {
		[self setup];
	}
	return self;
}

- (void)setup {
	_background = [SKSpriteNode spriteNodeWithImageNamed:@"Sky.jpg"];
	_background.anchorPoint = CGPointZero;
	
	_base = [SKSpriteNode spriteNodeWithImageNamed:@"Base"];
	_base.position = CGPointMake(340.0f, 0.0f);
	_base.anchorPoint = CGPointZero;
	
	_turbine = [SKSpriteNode spriteNodeWithImageNamed:@"Turbine"];
	_turbine.position = CGPointMake(346.0f, 406.0f);
	
	[self addChild:_background];
	[self addChild:_base];
	[self addChild:_turbine];
}

- (void)accelerate {
	if (_phase == TurbinePhaseConstant || _phase == TurbinePhaseAccelerating) {
		return;
	}
	else if (_phase == TurbinePhaseIdle) {
		_lastV = 0;
	}
	else if (_phase == TurbinePhaseDeaccelerating) {
		_d = _d + _lastV * _t + 0.5f * DEACCEL * (_t * _t);
	}
	
	_t = 0;
	_phase = TurbinePhaseAccelerating;
}

- (void)deaccelerate {
	if (_phase == TurbinePhaseIdle || _phase == TurbinePhaseDeaccelerating) {
		return;
	}
	else if (_phase == TurbinePhaseConstant) {
		_d += _lastV * _t;
	}
	else if (_phase == TurbinePhaseAccelerating) {
		_d += 0.5f * ACCEL * (_t * _t);
	}
	
	_t = 0;
	_phase = TurbinePhaseDeaccelerating;
}

- (void)update:(NSTimeInterval)currentTime {
	if (_phase == TurbinePhaseIdle)
		return;
	
	if (_phase == TurbinePhaseAccelerating) {
		CGFloat d = _d + 0.5f * ACCEL * (_t * _t);
		_t += INTERVAL;
		
		_lastV = ACCEL * _t;
		
		if (_lastV > WIND) {
			_phase = TurbinePhaseConstant;
			_d = d;
			_t = 0;
		}
		
		_turbine.zRotation = d;
	}
	else if (_phase == TurbinePhaseConstant) {
		CGFloat d = _d + _lastV * _t;
		_t += INTERVAL;
		
		_turbine.zRotation = d;
	}
	else if (_phase == TurbinePhaseDeaccelerating) {
		CGFloat d = _d + _lastV * _t + 0.5f * DEACCEL * (_t * _t);
		_t += INTERVAL;
		
		CGFloat vel = _lastV + DEACCEL * _t;
		
		if (vel < 0) {
			_t = _lastV = 0;
			_phase = TurbinePhaseIdle;
			_d = d;
		}
		else {
			_turbine.zRotation = d;
		}
	}
}

@end
