//
//  RecordButton.m
//  SafeYou
//
//  Created by Garnik Simonyan on 9/15/19.
//  Copyright © 2019 Garnik Simonyan. All rights reserved.
//

#import "RecordButton.h"
#import <AFNetworking.h>

#define TIMER_TIME_INTERVAL 3
#define TIMER_TITLE_TIME_INTERVAL 1

@interface RecordButton () <CAAnimationDelegate>

@property (nonatomic) RecordButtonState recordState;

@property (nonatomic) CAShapeLayer *progressLayer;

@property (nonatomic) NSTimer *actionTimer;
@property (nonatomic) NSTimer *titleTimer;

@property (nonatomic) NSUInteger timeRemaining;

@property (nonatomic) BOOL canStop;

@end

@implementation RecordButton

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        self.timeRemaining = (NSUInteger)TIMER_TIME_INTERVAL;
    }
    
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self createProgressBar];
    self.cornerRadius = self.frame.size.width/2;
    [self reset];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.progressLayer.path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2) radius:self.bounds.size.height/2 startAngle:DEGREES_TO_RADIANS(-90) endAngle:DEGREES_TO_RADIANS(270) clockwise:YES].CGPath;
    self.cornerRadius = self.frame.size.width/2;
}

- (void)reset
{
    self.recordState = RecordButtonStateNormal;
    self.canStop = NO;
    [self.titleTimer invalidate];
    self.timeRemaining = TIMER_TIME_INTERVAL;
}

- (void)updateLocalizations
{
    [self setTitle:LOC(@"push_hold_text_key") forState:UIControlStateNormal];
}

#pragma mark - Actions

- (void)touchCancelled:(RecordButton *)sender
{
    self.canStop = YES;
}

- (void)touchDownAction:(RecordButton *)sender
{
    if (self.recordState == RecordButtonStateRecording) {
        return;
    }
    self.recordState = RecordButtonStateWaiting;
    self.progressLayer.hidden = NO;
    self.titleTimer = [NSTimer scheduledTimerWithTimeInterval:TIMER_TITLE_TIME_INTERVAL target:self selector:@selector(updateTitle) userInfo:nil repeats:YES];
    self.actionTimer = [NSTimer scheduledTimerWithTimeInterval:TIMER_TIME_INTERVAL target:self selector:@selector(startRecording) userInfo:nil repeats:NO];
    [self createProgressAnimation];
}

- (void)touchUpAction:(RecordButton *)sender
{
    if (self.recordState == RecordButtonStateWaiting) {
        [self.progressLayer removeAnimationForKey:@"strokeEnd"];
        [self.titleTimer invalidate];
        self.titleTimer = nil;
        self.timeRemaining = TIMER_TIME_INTERVAL;
        [self.actionTimer invalidate];
        self.actionTimer = nil;
        [self reset];
    } else if (self.recordState == RecordButtonStateRecording) {
        if (self.canStop) {
            [self stopRecording];
        } else {
            self.canStop = YES;
            [self.titleTimer invalidate];
            self.titleTimer = nil;
            self.timeRemaining = TIMER_TIME_INTERVAL;
        }
    } else {
    }
}

- (void)recordButtonDidStartPressed:(RecordButton *)sender
{
    [self touchDownAction:nil];
}

- (void)recordButtonDidStopPressed:(RecordButton *)sender
{
    [self touchUpAction:nil];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSLog(@"Touches Began");
    [self touchDownAction:nil];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSLog(@"Touches Ended");
    [self touchUpAction:nil];
}

#pragma mark - Main Action

- (void)updateTitle
{
    if (self.recordState == RecordButtonStateWaiting) {
        if (self.timeRemaining >= 0) {
            self.timeRemaining -=1;
            NSString *title = [NSString stringWithFormat:@"%@", @(self.timeRemaining)];
            [self setTitle:title forState:UIControlStateNormal];
        }
    }
    
}


#pragma mark - Delegate Functionality

- (void)stopRecording
{
    [self reset];
    if ([self.delegate respondsToSelector:@selector(recordButtonDidStopRecording:)]) {
        [self.delegate recordButtonDidStopRecording:self];
    }
}

- (void)startRecording
{
    self.recordState = RecordButtonStateRecording;
    if ([self.delegate respondsToSelector:@selector(recordButtonDidStartRecording:)]) {
        [self.delegate recordButtonDidStartRecording:self];
    }
}

#pragma mark - Countdown animation

- (void)createProgressAnimation
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.fromValue = @(self.progressLayer.strokeEnd);
    animation.toValue = @(0.0);
    animation.duration = TIMER_TIME_INTERVAL;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animation.delegate = self;
    animation.removedOnCompletion = NO;
    animation.additive = NO;
    animation.fillMode = kCAFillModeForwards;
    [self.progressLayer addAnimation:animation forKey:@"strokeEnd"];
}

- (void)createProgressBar
{
    self.progressLayer = [CAShapeLayer layer];
    self.progressLayer.path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2) radius:self.bounds.size.height/2 startAngle:DEGREES_TO_RADIANS(270) endAngle:DEGREES_TO_RADIANS(-90) clockwise:NO].CGPath;
    self.progressLayer.strokeColor = self.backgroundColor.CGColor;//[UIColor redColor].CGColor;
    self.progressLayer.backgroundColor = [UIColor yellowColor].CGColor;//self.backgroundColor.CGColor;
    self.progressLayer.fillColor = self.backgroundColor.CGColor;
    self.progressLayer.lineWidth = 5.0; // make configurable
    self.progressLayer.strokeStart = 0.0;
    [self.layer insertSublayer:self.progressLayer above:[[self.layer sublayers] objectAtIndex:0]];
    self.progressLayer.hidden = YES;
}

#pragma mark - Normal state
- (void)configureNormalState
{
    self.backgroundColor = [UIColor mainTintColor1];
    self.progressLayer.hidden = YES;
    self.progressLayer.fillColor  = [UIColor greenColor].CGColor;
    [self setTitleColor:[UIColor navyBlueColor] forState:UIControlStateNormal];
    [self setTitle:LOC(@"push_hold_text_key") forState:UIControlStateNormal];
    UIFont *font = [UIFont extraBoldFontOfSize:39];
    [self.titleLabel setFont:[[[UIFontMetrics alloc] initForTextStyle:UIFontTextStyleBody] scaledFontForFont:font]];
    self.titleLabel.adjustsFontForContentSizeCategory = YES;
    self.layer.masksToBounds = YES;
    
    self.contentEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 5);
    
    self.titleLabel.adjustsFontSizeToFitWidth = YES;
    self.titleLabel.minimumScaleFactor = 0.5;
    self.titleLabel.numberOfLines = 2;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
}

#pragma mark - Waiting state

- (void)configureWaitingState
{
    self.backgroundColor = [UIColor lightGrayColor];
    self.progressLayer.fillColor = [UIColor lightGrayColor].CGColor;
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    NSString *title = [NSString stringWithFormat:@"%@", @(self.timeRemaining)];
    [self setTitle:title forState:UIControlStateNormal];
    UIFont *font = [UIFont extraBoldFontOfSize:60];
    [self.titleLabel setFont:[[[UIFontMetrics alloc] initForTextStyle:UIFontTextStyleBody] scaledFontForFont:font]];
    self.titleLabel.adjustsFontForContentSizeCategory = YES;
    self.titleLabel.numberOfLines = 1;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
}

#pragma mark - Recording State

- (void)configureRecordingState
{
    self.backgroundColor = [UIColor redColor];
    self.progressLayer.fillColor = [UIColor redColor].CGColor;
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self setTitle:LOC(@"stop_recording_text_key") forState:UIControlStateNormal];
    UIFont *font = [UIFont regularFontOfSize:39];
    [self.titleLabel setFont:[[[UIFontMetrics alloc] initForTextStyle:UIFontTextStyleBody] scaledFontForFont:font]];
    self.titleLabel.adjustsFontForContentSizeCategory = YES;
    self.titleLabel.minimumScaleFactor = 0.5;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    if ([self.currentTitle rangeOfString:@"\n"].location == NSNotFound) {
      self.titleLabel.numberOfLines = 1;
    } else {
      self.titleLabel.numberOfLines = 2;
    }
}

#pragma mark - Setter

- (void)setRecordState:(RecordButtonState)recordState
{
    _recordState = recordState;
    switch (_recordState) {
        case RecordButtonStateWaiting:
            [self configureWaitingState];
            
            break;
        case RecordButtonStateRecording:
            [self configureRecordingState];
            break;
            
        default:
            [self configureNormalState];
            break;
    }
}

@end
