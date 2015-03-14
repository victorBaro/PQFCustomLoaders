//
//  PQFCirclesInTriangle.m
//  PQFCustomLoadersDemo
//
//  Created by Pol Quintana on 6/3/15.
//  Copyright (c) 2015 Pol Quintana. All rights reserved.
//

#import "PQFCirclesInTriangle.h"
#import <UIColor+FlatColors.h>

@interface PQFCirclesInTriangle ()
@property (nonatomic, strong) UIView *loaderView;
@property (nonatomic, strong) NSArray *circles;
@property (nonatomic, assign) BOOL animate;

@property (nonatomic, strong) UIColor *loaderColor;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic) CGFloat numberOfCircles;
@property (nonatomic) CGFloat cornerRadius;
@property (nonatomic) CGFloat loaderAlpha;
@property (nonatomic) CGFloat maxDiam;
@property (nonatomic) CGFloat separation;
@property (nonatomic) CGFloat borderWidth;
@property (nonatomic) CGFloat delay;
@property (nonatomic) CGFloat duration;
@property (nonatomic) CGFloat fontSize;
@property (nonatomic) CGFloat rectSize;
@end

@implementation PQFCirclesInTriangle


#pragma mark - PQFLoader methods

+ (instancetype)showLoader:(PQFLoaderType)loaderType onView:(UIView *)view
{
    PQFCirclesInTriangle *loader = [self createLoader:loaderType onView:view];
    [loader showLoader];
    return loader;
}

+ (instancetype)createLoader:(PQFLoaderType)loaderType onView:(UIView *)view
{
    if (!view) view = [[UIApplication sharedApplication].delegate window];
    PQFCirclesInTriangle *loader = [PQFCirclesInTriangle new];
    [loader initialSetupWithView:view];
    return loader;
}

- (void)showLoader
{
    [self performSelector:@selector(startShowingLoader) withObject:nil afterDelay:0];
}

- (void)startShowingLoader
{
    self.hidden = NO;
    self.animate = YES;
    [self generateLoader];
    [self startAnimating];
}

- (void)removeLoader
{
    self.hidden = YES;
    self.animate = NO;
    [self removeFromSuperview];
}


#pragma mark - Prepare loader

- (void)initialSetupWithView:(UIView *)view
{
    //Setting up frame
    self.frame = view.frame;
    self.center = CGPointMake(CGRectGetMidX(view.bounds), CGRectGetMidY(view.bounds));
    
    //If it is modal, background for the loader
    if ([view isKindOfClass:[UIWindow class]]) {
        UIView *bgView = [[UIView alloc] initWithFrame:view.bounds];
        bgView.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.6];
        [self addSubview:bgView];
    }
    
    //Add loader to its superview
    [view addSubview:self];
    
    //Initial Values
    [self defaultValues];
    
    //Initially hidden
    self.hidden = YES;
}

- (void)defaultValues
{
    self.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.0];
    self.numberOfCircles = 6;
    self.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.0];
    self.cornerRadius = 0;
    self.loaderAlpha = 1.0;
    self.loaderColor = [UIColor flatCloudsColor];
    self.maxDiam = 50;
    self.separation = 8.0;
    self.borderWidth = 2.0;
    self.delay = 0.5;
    self.duration = 2.0;
    self.fontSize = 14.0;
    self.rectSize = self.separation*2 + self.maxDiam;
}


#pragma mark - Before showing


- (void)generateLoader
{
    self.loaderView.frame = CGRectMake(0, 0, self.frame.size.width, self.rectSize + 10);
    self.loaderView.center = CGPointMake(CGRectGetWidth(self.frame)/2, CGRectGetHeight(self.frame)/2);
    self.label.frame = CGRectMake(0, 0, self.rectSize + 30, self.fontSize*2+10);
    
    self.layer.cornerRadius = self.cornerRadius;
    
    [self layoutCircles];
    
    if (self.label.text) [self layoutLabel];
}

- (void)layoutCircles
{
    NSMutableArray *temp = [NSMutableArray new];
    
    for (int i = 0; i< self.numberOfCircles; i++) {
        CALayer *circle = [CALayer layer];
        circle.bounds = CGRectMake(0, 0, 0 , 0);
        circle.borderWidth = self.borderWidth;
        circle.borderColor = self.loaderColor.CGColor;
        circle.opacity = self.loaderAlpha;
        
        switch (i) {
            case 0:
                circle.position = CGPointMake(CGRectGetWidth(self.loaderView.frame)/2, CGRectGetHeight(self.loaderView.frame)/2 -self.separation);
                break;
            case 1:
                circle.position = CGPointMake(CGRectGetWidth(self.loaderView.frame)/2 - self.separation, CGRectGetHeight(self.loaderView.frame)/2 + self.separation);
                break;
            case 2:
                circle.position = CGPointMake(CGRectGetWidth(self.loaderView.frame)/2 + self.separation, CGRectGetHeight(self.loaderView.frame)/2 + self.separation);
                break;
            case 3:
                circle.position = CGPointMake(CGRectGetWidth(self.loaderView.frame)/2, CGRectGetHeight(self.loaderView.frame)/2 -self.separation);
                break;
            case 4:
                circle.position = CGPointMake(CGRectGetWidth(self.loaderView.frame)/2 - self.separation, CGRectGetHeight(self.loaderView.frame)/2 + self.separation);
                break;
            case 5:
                circle.position = CGPointMake(CGRectGetWidth(self.loaderView.frame)/2 + self.separation, CGRectGetHeight(self.loaderView.frame)/2 + self.separation);
                break;
        }
        
        [self.loaderView.layer addSublayer:circle];
        [temp addObject:circle];
    }
    self.circles = temp;
}

- (void)layoutLabel
{
    self.label.textAlignment = NSTextAlignmentCenter;
    self.label.numberOfLines = 3;
    self.label.textColor = [UIColor whiteColor];
    self.label.font = [UIFont systemFontOfSize:self.fontSize];
    
    CGFloat xCenter = self.center.x;
    CGFloat yCenter = self.center.y;
    
    self.loaderView.frame = CGRectMake(self.loaderView.frame.origin.x, self.loaderView.frame.origin.y, self.loaderView.frame.size.width, self.loaderView.frame.size.height + 10 + self.label.frame.size.height );
    
    self.frame = CGRectMake(0, 0, self.frame.size.width, self.loaderView.frame.size.height + 10 );
    self.center = CGPointMake(xCenter, yCenter);
    self.loaderView.center = CGPointMake(CGRectGetWidth(self.frame)/2, CGRectGetHeight(self.frame)/2);
    
    CGFloat xPoint = CGRectGetWidth(self.loaderView.frame)/2;
    CGFloat yPoint = CGRectGetHeight(self.loaderView.frame) - self.fontSize/2 *[self.label numberOfLines];
    
    self.label.center = CGPointMake(xPoint, yPoint);
}


#pragma mark - Animate

- (void)startAnimating
{
    if (!self.animate) return;
    [self firstAnimation];
    if (self.numberOfCircles <= 3) return;
    [self performSelector:@selector(secondAnimation) withObject:nil afterDelay:self.delay];
}

- (void)firstAnimation {
    if (!self.animate) return;
    int limit = (self.numberOfCircles < 4) ? self.numberOfCircles : 3;
    for (int i = 0; i < limit; i++) {
        CALayer *circle = [self.circles objectAtIndex:i];
        [self animateCircle:circle atIndex:i];
    }
}

- (void)secondAnimation {
    if (!self.animate) return;
    for (int i = 3; i<self.numberOfCircles; i++) {
        CALayer *circle = [self.circles objectAtIndex:i];
        [self animateCircle:circle atIndex:i];
    }
}

- (void)animateCircle:(CALayer *)circle atIndex:(int)index {
    CGPoint point;
    switch (index) {
        case 0:
            point = CGPointMake(circle.position.x, circle.position.y + self.separation);
            break;
        case 1:
            point = CGPointMake(circle.position.x + self.separation, circle.position.y - self.separation);
            break;
        case 2:
            point = CGPointMake(circle.position.x - self.separation, circle.position.y - self.separation);
            break;
        case 3:
            point = CGPointMake(circle.position.x, circle.position.y + self.separation);
        case 4:
            if (index == 4) {
                point = CGPointMake(circle.position.x + self.separation, circle.position.y - self.separation);
            }
            break;
        case 5:
            point = CGPointMake(circle.position.x - self.separation, circle.position.y - self.separation);
            break;
            
        default:
            break;
    }
    
    CAKeyframeAnimation *bounds1 = [CAKeyframeAnimation animationWithKeyPath:@"bounds.size"];
    bounds1.duration = self.duration;
    bounds1.values = @[[NSValue valueWithCGSize:CGSizeMake(0, 0)],
                       [NSValue valueWithCGSize:CGSizeMake(self.maxDiam, self.maxDiam)]];
    bounds1.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
    
    
    CAKeyframeAnimation *radius = [CAKeyframeAnimation animationWithKeyPath:@"cornerRadius"];
    radius.duration = self.duration;
    radius.values = @[@(0), @(self.maxDiam/2)];
    radius.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
    
    
    CAKeyframeAnimation *position = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    position.duration = self.duration/2;
    position.values = @[[NSValue valueWithCGPoint:circle.position],
                        [NSValue valueWithCGPoint:point]];
    position.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
    position.beginTime = CACurrentMediaTime() + self.duration/2;
    
    //Fade Out
    
    CAKeyframeAnimation *miniBounds = [CAKeyframeAnimation animationWithKeyPath:@"bounds.size"];
    miniBounds.duration = self.duration/2;
    miniBounds.values = @[[NSValue valueWithCGSize:CGSizeMake(self.maxDiam, self.maxDiam)],
                          [NSValue valueWithCGSize:CGSizeMake(0, 0)]];
    miniBounds.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
    miniBounds.beginTime = CACurrentMediaTime() + self.duration;
    if (index == self.numberOfCircles - 1) {
        miniBounds.delegate = self;
    }
    
    CAKeyframeAnimation *radius2 = [CAKeyframeAnimation animationWithKeyPath:@"cornerRadius"];
    radius2.duration = self.duration/2;
    radius2.values = @[@(self.maxDiam/2), @(0)];
    radius2.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
    radius2.beginTime = CACurrentMediaTime() + self.duration;
    
    CAKeyframeAnimation *position2 = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    position2.duration = self.duration/2;
    position2.values = @[[NSValue valueWithCGPoint:point],
                         [NSValue valueWithCGPoint:point]];
    position2.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
    position2.beginTime = CACurrentMediaTime() + self.duration;
    
    [circle addAnimation:bounds1 forKey:@"bounds1"];
    [circle addAnimation:radius forKey:@"radius"];
    [circle addAnimation:position forKey:@"position"];
    
    [circle addAnimation:miniBounds forKey:@"boundsFinal"];
    [circle addAnimation:radius2 forKey:@"radius2"];
    [circle addAnimation:position2 forKey:@"position2"];
    
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    [self startAnimating];
}


#pragma mark - Custom setters

- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    self.loaderView.backgroundColor = backgroundColor;
}

- (void)setLoaderAlpha:(CGFloat)loaderAlpha
{
    _loaderAlpha = loaderAlpha;
    self.loaderView.alpha = loaderAlpha;
}


#pragma mark - Lazy inits

- (UIView *)loaderView
{
    if (!_loaderView) {
        _loaderView = [UIView new];
        [self addSubview:_loaderView];
    }
    return _loaderView;
}

- (UILabel *)label
{
    if (!_label) {
        _label = [UILabel new];
        [self.loaderView addSubview:_label];
    }
    return _label;
}

- (NSArray *)circles
{
    if (!_circles) _circles = [NSArray new];
    return _circles;
}


#pragma mark - Deprecated methods

- (instancetype)initLoaderOnView:(UIView *)view
{
    return [PQFCirclesInTriangle createLoader:PQFLoaderTypeCirclesInTriangle onView:view];
}

@end
