//
//  DemoViewController.m
//  VoiceChangerDemo
//
//  Created by DLL on 14-5-6.
//  Copyright (c) 2014年 DLL. All rights reserved.
//

#import "DemoViewController.h"

@interface DemoViewController () <RecordingDelegate, PlayingDelegate>


@property (nonatomic, weak) IBOutlet UIProgressView *levelMeter;
@property (nonatomic, weak) IBOutlet UILabel *consoleLabel;
@property (nonatomic, weak) IBOutlet UIButton *recordButton;
@property (nonatomic, weak) IBOutlet UIButton *playButton;
@property (nonatomic, weak) IBOutlet UISlider *sliderPitch;
@property (nonatomic, weak) IBOutlet UISlider *sliderRate;
@property (nonatomic, weak) IBOutlet UISlider *sliderTempo;
@property (nonatomic, weak) IBOutlet UILabel *labelPitch;
@property (nonatomic, weak) IBOutlet UILabel *labelRate;
@property (nonatomic, weak) IBOutlet UILabel *labelTempo;

@property (nonatomic, assign) BOOL isRecording;
@property (nonatomic, assign) BOOL isPlaying;

@property (nonatomic, copy) NSString *filename;

- (IBAction)recordButtonClicked:(id)sender;
- (IBAction)playButtonClicked:(id)sender;

@end

@implementation DemoViewController {
    VoiceChanger *_voiceChanger;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _voiceChanger = [[VoiceChanger alloc] init];
	
    self.title = @"Speex";
    
    self.levelMeter.progress = 0;
    
    self.consoleLabel.numberOfLines = 0;
    self.consoleLabel.text = @"A demo for recording and playing speex audio.";
    
    [self.recordButton addTarget:self action:@selector(recordButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.playButton addTarget:self action:@selector(playButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}



- (IBAction)recordButtonClicked:(id)sender {
    if (self.isPlaying) {
        return;
    }
    if ( ! self.isRecording) {
        self.isRecording = YES;
        self.consoleLabel.text = @"正在录音";
        [RecorderManager sharedManager].delegate = self;
        [[RecorderManager sharedManager] startRecordingWithFilePath:[NSString stringWithString:[RecorderManager defaultFileName]] andVoiceChanger:_voiceChanger];
    }
    else {
        self.isRecording = NO;
        [[RecorderManager sharedManager] stopRecording];
    }
    [self.recordButton setTitle:(self.isRecording ? @"停止录音" : @"录音") forState:UIControlStateNormal];
}

- (IBAction)playButtonClicked:(id)sender {
    if (self.isRecording) {
        return;
    }
    if ( ! self.isPlaying) {
        [PlayerManager sharedManager].delegate = nil;
        
        self.isPlaying = YES;
        self.consoleLabel.text = [NSString stringWithFormat:@"正在播放: %@", [self.filename substringFromIndex:[self.filename rangeOfString:@"Documents"].location]];
        [[PlayerManager sharedManager] playAudioWithFileName:self.filename delegate:self];
    }
    else {
        self.isPlaying = NO;
        [[PlayerManager sharedManager] stopPlaying];
    }
    [self.playButton setTitle:(self.isPlaying ? @"停止播放" : @"播放") forState:UIControlStateNormal];
}

#pragma mark - Recording & Playing Delegate

- (void)recordingFinishedWithFileName:(NSString *)filePath time:(NSTimeInterval)interval {
    self.isRecording = NO;
    self.levelMeter.progress = 0;
    self.filename = filePath;
    [self.consoleLabel performSelectorOnMainThread:@selector(setText:) withObject:[NSString stringWithFormat:@"录音完成: %@", [self.filename substringFromIndex:[self.filename rangeOfString:@"Documents"].location]] waitUntilDone:NO];
    NSLog(@"录音完成");
}

- (void)recordingTimeout {
    self.isRecording = NO;
    self.consoleLabel.text = @"录音超时";
}

- (void)recordingStopped {
    self.isRecording = NO;
}

- (void)recordingFailed:(NSString *)failureInfoString {
    self.isRecording = NO;
    self.consoleLabel.text = @"录音失败";
}

- (void)levelMeterChanged:(float)levelMeter {
    self.levelMeter.progress = levelMeter;
}

- (void)playingStoped {
    self.isPlaying = NO;
    self.consoleLabel.text = [NSString stringWithFormat:@"播放完成: %@", [self.filename substringFromIndex:[self.filename rangeOfString:@"Documents"].location]];
    [self.playButton setTitle:@"播放" forState:UIControlStateNormal];
}

- (IBAction)pitchValueChanged:(id)sender {
    UISlider *slider = (UISlider *)sender;
    _labelPitch.text = [NSString stringWithFormat:@"%f", slider.value];
    _voiceChanger.pitch = slider.value;
}

- (IBAction)rateValueChanged:(id)sender {
    UISlider *slider = (UISlider *)sender;
    _labelRate.text = [NSString stringWithFormat:@"%f", slider.value];
    _voiceChanger.rate = slider.value;
}

- (IBAction)tempoValueChanged:(id)sender {
    UISlider *slider = (UISlider *)sender;
    _labelTempo.text = [NSString stringWithFormat:@"%f", slider.value];
    _voiceChanger.tempo = slider.value;
}

- (IBAction)reset:(id)sender
{
    _sliderPitch.value = 0;
    _sliderRate.value = 1;
    _sliderTempo.value = 1;
    _labelPitch.text = @"0";
    _labelRate.text = @"1";
    _labelTempo.text = @"1";
}

@end
