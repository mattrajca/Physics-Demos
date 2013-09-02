//
//  Sprite.h
//  RenderKit
//
//  Copyright Matt Rajca 2011. All rights reserved.
//

#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>

#import "DrawableObject.h"

typedef void (^DrawingBlock) (CGContextRef context);

@interface Sprite : NSObject < DrawableObject > {
  @private
	GLuint _texture;
	CGSize _size;
}

@property (nonatomic, assign) CGPoint position;

@property (nonatomic, assign) GLfloat rotation;

- (id)initWithImage:(UIImage *)image;
//- (id)initWithSize:(CGSize)size drawingBlock:(DrawingBlock)block;

@end
