#pragma once

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@class UIImageView, UIImage;

@interface GUISlider : UIControl <NSCoding>

@property (nonatomic, retain) UIImageView* sliderLeftView;
@property (nonatomic, retain) UIImageView* sliderRightView;
@property (nonatomic, retain) UIImageView* sliderThumbView;

@property (nonatomic) float minimumValue;
@property (nonatomic) float maximumValue;
@property (nonatomic) float value;
@property (nonatomic) float trackVal;
@property (nonatomic, getter=isContinuous) BOOL continuous;
@property (nonatomic, retain) UIColor* minimumTrackTintColor;
@property (nonatomic, retain) UIColor* maximumTrackTintColor;
@property (nonatomic, retain) UIColor* thumbTintColor;

- (void) setThumbImage:(UIImage*)image forState:(UIControlState)state;
- (void) setMinimumTrackImage:(UIImage*)image forState:(UIControlState)state;
- (void) setMaximumTrackImage:(UIImage*)image forState:(UIControlState)state;
- (CGRect) trackRectForBounds:(CGRect)bounds;
- (void) setMinimumValueImage:(UIImage*)image;
- (void) setMaximumValueImage:(UIImage*)image;
- (UIImage *) currentThumbImage;
- (CGRect) thumbRectForBounds:(CGRect)bounds trackRect:(CGRect)rect value:(float)value;
- (UIImage *) thumbImageForState:(NSUInteger)state;
- (void) tapSelf: (BOOL) hilite;
- (void) panSelf: (CGPoint) deltaPt;
- (UIImageView*) thumbView;
- (UIImageView *) maximumTrackView;
- (UIImageView *) minimumTrackView;
- (float) yOffsetFromSliderValue:(UIView *) toView;

@property (nonatomic, retain) UIImage *thumbImage; // _dot
@property (nonatomic, retain) UIImage *thumbImageHighlighted; // _dotHighlighted
@property (nonatomic, assign) float shadowAlpha;
@property (nonatomic, assign) float shadowRadius;
@property (nonatomic, retain) UIImage *_minimumValueImage; // _sliderLeft
@property (nonatomic, retain) UIImage *_maximumValueImage; // _sliderRight
@property (nonatomic, retain) UIImage *_minimumTrackImage;
@property (nonatomic, retain) UIImage *_maximumTrackImage;


@end
