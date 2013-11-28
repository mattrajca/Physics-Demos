//
//  TurbineScene.h
//  Turbine
//
//  Copyright Matt Rajca 2011 - 2013. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

typedef enum {
	TurbinePhaseIdle = 0,
	TurbinePhaseAccelerating,
	TurbinePhaseConstant,
	TurbinePhaseDeaccelerating
} TurbinePhase;

@interface TurbineScene : SKScene {
  @private
	SKSpriteNode *_background, *_base, *_turbine;
	TurbinePhase _phase;
	CGFloat _t, _lastV, _d;
}

- (void)accelerate;
- (void)deaccelerate;

@end
