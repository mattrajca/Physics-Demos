//
//  TurbineView.h
//  Turbine
//
//  Copyright Matt Rajca 2011. All rights reserved.
//

#import "RenderView.h"
#import "Sprite.h"

typedef enum {
	TurbinePhaseIdle = 0,
	TurbinePhaseAccelerating,
	TurbinePhaseConstant,
	TurbinePhaseDeaccelerating
} TurbinePhase;

@interface TurbineView : RenderView {
  @private
	Sprite *_background, *_base, *_turbine;
	TurbinePhase _phase;
	CGFloat _t, _lastV, _d;
}

@property (nonatomic, readonly) TurbinePhase phase;

- (void)accelerate;
- (void)deaccelerate;

@end
