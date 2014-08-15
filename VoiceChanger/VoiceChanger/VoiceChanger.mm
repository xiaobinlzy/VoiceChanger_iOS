//
//  VoiceChanger.m
//  VoiceChanger
//
//  Created by DLL on 14-5-6.
//  Copyright (c) 2014年 DLL. All rights reserved.
//

#import "VoiceChanger.h"
#include "SoundTouch.h"

using namespace soundtouch;

@implementation VoiceChanger {
    SoundTouch *_soundTouch;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _soundTouch = new soundtouch::SoundTouch();
        _soundTouch->setSampleRate(8000);//mRecordFormat.mSampleRate
        _soundTouch->setChannels(1);//mRecordFormat.mChannelsPerFrame
        _soundTouch->setPitchSemiTones(0);   // 声音高低
        _soundTouch->setTempo(1);   // 声音拉长
        _soundTouch->setRate(1); // 声音速度
        
        _soundTouch->setSetting(SETTING_SEQUENCE_MS, 40);
        _soundTouch->setSetting(SETTING_SEEKWINDOW_MS, 15);
        _soundTouch->setSetting(SETTING_OVERLAP_MS, 8);
    }
    return self;
}

- (void)setTempo:(CGFloat)tempo
{
    _tempo = tempo;
    _soundTouch->setTempo(tempo);
}

- (void)setPitch:(CGFloat)pitch
{
    _pitch = pitch;
    _soundTouch->setPitchSemiTones((float)pitch);
}

- (void)setRate:(CGFloat)rate
{
    _rate = rate;
    _soundTouch->setRate(rate);
}

- (void)putSamples:(const short *)samples length:(NSUInteger)length
{
    _soundTouch->putSamples(samples, (uint)length);
}



- (NSUInteger)receiveSamples:(short *)buffer length:(NSUInteger)length
{
    return _soundTouch->receiveSamples(buffer, (uint)length);
}

- (void)dealloc
{
    free(_soundTouch);
}

@end
