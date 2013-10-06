//
//  ViewController.m
//  WaveViewLimitDemo
//
//  Created by Brio on 06/10/2013.
//  Copyright (c) 2013 Brio. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet WaveLimitView *waveLimitView;
@property (weak, nonatomic) IBOutlet UILabel *startLabel;
@property (weak, nonatomic) IBOutlet UILabel *endLabel;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor yellowColor];
    [self setUpWaveLimitView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setUpWaveLimitView
{
    if (!self.waveLimitView)
        return;
    
    self.waveLimitView.masterBGColor = [UIColor yellowColor];
    self.waveLimitView.waveFormColor = [UIColor greenColor];
    
    self.waveLimitView.changeHandler = ^(float startFactor, float endFactor)
    {
        self.startLabel.text = [NSString stringWithFormat:@"Start:%g", startFactor];
        self.endLabel.text = [NSString stringWithFormat:@"End:%g", endFactor];
    };
    
    self.waveLimitView.swipeHandler = ^()
    {
    };
    
    self.waveLimitView.leftWaveLimitImage = [UIImage imageNamed:@"leftlimit"];
    self.waveLimitView.rightWaveLimitImage = [UIImage imageNamed:@"rightlimit"];
    self.waveLimitView.waveformViewImage = [UIImage imageNamed:@"clav"];
}

@end
