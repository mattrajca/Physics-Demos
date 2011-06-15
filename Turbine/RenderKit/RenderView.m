//
//  RenderView.m
//  Turbine
//
//  Copyright Matt Rajca 2011. All rights reserved.
//

#import "RenderView.h"

@interface RenderView ()

- (void)commonInit;

- (void)tick;

@end


@implementation RenderView

+ (Class)layerClass {
	return [CAEAGLLayer class];
}

- (id)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self) {
		[self commonInit];
	}
	return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
	self = [super initWithCoder:aDecoder];
	if (self) {
		[self commonInit];
	}
	return self;
}

- (void)commonInit {
	CAEAGLLayer *layer = (CAEAGLLayer *) self.layer;
	layer.opaque = YES;
	
#warning TODO: set drawable properties
	
	_context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES1];
	[EAGLContext setCurrentContext:_context];
	
	glGenFramebuffersOES(1, &_framebuffer);
	glBindFramebufferOES(GL_FRAMEBUFFER_OES, _framebuffer);
	
	glGenRenderbuffersOES(1, &_renderbuffer);
	glBindRenderbufferOES(GL_RENDERBUFFER_OES, _renderbuffer);
	
	[_context renderbufferStorage:GL_RENDERBUFFER_OES
					 fromDrawable: (CAEAGLLayer *) self.layer];
	
	glFramebufferRenderbufferOES(GL_FRAMEBUFFER_OES, GL_COLOR_ATTACHMENT0_OES,
								 GL_RENDERBUFFER_OES, _renderbuffer);
	
	glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_WIDTH_OES, &_width);
	glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_HEIGHT_OES, &_height);
	
	NSCAssert(glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES) == GL_FRAMEBUFFER_COMPLETE_OES,
			  @"incomplete framebuffer object");
	
	glClearColor(0.0f, 0.0f, 0.0f, 1.0f);
	glViewport(0, 0, _width, _height);
	
	glMatrixMode(GL_PROJECTION);
	glLoadIdentity();
	glOrthof(0.0f, _width, _height, 0.0f, 0.0f, 1.0f);
	
	glMatrixMode(GL_MODELVIEW);
	
	glEnable(GL_TEXTURE_2D);
	glBlendFunc(GL_ONE, GL_ONE_MINUS_SRC_ALPHA);
	glEnable(GL_BLEND);
	
	glEnableClientState(GL_TEXTURE_COORD_ARRAY);
	glEnableClientState(GL_VERTEX_ARRAY);
	
	[self setup];
	[self tick];
}

- (void)setup { }

- (void)update { }

- (void)draw { }

- (void)schedule {
	if (_displayLink)
		return;
	
	_displayLink = [[[UIScreen mainScreen] displayLinkWithTarget:self
														selector:@selector(tick)] retain];
	
	[_displayLink setFrameInterval:1];
	[_displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
}

- (void)unschedule {
	[_displayLink invalidate];
	[_displayLink release];
	_displayLink = nil;
}

- (void)tick {
	[self update];
	
	[EAGLContext setCurrentContext:_context];
	
	glClear(GL_COLOR_BUFFER_BIT);
	
	[self draw];
	
	[_context presentRenderbuffer:GL_RENDERBUFFER_OES];
}

- (void)dealloc {
	if ([EAGLContext currentContext] == _context) {
		[EAGLContext setCurrentContext:nil];
	}
	
	[_context release];
	_context = nil;
	
	[self unschedule];
	
	[super dealloc];
}

@end
