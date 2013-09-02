//
//  Sprite.m
//  RenderKit
//
//  Copyright Matt Rajca 2011. All rights reserved.
//

#import "Sprite.h"

@interface Sprite ()

- (void)createTextureWithSpriteData:(GLubyte *)data width:(size_t)width height:(size_t)height;

@end


@implementation Sprite

@synthesize rotation = _rotation, position = _position;

static const GLshort texCoords[] = {
	0, 0,
	1, 0,
	0, 1,
	1, 1,
};

- (id)initWithImage:(UIImage *)image {
	self = [super init];
	if (self) {
		CGImageRef spriteImage = image.CGImage;
		
		if (spriteImage) {
			size_t width = CGImageGetWidth(spriteImage);
			size_t height = CGImageGetHeight(spriteImage);
			
			_size = CGSizeMake(image.size.width, image.size.height);
			
			GLubyte *spriteData = (GLubyte *) calloc(width * height * 4, sizeof(GLubyte));
			
			CGContextRef spriteContext = CGBitmapContextCreate(spriteData, width, height,
															   8, width * 4, CGImageGetColorSpace(spriteImage),
															   kCGImageAlphaPremultipliedLast);
			
			CGRect frame = CGRectMake(0.0f, 0.0f, (CGFloat) width, (CGFloat) height);
			
			CGContextDrawImage(spriteContext, frame, spriteImage);
			CGContextRelease(spriteContext);
			
			[self createTextureWithSpriteData:spriteData width:width height:height];
			free(spriteData);
		}
	}
	return self;
}

//- (id)initWithSize:(CGSize)size drawingBlock:(DrawingBlock)block {
//	self = [super init];
//	if (self) {
//		size_t width = size.width;
//		size_t height = size.height;
//		
//		_size = CGSizeMake(width, height);
//		
//		GLubyte *spriteData = (GLubyte *) calloc(width * height * 4, sizeof(GLubyte));
//		CGColorSpaceRef cs = CGColorSpaceCreateDeviceRGB();
//		
//		CGContextRef spriteContext = CGBitmapContextCreate(spriteData, width, height,
//														   8, width * 4, cs,
//														   kCGImageAlphaPremultipliedLast);
//		CGColorSpaceRelease(cs);
//		
//		block(spriteContext);
//		CGContextRelease(spriteContext);
//		
//		[self createTextureWithSpriteData:spriteData width:width height:height];
//		free(spriteData);
//	}
//	return self;
//}

- (void)createTextureWithSpriteData:(GLubyte *)data width:(size_t)width height:(size_t)height {
	glGenTextures(1, &_texture);
	glBindTexture(GL_TEXTURE_2D, _texture);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
	glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, data);
}

- (void)draw {
	CGFloat scaledX = _position.x * [UIScreen mainScreen].scale;
	CGFloat scaledY = _position.y * [UIScreen mainScreen].scale;
	CGFloat scaledW = _size.width * [UIScreen mainScreen].scale;
	CGFloat scaledH = _size.height * [UIScreen mainScreen].scale;
	
	const GLshort vertexCoords[] = {
		scaledX, scaledY,
		scaledX + scaledW, scaledY,
		scaledX, scaledY + scaledH,
		scaledX + scaledW, scaledY + scaledH,
	};
	
	glBindTexture(GL_TEXTURE_2D, _texture);
	
	glVertexPointer(2, GL_SHORT, 0, vertexCoords);
	glTexCoordPointer(2, GL_SHORT, 0, texCoords);
	
	if (_rotation) {
		CGFloat x = (scaledX + scaledX + scaledW) / 2;
		CGFloat y = (scaledY + scaledY + scaledH) / 2;
		
		glPushMatrix();
		glTranslatef(x, y, 0.0f);
		glRotatef(_rotation, 0.0f, 0.0f, 1.0f);
		glTranslatef(-x, -y, 0.0f);
	}
	
	glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
	
	if (_rotation) {
		glPopMatrix();
	}
}

@end
