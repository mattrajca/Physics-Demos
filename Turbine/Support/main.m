//
//  main.m
//  Turbine
//
//  Copyright Matt Rajca 2011. All rights reserved.
//

int main(int argc, char *argv[]) {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	int retVal = UIApplicationMain(argc, argv, nil, @"TurbineAppDelegate");
	[pool release];
	
	return retVal;
}
