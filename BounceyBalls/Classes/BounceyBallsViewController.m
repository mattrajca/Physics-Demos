//
//  BounceyBallsViewController.m
//  BounceyBalls
//
//  Copyright Matt Rajca 2011. All rights reserved.
//

#import "BounceyBallsViewController.h"

@interface BounceyBallsViewController ()

- (void)setupSpace;
- (void)dropBallAtPoint:(CGPoint)pt;
- (void)step;
- (UIColor *)ballColor;

- (void)tap:(UITapGestureRecognizer *)gr;

@end


@implementation BounceyBallsViewController

#define GRAVITY 400.0f
#define BALL_MASS 1.0f
#define MIN_R 6
#define MAX_R 32

#define STEP_INTERVAL 1/60.0f
#define ACCEL_INTERVAL 1/30.0f
#define FILTER_FACTOR 0.05f

#define BK_COLOR_KEY @"bk_color"

- (id)initWithCoder:(NSCoder *)aDecoder {
	self = [super initWithCoder:aDecoder];
	if (self) {
		cpInitChipmunk();
	}
	return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	
	srand(time(NULL));
	[self setupSpace];
	
	UITapGestureRecognizer *gr = [[UITapGestureRecognizer alloc] initWithTarget:self
																		 action:@selector(tap:)];
	
	[self.view addGestureRecognizer:gr];
	[gr release];
}

- (void)viewDidAppear:(BOOL)animated {
	[NSTimer scheduledTimerWithTimeInterval:STEP_INTERVAL
									 target:self
								   selector:@selector(step)
								   userInfo:nil
									repeats:YES];
	
	[UIAccelerometer sharedAccelerometer].updateInterval = ACCEL_INTERVAL;
	[UIAccelerometer sharedAccelerometer].delegate = self;
}

- (void)setupSpace {
	_space = cpSpaceNew(); // setup the world in which the simulation takes place
	_space->elasticIterations = _space->iterations;
	_space->gravity = cpv(0.0f, GRAVITY); // initial gravity vector
	
	CGSize size = [[self view] bounds].size;
	
	// setup the 'edges' of our world so the bouncing balls don't move offscreen
	cpBody *edge = cpBodyNewStatic();
	cpShape *shape = NULL;
	
	// left
	shape = cpSegmentShapeNew(edge, cpvzero, cpv(0.0f, size.height), 0.0f);
	shape->u = 0.1f; // minimal friction on the ground
	shape->e = 0.7f;
	cpSpaceAddStaticShape(_space, shape); // a body can be represented by multiple shapes
	
	// top
	shape = cpSegmentShapeNew(edge, cpvzero, cpv(size.width, 0.0f), 0.0f);
	shape->u = 0.1f;
	shape->e = 0.7f;
	cpSpaceAddStaticShape(_space, shape);
	
	// right
	shape = cpSegmentShapeNew(edge, cpv(size.width, 0.0f), cpv(size.width, size.height), 0.0f);
	shape->u = 0.1f;
	shape->e = 0.7f;
	cpSpaceAddStaticShape(_space, shape);
	
	// bottom
	shape = cpSegmentShapeNew(edge, cpv(0.0f, size.height), cpv(size.width, size.height), 0.0f);
	shape->u = 0.1f;
	shape->e = 0.7f;
	cpSpaceAddStaticShape(_space, shape);
}

- (void)dropBallAtPoint:(CGPoint)pt {
	cpFloat r = MIN_R + rand() % (MAX_R-MIN_R);
	
	CALayer *layer = [CALayer layer];
	layer.delegate = self;
	layer.position = pt;
	layer.bounds = CGRectMake(0.0f, 0.0f, r * 2, r * 2);
	layer.contentsScale = [UIScreen mainScreen].scale;
	[layer setValue:[self ballColor] forKey:BK_COLOR_KEY];
	
	[[self.view layer] addSublayer:layer];
	[layer setNeedsDisplay];
	
	cpBody *body = cpBodyNew(BALL_MASS, INFINITY);
	body->p = pt; // this dynamic body represents the ball at its center position
	cpSpaceAddBody(_space, body);
	
	cpShape *ball = cpCircleShapeNew(body, r, cpvzero);
	ball->data = layer;
	ball->u = 0.0f;
	ball->e = 0.7f; // bounciness
	cpSpaceAddShape(_space, ball);
}

- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx {
	CGColorRef color = (CGColorRef) [[layer valueForKey:BK_COLOR_KEY] CGColor];
	CGRect rect = [layer bounds];
	
	CGContextSetFillColorWithColor(ctx, color);
	CGContextFillEllipseInRect(ctx, rect);
}

static void updateSpace (void *obj, void *data) {
	cpShape *shape = (cpShape *) obj;
	CALayer *layer = shape->data;
	
	if (!layer)
		return;
	
	// sync the body's position with the on-screen representation
	layer.position = shape->body->p;
}

- (void)step {
	cpSpaceStep(_space, STEP_INTERVAL);
	
	[CATransaction setDisableActions:YES];
	cpSpaceHashEach(_space->activeShapes, &updateSpace, self); // update shape positions
	[CATransaction setDisableActions:NO];
}

#define NUM_COLORS 12

- (UIColor *)ballColor {
	UIColor *color = nil;
	int res = rand() % NUM_COLORS;
	
	switch (res) {
		case 0:
			color = [UIColor blackColor];
			break;
		case 1:
			color = [UIColor grayColor];
			break;
		case 2:
			color = [UIColor redColor];
			break;
		case 3:
			color = [UIColor greenColor];
			break;
		case 4:
			color = [UIColor blueColor];
			break;
		case 5:
			color = [UIColor cyanColor];
			break;
		case 6:
			color = [UIColor yellowColor];
			break;
		case 7:
			color = [UIColor magentaColor];
			break;
		case 8:
			color = [UIColor orangeColor];
			break;
		case 9:
			color = [UIColor purpleColor];
			break;
		case 10:
			color = [UIColor brownColor];
			break;
		case 11:
			color = [UIColor blackColor];
			break;
		default:
			break;
	}
	
	return color;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)orientation {
	return NO;
}

- (void)accelerometer:(UIAccelerometer *)accelerometer
		didAccelerate:(UIAcceleration *)acceleration {
	
	static float prevX = 0.0f, prevY = 0.0f;
	
	prevX = (float) acceleration.x * FILTER_FACTOR + (1-FILTER_FACTOR) * prevX;
	prevY = (float) acceleration.y * FILTER_FACTOR + (1-FILTER_FACTOR) * prevY;
	
	_space->gravity = cpv(prevX * GRAVITY, -prevY * GRAVITY);
}

- (void)tap:(UITapGestureRecognizer *)gr {
	CGPoint pt = [gr locationInView:self.view];
	[self dropBallAtPoint:pt];
}

- (void)dealloc {
	cpSpaceFree(_space);
	[super dealloc];
}

@end
