//
//  MicMonitorAU.m
//  Turbine
//
//  Copyright Matt Rajca 2011. All rights reserved.
//

#import "MicMonitorAU.h"

@implementation MicMonitorAU

#define OUTPUT_BUS 0
#define INPUT_BUS 1

#define FILTER 0.05f

static OSStatus recordingCallback(void *inRefCon,
								  AudioUnitRenderActionFlags *ioActionFlags,
								  const AudioTimeStamp *inTimeStamp,
								  UInt32 inBusNumber,
								  UInt32 inNumberFrames,
								  AudioBufferList *ioData);

- (id)init {
	self = [super init];
	if (self) {
		self.threshold = 0.1f;
		
		OSStatus status = noErr;
		
		AudioComponentDescription desc;
		desc.componentType = kAudioUnitType_Output;
		desc.componentSubType = kAudioUnitSubType_RemoteIO;
		desc.componentFlags = desc.componentFlagsMask = 0;
		desc.componentManufacturer = kAudioUnitManufacturer_Apple;
		
		AudioComponent component = AudioComponentFindNext(NULL, &desc);
		AudioComponentInstanceNew(component, &_au);
		
		UInt32 state = 1;
		AudioUnitSetProperty(_au, kAudioOutputUnitProperty_EnableIO, kAudioUnitScope_Input,
							 INPUT_BUS, &state, sizeof(state));
		
		state = 0;
		AudioUnitSetProperty(_au, kAudioOutputUnitProperty_EnableIO, kAudioUnitScope_Output,
							 OUTPUT_BUS, &state, sizeof(state));
		
		state = 1;
		AudioUnitSetProperty(_au, kAudioUnitProperty_ShouldAllocateBuffer, kAudioUnitScope_Global,
							 INPUT_BUS, &state, sizeof(state));
		
		AudioStreamBasicDescription format;
		format.mBitsPerChannel = 16;
		format.mBytesPerFrame = format.mBytesPerPacket = 2;
		format.mChannelsPerFrame = format.mFramesPerPacket = 1;
		format.mSampleRate = 44100.0f;
		format.mFormatFlags = kAudioFormatFlagIsPacked | kAudioFormatFlagIsSignedInteger;
		format.mFormatID = kAudioFormatLinearPCM;
		
		status = AudioUnitSetProperty(_au, kAudioUnitProperty_StreamFormat, kAudioUnitScope_Output,
									  INPUT_BUS, &format, sizeof(AudioStreamBasicDescription));
		
		AURenderCallbackStruct callback;
		callback.inputProc = &recordingCallback;
		callback.inputProcRefCon = self;
		
		status = AudioUnitSetProperty(_au, kAudioOutputUnitProperty_SetInputCallback, kAudioUnitScope_Global,
									  OUTPUT_BUS, &callback, sizeof(callback));
		
		status = AudioUnitInitialize(_au);
		
		if (status != noErr) {
			NSLog(@"Could not initialize the output audio unit (%ld)", status);
		}
	}
	return self;
}

static OSStatus recordingCallback(void *inRefCon, 
								  AudioUnitRenderActionFlags *ioActionFlags, 
								  const AudioTimeStamp *inTimeStamp, 
								  UInt32 inBusNumber, 
								  UInt32 inNumberFrames, 
								  AudioBufferList *ioData) {
	
	MicMonitorAU *self = (MicMonitorAU *) inRefCon;
	
	AudioBuffer buffer;
	buffer.mNumberChannels = 1;
	buffer.mDataByteSize = inNumberFrames * sizeof(int16_t);
	
	int16_t *samples = (int16_t *) malloc(buffer.mDataByteSize);
	buffer.mData = samples;
	
	AudioBufferList *list = (AudioBufferList *) malloc(sizeof(AudioBufferList));
	list->mNumberBuffers = 1;
	list->mBuffers[0] = buffer;
	
	AudioUnitRender(self->_au, ioActionFlags, inTimeStamp, inBusNumber, inNumberFrames, list);
	
	float sum = 0.0;
	
	for (uint64_t n = 0; n < inNumberFrames; n++) {
		int16_t amplitude = samples[n];
		
		float normalized = amplitude / 32768.0f;
		sum += (normalized * normalized);
	}
	
	float rms = sqrtf(sum  / inNumberFrames);
	self->lastRMS = self->lastRMS * (1.0f - FILTER) + rms * FILTER;
	
	[self processRMS];
	
	return noErr;
}

- (void)dealloc {
	AudioUnitUninitialize(_au);
	[super dealloc];
}

- (void)start {
	OSStatus status = AudioOutputUnitStart(_au);
	
	if (status != noErr) {
		NSLog(@"Could not start output audio unit (%ld)", status);
	}
}

- (void)stop {
	OSStatus status = AudioOutputUnitStop(_au);
	
	if (status != noErr) {
		NSLog(@"Could not stop output audio unit (%ld)", status);
	}
}

@end
