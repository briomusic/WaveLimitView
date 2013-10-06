//
//  WaveLimitView.h
//  CloudSynth
//
//  Created by Brio on 09/08/2013.
//  Copyright (c) 2013 Brio. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * WaveLimitView is a simple waveform editor. 
 * Start- and Endpoint can be adjusted by moving a marker. 
 * When a marker is moved the (^onLimitsChanged) block is called, returning a new Start- and End-factor. 
 * These are always floats between 0 and 1.
 * If you need to change Start- and End-factor elsewhere in the program, 
 *
 * call [adjustWavelimitsForStartFactor:(float)startFactor andEndFactor:] to update the WavelimitView.
 * @param waveformViewImage the image displayed between the markers
 * @param leftWaveLimitImage the image used for the left marker
 * @param rightWaveLimitImage the image used for the right marker
 *
 * @param masterBGColor WaveLimitView is typically of clear color. setting this color allows the shading to blend into the background.
 * @param waveFormColor sets the background color of the waveform.
 *
 * @param changeHandler completion block that is called whenever a marker was moved. returns floats for start and end point.
 */

#define kLimitWidth 42

typedef void (^onLimitsChanged)(float, float);
typedef void (^onSwipeDown)();

@interface WaveLimitView : UIView

@property (nonatomic, strong) UIImage *waveformViewImage;
@property (nonatomic, strong) UIImage *rightWaveLimitImage;
@property (nonatomic, strong) UIImage *leftWaveLimitImage;

@property (nonatomic, strong) UIColor *masterBGColor;
@property (nonatomic, strong) UIColor *waveFormColor;

@property (nonatomic, strong) onLimitsChanged changeHandler;
@property (nonatomic, strong) onSwipeDown swipeHandler;

-(void)adjustWavelimitsForStartFactor:(float)startFactor andEndFactor:(float)endFactor;

@end
