//
//  NSObject+Coding.h
//
//  实用的分类
//
//  Created by Leung
//  Copyright (c) 2015年 Leung. All rights reserved.
//


#import "UIView+Common.h"


@implementation UIView (Common)
- (void)setX:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (void)setY:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)x {
    return self.frame.origin.x;
}

- (CGFloat)y {
    return self.frame.origin.y;
}
#pragma mark CenterX
- (CGFloat)centerX
{
    return self.center.x;
}

- (void)setCenterX:(CGFloat)x
{
    CGPoint center = self.center;
    center.x = x;
    self.center = center;
}

#pragma mark CenterY
- (CGFloat)centerY
{
    return self.center.y;
}

- (void)setCenterY:(CGFloat)y
{
    CGPoint center = self.center;
    center.y = y;
    self.center = center;
}

#pragma mark Left
- (CGFloat)left
{
    return self.frame.origin.x;
}

- (void)setLeft:(CGFloat)left
{
    CGRect frame = self.frame;
    frame.origin.x = left;
    self.frame = frame;
}

#pragma mark Top
- (CGFloat)top
{
    return self.frame.origin.y;
}

- (void)setTop:(CGFloat)top
{
    CGRect frame = self.frame;
    frame.origin.y = top;
    self.frame = frame;
}

#pragma mark Right
- (CGFloat)right
{
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setRight:(CGFloat)right
{
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}

#pragma mark Bottom
- (CGFloat)bottom
{
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setBottom:(CGFloat)bottom
{
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}

#pragma mark Width
- (CGFloat)width
{
    return self.frame.size.width;
}

- (void)setWidth:(CGFloat)width
{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

#pragma mark Height
- (CGFloat)height
{
    return self.frame.size.height;
}

- (void)setHeight:(CGFloat)height
{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

#pragma mark Origin
- (CGPoint)origin
{
    return self.frame.origin;
}
- (void)setOrigin:(CGPoint)origin
{
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

/**
 *	@brief	获取视图大小
 *
 *	@return	大小
 */
- (CGSize)size
{
    return self.frame.size;
}
- (void)setSize:(CGSize)size
{
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}


#pragma mark Other
- (void)removeAllSubviews
{
	while (self.subviews.count) 
    {
		UIView *child = self.subviews.lastObject;
		[child removeFromSuperview];
	}
}

- (void)setRadiusWith:(UIRectCorner)rectCorner cornerRadii:(CGSize)size
{
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:rectCorner cornerRadii:size];
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

- (UIViewController *)viewController
{
    UIResponder * responder = self;
    while (responder != nil) {
            if ([responder isKindOfClass:[UIViewController class]]) {
                return (UIViewController *)responder;
            }
            responder = responder.nextResponder;
    }
    
    return nil;
}

- (UINavigationController *)navigationController
{
    return self.viewController.navigationController;
}

- (UIImage *)snapshot
{
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, YES, [UIScreen mainScreen].scale);
    
//    CGContextRef contextRef = UIGraphicsGetCurrentContext();
//    [self.layer renderInContext:contextRef];
    
    [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:NO];
    
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

#pragma mark - layer
- (void)rounded:(CGFloat)cornerRadius {
    [self rounded:cornerRadius width:0 color:nil];
}

- (void)border:(CGFloat)borderWidth color:(UIColor *)borderColor {
    [self rounded:0 width:borderWidth color:borderColor];
}

- (void)rounded:(CGFloat)cornerRadius width:(CGFloat)borderWidth color:(UIColor *)borderColor {
    self.layer.cornerRadius = cornerRadius;
    self.layer.borderWidth = borderWidth;
    self.layer.borderColor = [borderColor CGColor];
    self.layer.masksToBounds = YES;
}


-(void)round:(CGFloat)cornerRadius RectCorners:(UIRectCorner)rectCorner {
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:rectCorner cornerRadii:CGSizeMake(cornerRadius, cornerRadius)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}


-(void)shadow:(UIColor *)shadowColor opacity:(CGFloat)opacity radius:(CGFloat)radius offset:(CGSize)offset {
    //给Cell设置阴影效果
    self.layer.masksToBounds = NO;
    self.layer.shadowColor = shadowColor.CGColor;
    self.layer.shadowOpacity = opacity;
    self.layer.shadowRadius = radius;
    self.layer.shadowOffset = offset;
}


#pragma mark - base
+ (CGFloat)getLabelHeightByWidth:(CGFloat)width Title:(NSString *)title font:(UIFont *)font {
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, 0)];
    label.text = title;
    label.font = font;
    label.numberOfLines = 0;
    [label sizeToFit];
    CGFloat height = label.frame.size.height;
    return height;
}

#pragma mark 毛玻璃
- (void)addGroundGlassWithFrame:(CGRect)frame
{
//    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:frame];
//    toolBar.barStyle = UIBarStyleBlackTranslucent;
//    toolBar.userInteractionEnabled = NO;
//    [self addSubview:toolBar];
}
//
//- (void)removeGroundGlass
//{
//    for (UIView *view in self.subviews) {
//        if ([view isKindOfClass:[UIToolbar class]]) {
//            [view removeFromSuperview];
//            break;
//        }
//    }
//}

@end
