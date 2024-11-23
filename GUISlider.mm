#import "GUISlider.h"
#import "GUI.h"

//∫#include "UIGestureRecognizerInternal.h"
@class MyVolSlider;

@implementation GUISlider
{
    float _val;
    float _min;
    float _max;
    CALayer *thumbHighlightOverlayLayer;
}
@synthesize shadowAlpha, shadowRadius;

- (instancetype)initWithCoder:(NSCoder*)coder {
    self = [super initWithCoder:coder];

    id valueStr = [coder decodeObjectForKey:@"UIValue"];

    _val = [valueStr floatValue];
    _max = 1.0f;
    _min = 0.0f;
    
    if ([coder containsValueForKey:@"UIMaxValue"]) {
        _max = [[coder decodeObjectForKey:@"UIMaxValue"] floatValue];
    }
    if ([coder containsValueForKey:@"UIMinValue"]) {
        _min = [[coder decodeObjectForKey:@"UIMinValue"] floatValue];
    }

    [self initInternal];

    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];

    _val = 0.0f;
    _max = 1.0f;
    _min = 0.0f;
    
    [self initInternal];

    return self;
}


- (void) sizeViews:(BOOL) animated
{
    CGRect bounds, thumbSize;
    bounds = [self bounds];
    thumbSize = [self.sliderThumbView bounds];

    if (animated) {
        [UIView beginAnimations:@"MoveView" context:nil];
        [UIView setAnimationDuration:0.25f];
        [UIView setAnimationDelegate:nil];
    }
  
    CGRect newFrame = CGRectMake(0, bounds.size.height / 2 - self._minimumTrackImage.size.height / 2, bounds.size.width, self._minimumTrackImage.size.height);
    [self->_sliderLeftView setFrame:newFrame];

    float amt;

    if (self->_max > 0.0f) {
        amt = (self->_val - self->_min) / self->_max;
    } else {
        amt = 0.0f;
    }

    newFrame.size.width = bounds.size.width * amt;
    if (newFrame.size.width > bounds.size.width) {
        newFrame.size.width = bounds.size.width;
    }
    if (newFrame.size.width < 8 || (newFrame.size.width != newFrame.size.width)) {
        newFrame.size.width = 8;
    }

    [self->_sliderRightView setFrame:newFrame];

    newFrame = thumbSize;
    thumbSize.origin.x = bounds.size.width * amt - thumbSize.size.width / 2;
    thumbSize.origin.y = bounds.size.height / 2 - thumbSize.size.height / 2;

    [self->_sliderThumbView setFrame:thumbSize];

    if (animated) {
        [UIView commitAnimations];
    }
}

- (float) getCap:(UIImage *) image
{
   // LOG("height: %.3f", image.size.height / 2);
    return image.size.height / 2 - 2;
}

- (UIImageView*) thumbView
{
    return _sliderThumbView;
}

-(void) initInternal
{
    shadowRadius = 8;
    shadowAlpha = 0.8;
    [self setContinuous:YES];
    [self setUserInteractionEnabled:YES];
    UIImage *trackImage = [UIImage imageNamed:@"slider-track@2x.png"];
    self._minimumTrackImage = [trackImage stretchableImageWithLeftCapWidth:[self getCap:trackImage] topCapHeight:0];
    self._maximumTrackImage = [[UIImage imageNamed:@"slider-track-fill@2x.png"] stretchableImageWithLeftCapWidth:[self getCap:trackImage] topCapHeight:0];
    self.thumbImage = [UIImage imageNamed:@"sliderknob@2x.png"];
    self.thumbImageHighlighted = [UIImage imageNamed:@"sliderknob_sel@2x.png"];

    float dY = self.bounds.size.height / 2 - self._minimumTrackImage.size.height / 2;
    self->_sliderLeftView = [[UIImageView alloc] initWithFrame:CGRectMake(0,dY,self._minimumTrackImage.size.width, self._minimumTrackImage.size.height)];
    [self->_sliderLeftView setImage:(id) self._minimumTrackImage];

    self->_sliderRightView = [[UIImageView alloc] initWithFrame:CGRectMake(0,dY,self._maximumTrackImage.size.width, self._maximumTrackImage.size.height)];
    [self->_sliderRightView setImage:(id) self._maximumTrackImage];

    dY = self.bounds.size.height / 2 - self.thumbImage.size.height / 2;
     self->_sliderThumbView = [[UIImageView alloc] initWithFrame:CGRectMake(0,dY,self.thumbImage.size.width, self.thumbImage.size.height)];
    [self->_sliderThumbView setContentMode:UIViewContentModeCenter];
    [self->_sliderThumbView setImage:(id)self.thumbImage];
    [self->_sliderThumbView setHighlightedImage:(id)self.thumbImageHighlighted];
    [self->_sliderThumbView setUserInteractionEnabled:YES];

    [self addSubview:(id)self->_sliderLeftView];
    [self addSubview:(id)self->_sliderRightView];
    [self addSubview:(id)self->_sliderThumbView];

    [self sizeViews:NO];
}

- (UIImageView *) maximumTrackView {
    return _sliderRightView;
}
- (UIImageView *) minimumTrackView {
    return _sliderLeftView;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self didTap:YES];
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
    UITouch *touch = [touches anyObject];
    CGPoint tp2 = [touch previousLocationInView:self];
    CGPoint tp1 = [touch locationInView:self];

    [self didPan: CGPointMake(tp1.x-tp2.x, tp1.y-tp2.y)];
}
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    [self didTap:NO];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    [self didTap:NO];
}

- (CGRect)minimumValueImageRectForBounds:(CGRect)bounds{
    CGFloat W = self._minimumTrackImage.size.width;
    CGFloat H = self._minimumTrackImage.size.height;
    CGFloat X = 0;
    CGFloat Y = (bounds.size.height - H) / 2;
 
    return CGRectMake(X, Y, W, H);
}

- (CGRect)maximumValueImageRectForBounds:(CGRect)bounds{
    CGFloat W = self._maximumTrackImage.size.width;
    CGFloat H = self._maximumTrackImage.size.height;
    CGFloat X = bounds.size.width - W;
    CGFloat Y = (bounds.size.height - H) / 2;
    return CGRectMake(X, Y, W, H);
}

- (CGRect)trackRectForBounds:(CGRect)bounds {
    CGRect minimumValueImageRect = [self minimumValueImageRectForBounds:bounds];
    CGRect maximumValueImageRect = [self maximumValueImageRectForBounds:bounds];
    CGFloat margin = [self getCap:self.thumbImage];
    CGFloat Y = bounds.size.height - minimumValueImageRect.size.height / 2;
    CGFloat X = CGRectGetMaxX(minimumValueImageRect) + margin;
    CGFloat W = CGRectGetMinX(maximumValueImageRect) - X - margin;
    return CGRectMake(X, Y, W, minimumValueImageRect.size.height);
}

- (CGRect)thumbRectForBounds:(CGRect)bounds trackRect:(CGRect)trackRect value:(float)value {
    
    float W = self.thumbImage.size.width;
    float H = self.thumbImage.size.height;
    
    CGFloat margin = [self getCap:self.thumbImage];
    CGFloat maxWidth = CGRectGetWidth(trackRect) + 2 * margin;
    CGFloat offset = (maxWidth - W)/(self.maximumValue - self.minimumValue);
    
    CGFloat Y = bounds.size.height / 2 - W / 2;
    CGFloat X = CGRectGetMinX(trackRect) - margin + offset * (value - self.minimumValue);
    return CGRectMake(X, Y, W, H);
}


- (float)value {
    return _val;
}

- (void)setMinimumValue:(float)value {
    _min = value;
    [self sizeViews:NO];
}

- (float)minimumValue {
    return _min;
}

- (void)setMaximumValue:(float)value {
    _max = value;
    [self sizeViews:NO];
}

- (float)maximumValue {
    return _max;
}

- (void)setValue:(float)value {
    [self setValue:value animated:FALSE];
}

- (void)setValue:(float)value animated:(BOOL)animated {
    if (value < _min) {
        value = _min;
    }
    if (value > _max) {
        value = _max;
    }
    _val = value;
    [self sizeViews: animated];

}

- (void)setThumbImage:(UIImage*)image forState:(NSUInteger)state
{
    if (state == 0) {
        self.thumbImage = image;
        [_sliderThumbView setImage:image];
       // [_sliderThumbView setHighlightedImage:nil];
        [self sizeViews:NO];
    } else if (state == 1) {
        self.thumbImageHighlighted = image;
        [_sliderThumbView setHighlightedImage:image];
    }
}

- (UIImage *) thumbImageForState:(NSUInteger)state {
    if ([self class] == [MyVolSlider class])
    if (state == 1)
        return self.thumbImageHighlighted;
    else return self.thumbImage;
    return nil;
}

- (void)setMinimumTrackImage:(UIImage*)image forState:(NSUInteger)state {
    [_sliderLeftView setImage:image];
    self._minimumTrackImage = [image stretchableImageWithLeftCapWidth:[self getCap:image] topCapHeight:0];
    [self setNeedsLayout];
}

- (void)setMaximumTrackImage:(UIImage*)image forState:(NSUInteger)state {
    [_sliderRightView setImage:image];
    self._maximumTrackImage = [image stretchableImageWithLeftCapWidth:[self getCap:image] topCapHeight:0];
    [self setNeedsLayout];
}

- (void)setMinimumValueImage:(UIImage*)image {
    [_sliderLeftView setImage:image];
    self._minimumValueImage = [image stretchableImageWithLeftCapWidth:[self getCap:image] topCapHeight:0];
    [self setNeedsLayout];
}

- (void)setMaximumValueImage:(UIImage*)image {
    [_sliderRightView setImage:image];
    self._maximumValueImage = [image stretchableImageWithLeftCapWidth:[self getCap:image] topCapHeight:0];
    [self setNeedsLayout];
}

- (UIImage*) currentThumbImage {
    return self.thumbImage;
}

- (float) yOffsetFromSliderValue:(UIView *) toView
{
    CGPoint c = [self convertPoint: self.frame.origin toView: toView];
    float sliderRange = self.frame.size.height - self.currentThumbImage.size.height;
    float sliderOrigin = c.y + (self.currentThumbImage.size.height / 2.0);

    float sliderValueToPixels = (((self.value - self.minimumValue)/(self.maximumValue - self.minimumValue)) * sliderRange) + sliderOrigin;

    return sliderValueToPixels;
}

/*
- (float)yOffsetFromSliderValue: (UIView*)toView // VerticalSlider
{
  //  CGPoint c = [self convertPoint: self.frame.origin fromView: toView];
    float sliderRange = self.frame.size.height - self.currentThumbImage.size.height;
    //float sliderOrigin = c.y + (self.currentThumbImage.size.height / 2.0);

    float sliderValueToPixels = (((self.value - self.minimumValue)/(self.maximumValue - self.minimumValue)) * sliderRange);

    return sliderValueToPixels;
}
*/

- (UIImage*) currentMinimumTrackImage {
    return self._minimumTrackImage;
}

- (void)layoutSubviews {
    [self sizeViews:NO];
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
  return YES;
}

- (void) tapSelf: (BOOL) hilite
{
    self.highlighted = hilite;
    [_sliderThumbView setHighlighted: hilite];
    
    if (hilite) {
        if (thumbHighlightOverlayLayer)
            [thumbHighlightOverlayLayer removeFromSuperlayer];
        thumbHighlightOverlayLayer = [CALayer layer];
        CGRect r = CGRectInset(self.thumbView.bounds, -shadowRadius, -shadowRadius);
        thumbHighlightOverlayLayer.frame = r;
        
        [self.thumbView.layer addSublayer: thumbHighlightOverlayLayer];
        self.thumbView.layer.masksToBounds = NO;
        self.thumbView.backgroundColor = [UIColor clearColor];
        thumbHighlightOverlayLayer.shadowOffset = CGSizeMake(0,0);
        
        CGFloat radius = CGRectGetWidth(thumbHighlightOverlayLayer.frame)/2.;
        thumbHighlightOverlayLayer.shadowColor = [[UIColor whiteColor] CGColor];
        
        thumbHighlightOverlayLayer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0., 0., 2. * (radius), 2. * radius) cornerRadius:radius].CGPath;
        thumbHighlightOverlayLayer.shadowRadius = shadowRadius;
        thumbHighlightOverlayLayer.shadowOpacity = shadowAlpha;
    } else {
        thumbHighlightOverlayLayer.shadowColor = [[UIColor clearColor] CGColor];
         [thumbHighlightOverlayLayer removeFromSuperlayer];
        thumbHighlightOverlayLayer = NULL;
    }
}

- (void) didTap:(BOOL)tap
{
    [self tapSelf:tap];
    if (tap) {
        self.trackVal = _val;
    }
}

- (void)panSelf:(CGPoint) deltaPt
{
}

- (void)didPan:(CGPoint) deltaPt
{
    [self panSelf: deltaPt];
    
    NSLOG(@"bounds = %@", NSStringFromCGRect(self.bounds));
    self.trackVal += (deltaPt.x / self.bounds.size.width) * (_max - _min);
    [self setValue:self.trackVal];
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

- (void)dealloc {
    self._minimumTrackImage = nil;
    self._maximumTrackImage = nil;
    self._minimumValueImage = nil;
    self._maximumValueImage = nil;
    self.thumbImage = nil;
    self.thumbImageHighlighted = nil;
    [_sliderLeftView removeFromSuperview];
    [_sliderRightView removeFromSuperview];
    [_sliderThumbView removeFromSuperview];

    _sliderLeftView = nil;
    _sliderRightView = nil;
    _sliderThumbView = nil;
    //[super dealloc];
}

- (void)setHidden:(BOOL)hide {
    [super setHidden:hide];
    [_sliderThumbView setHidden:hide];
}

- (void)setMaximumTrackTintColor:(UIColor*)color {
}

- (void)setMinimumTrackTintColor:(UIColor*)color {
}

@end
