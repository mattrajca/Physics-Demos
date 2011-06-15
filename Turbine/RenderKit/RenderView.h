//
//  RenderView.h
//  RenderKit
//
//  Copyright Matt Rajca 2011. All rights reserved.
//

#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>
#import <QuartzCore/QuartzCore.h>

@interface RenderView : UIView {
  @private
	EAGLContext *_context;
	CADisplayLink *_displayLink;
	GLint _width, _height;
	GLuint _framebuffer, _renderbuffer;
}

/* to override */

- (void)setup;
- (void)update;
- (void)draw;

/* helpers */

- (void)schedule;
- (void)unschedule;

@end
