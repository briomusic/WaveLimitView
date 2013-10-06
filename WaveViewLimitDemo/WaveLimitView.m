//
//  WaveLimitView.m
//  CloudSynth
//
//  Created by Brio on 09/08/2013.
//  Copyright (c) 2013 Brio. All rights reserved.
//

#import "WaveLimitView.h"

typedef enum { TouchTypeOutside = 0,
    TouchTypeLeftLimit,
    TouchTypeRightLimit,
    TouchTypeWaveForm} TouchType;

@interface WaveLimitView ()

@property (nonatomic, strong) UIImageView *waveformView;
@property (nonatomic, strong) UIImageView *rightWaveLimit;
@property (nonatomic, strong) UIImageView *leftWaveLimit;
@property (nonatomic, strong) UIImageView *rightShading;
@property (nonatomic, strong) UIImageView *leftShading;
@property (nonatomic, strong) UISwipeGestureRecognizer *downRecognizer;

@end

@implementation WaveLimitView
{
    UIPanGestureRecognizer *panRecognizer;
    
    TouchType _waveTouchType;
    float _storedTranslation;
    float _storedLeftWaveLimit;
    float _storedRightWaveLimit;
}

//@synthesize waveformView, rightWaveLimit, leftWaveLimit, rightShading, leftShading;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
        [self basicSetup];
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
        [self basicSetup];
    return self;
}

-(void)basicSetup
{
    panRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePan:)];
    [self addGestureRecognizer:panRecognizer];
    
    self.leftWaveLimit = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kLimitWidth, self.bounds.size.height)];
    self.leftWaveLimit.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
    
    self.leftShading = [[UIImageView alloc]initWithFrame:self.leftWaveLimit.frame];
    self.leftShading.backgroundColor = self.superview.backgroundColor;
    self.leftShading.alpha = 0.7f;
    self.leftShading.opaque = NO;
    self.leftShading.image = [UIImage imageNamed:@"not found"];
    self.leftShading.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;

    self.rightWaveLimit = [[UIImageView alloc]initWithFrame:CGRectMake(self.bounds.size.width - kLimitWidth, 0, kLimitWidth, self.bounds.size.height)];
    self.rightWaveLimit.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;

    self.rightShading = [[UIImageView alloc]initWithFrame:self.rightWaveLimit.frame];
    self.rightShading.backgroundColor = self.superview.backgroundColor;
    self.rightShading.alpha = 0.7f;
    self.rightShading.opaque = NO;
    self.rightShading.image = [UIImage imageNamed:@"not found"];
    self.rightShading.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;

    self.waveformView = [[UIImageView alloc]initWithFrame:CGRectMake(kLimitWidth, 0, self.bounds.size.width - 2*kLimitWidth, self.bounds.size.height)];
    self.waveformView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    
    [self addSubview:self.waveformView];
    [self addSubview:self.leftShading];
    [self addSubview:self.rightShading];
    [self addSubview:self.leftWaveLimit];
    [self addSubview:self.rightWaveLimit];

    self.downRecognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self
                                                                   action:@selector(swipedDown:)];
    self.downRecognizer.direction = UISwipeGestureRecognizerDirectionDown;
    [self addGestureRecognizer:self.downRecognizer];
}

#pragma mark - accessors

-(void)setWaveformViewImage:(UIImage *)waveformViewImage
{
    _waveformViewImage = waveformViewImage;
    self.waveformView.image = _waveformViewImage;
}

-(void)setLeftWaveLimitImage:(UIImage *)leftWaveLimitImage
{
    _leftWaveLimitImage = leftWaveLimitImage;
    self.leftWaveLimit.image = _leftWaveLimitImage;
}

-(void)setRightWaveLimitImage:(UIImage *)rightWaveLimitImage
{
    _rightWaveLimitImage = rightWaveLimitImage;
    self.rightWaveLimit.image = _rightWaveLimitImage;
}

-(void)setMasterBGColor:(UIColor *)masterBGColor
{
    _masterBGColor = masterBGColor;
    self.rightShading.backgroundColor = _masterBGColor;
    self.leftShading.backgroundColor = _masterBGColor;
}

-(void)setWaveFormColor:(UIColor *)waveFormColor
{
    _waveFormColor = waveFormColor;
    self.waveformView.backgroundColor = _waveFormColor;
}

#pragma mark - gesture delegate methods

- (void)swipedDown:(UIGestureRecognizer*) gestureRecognizer
{
    if (self.swipeHandler)
        self.swipeHandler(self, YES);
}

- (void)handlePan:(UIPanGestureRecognizer *)recognizer
{
    CGPoint translation = [recognizer locationInView:self];
    
    // WHERE DID WE TOUCH?
    
    if(recognizer.state == UIGestureRecognizerStateBegan)
    {
        if (translation.x > self.leftWaveLimit.frame.origin.x && translation.x < self.leftWaveLimit.frame.origin.x+self.leftWaveLimit.frame.size.width)
            _waveTouchType = TouchTypeLeftLimit;
        else if (translation.x > self.rightWaveLimit.frame.origin.x && translation.x < self.rightWaveLimit.frame.origin.x+self.rightWaveLimit.frame.size.width)
            _waveTouchType = TouchTypeRightLimit;
        else if (translation.x > self.leftWaveLimit.frame.origin.x+self.leftWaveLimit.frame.size.width && translation.x < self.rightWaveLimit.frame.origin.x)
            _waveTouchType = TouchTypeWaveForm;
        else
            _waveTouchType = TouchTypeOutside;
        
        _storedTranslation = translation.x;
        _storedLeftWaveLimit = self.leftWaveLimit.frame.origin.x;
        _storedRightWaveLimit = self.rightWaveLimit.frame.origin.x;
    }
    
    float actualMovement = translation.x - _storedTranslation;
    
    // TOUCH ACTIONS
    
    if (_waveTouchType == 1 && _storedLeftWaveLimit+actualMovement > 0 && _storedLeftWaveLimit + actualMovement + self.leftWaveLimit.frame.size.width < self.rightWaveLimit.frame.origin.x )
        self.leftWaveLimit.frame = CGRectMake(_storedLeftWaveLimit + actualMovement,
                                              self.leftWaveLimit.frame.origin.y,
                                              self.leftWaveLimit.frame.size.width,
                                              self.leftWaveLimit.frame.size.height);
    
    if (_waveTouchType == 2 && _storedRightWaveLimit + actualMovement < self.rightWaveLimit.superview.frame.size.width - self.rightWaveLimit.frame.size.width && _storedRightWaveLimit + actualMovement > self.leftWaveLimit.frame.origin.x + self.leftWaveLimit.frame.size.width)
        self.rightWaveLimit.frame = CGRectMake(_storedRightWaveLimit + actualMovement,
                                               self.rightWaveLimit.frame.origin.y,
                                               self.rightWaveLimit.frame.size.width,
                                               self.rightWaveLimit.frame.size.height);
    
    if (_waveTouchType == 3 && _storedLeftWaveLimit+actualMovement > 0 && _storedRightWaveLimit+actualMovement+self.rightWaveLimit.frame.size.width < self.rightWaveLimit.superview.frame.size.width)
    {
        self.leftWaveLimit.frame = CGRectMake(_storedLeftWaveLimit + actualMovement,
                                              self.leftWaveLimit.frame.origin.y,
                                              self.leftWaveLimit.frame.size.width,
                                              self.leftWaveLimit.frame.size.height);
        self.rightWaveLimit.frame = CGRectMake(_storedRightWaveLimit + actualMovement,
                                               self.rightWaveLimit.frame.origin.y,
                                               self.rightWaveLimit.frame.size.width,
                                               self.rightWaveLimit.frame.size.height);
    }
    [self adjustFactorAccordingToWaveLimit];
}

-(void)adjustFactorAccordingToWaveLimit
{
    self.changeHandler(self.leftWaveLimit.frame.origin.x / (self.bounds.size.width - kLimitWidth*2),
                       (self.rightWaveLimit.frame.origin.x - kLimitWidth) / (self.bounds.size.width - kLimitWidth*2));
    
    [self adjustShading];
}

-(void)adjustWavelimitsForStartFactor:(float)startFactor andEndFactor:(float)endFactor
{
    self.leftWaveLimit.frame = CGRectMake(self.waveformView.bounds.size.width * startFactor, 0,
                                     kLimitWidth, self.leftWaveLimit.frame.size.height);
    self.rightWaveLimit.frame = CGRectMake(self.waveformView.bounds.size.width * endFactor + kLimitWidth, 0,
                                      kLimitWidth, self.leftWaveLimit.frame.size.height);

    [self adjustShading];
}

-(void)adjustShading
{
    self.leftShading.frame = CGRectMake(self.leftShading.frame.origin.x,
                                        self.leftShading.frame.origin.y,
                                        self.leftWaveLimit.frame.origin.x+self.leftWaveLimit.frame.size.width,
                                        self.leftShading.frame.size.height);
    self.rightShading.frame = CGRectMake(self.rightWaveLimit.frame.origin.x,
                                         self.rightShading.frame.origin.y,
                                         self.frame.size.width - self.rightWaveLimit.frame.origin.x,
                                         self.rightShading.frame.size.height);
}

@end
