//
//  VoiceChanger.h
//  VoiceChanger
//
//  Created by DLL on 14-5-6.
//  Copyright (c) 2014年 DLL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RecorderManager.h"
#import "PlayerManager.h"

@interface VoiceChanger : NSObject

@property (nonatomic, assign) CGFloat pitch;
@property (nonatomic, assign) CGFloat rate;
@property (nonatomic, assign) CGFloat tempo;

- (void)putSamples:(const short *)samples length:(NSUInteger)length;

- (NSUInteger)receiveSamples:(short *)buffer length:(NSUInteger)length;

@end
