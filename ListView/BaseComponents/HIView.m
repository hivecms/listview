//
//  HIView.m
//  csstest
//
//  Created by YIZE LIN on 2017/11/25.
//  Copyright © 2017年 hive. All rights reserved.
//

#import "HIView.h"
#import "Masonry.h"

@interface HIView ()
@property (nonatomic, strong) UITapGestureRecognizer *tap;
@end

@implementation HIView
HIComponentSynthesize

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touch)];
        _tap.numberOfTouchesRequired = 1;
        _tap.numberOfTapsRequired = 1;
        [self addGestureRecognizer:_tap];
        _tap.enabled = NO;
    }
    return self;
}

- (void)applyStyle
{
    [self applyStyleDefault:self.styleDict];
}

- (void)prepareForReuse
{
    self.dataValueExt = nil;
}

- (void)touch
{
    if (self.delegate) {
        [self.delegate touch:self];
    }
}

- (void)setAttrDict:(NSDictionary *)dict
{
    attrDict = dict;
    
    if ([dict[@"action"] isKindOfClass:[NSString class]]) {
        _tap.enabled = YES;
    }
}

@end

@implementation UIView (HIView)

- (UIView *)componentWithName:(NSString *)name
{
    for (UIView *view in self.subviews) {
        if ([view conformsToProtocol:@protocol(HIComponent)]) {
            id<HIComponent> component = (id<HIComponent>)view;
            if ([component.propertyName isEqualToString:name]) {
                return view;
            }
        }
    }
    return nil;
}

- (void)applyStyleDefault:(NSDictionary *)styleDict
{
    // 背景色
    NSString *backgroundColorAttr = styleDict[@"background-color"];
    if (backgroundColorAttr) {
        UIColor *backgroundColor = [self colorWithAttr:backgroundColorAttr];
        if (backgroundColor) {
            [self setBackgroundColor:backgroundColor];
        }
    }
    
    // 圆角
    NSString *cornerRadiusAttr = styleDict[@"-ios-corner-radius"];
    if (cornerRadiusAttr) {
        CGFloat radius = [self sizeWithAttr:cornerRadiusAttr basicSize:0];
        self.clipsToBounds = YES;
        self.layer.cornerRadius = radius;
    }
    
    // 边界线
    NSString *borderWidthAttr = styleDict[@"-ios-border-width"];
    if (borderWidthAttr) {
        CGFloat borderWidth = [self sizeWithAttr:borderWidthAttr basicSize:0];
        if (borderWidth > 0) {
            [self.layer setBorderWidth:borderWidth];
        }
    }
    
    // 边界颜色
    NSString *borderColorAttr = styleDict[@"-ios-border-color"];
    if (borderColorAttr) {
        UIColor *borderColor = [self colorWithAttr:borderColorAttr];
        if (borderColor) {
            [self.layer setBorderColor:[borderColor CGColor]];
        }
    }
    
    // TODO: 其他基本样式
    
    // AutoLayout
    NSString *layout = styleDict[@"-ios-constraints"];
    if (layout.length > 0 && self.superview) {
        [self mas_remakeConstraints:^(MASConstraintMaker *make) {
            NSArray *arr = [layout componentsSeparatedByString:@","];
            for (NSString *str in arr) {
                NSString *contraintString = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                NSArray *arr2 = [contraintString componentsSeparatedByString:@" "];
                if (arr2.count > 1) {
                    NSString *key = arr2[0];
                    CGFloat value = [arr2[1] floatValue];
                    NSInteger priority = 0;
                    UIView *view = self.superview;
                    NSString *attr = nil;
                    if (arr2.count > 2) {
                        view = [self.superview componentWithName:arr2[2]];
                    }
                    if (arr2.count > 3) {
                        attr = arr2[3];
                    }
                    if (arr2.count > 4) {
                        priority = [arr2[4] integerValue];
                    }
                    if (view) {
                        [self _addConstraintWithKey:key value:value priority:priority view:view attr:attr maker:make];
                    }
                }
            }
        }];
    }
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
- (void)_addConstraintWithKey:(NSString *)key value:(CGFloat)value priority:(NSInteger)priority view:(UIView *)view attr:(NSString *)attr maker:(MASConstraintMaker *)make
{
    id attribute = nil;
    
    SEL selector = NSSelectorFromString(key);
    if ([key isEqualToString:@"widthOffset"]) { // 宽偏移
        selector = NSSelectorFromString(@"width");
    }
    else if ([key isEqualToString:@"heightOffset"]) { // 高偏移
        selector = NSSelectorFromString(@"height");
    }
    if (![make respondsToSelector:selector]) {
        return;
    }
    MASConstraint *target = [make performSelector:selector];
    if (attr.length > 0) {
        SEL selector2 = NSSelectorFromString([NSString stringWithFormat:@"mas_%@", attr]);
        if (![view respondsToSelector:selector2]) {
            return;
        }
        attribute = [view performSelector:selector2];
    }
    else {
        attribute = view;
    }
    
    if ([key isEqualToString:@"width"] || [key isEqualToString:@"height"]) { // 宽高
        if (value < 2.0 && value > 0) {
            // TODO: 按比例显示，如何确定基础宽度?
            value = 375 * value;
        }
        if (priority > 0) {
            target.mas_equalTo(value).with.priority(priority);
        }
        else {
            target.mas_equalTo(value);
        }
    }
    else if (attribute) { // 坐标
        if (priority > 0) {
            target.equalTo(attribute).offset(value).with.priority(priority);
        }
        else {
            target.equalTo(attribute).offset(value);
        }
    }
}
#pragma clang diagnostic pop

- (CGFloat)sizeWithAttr:(NSString *)attr basicSize:(CGFloat)basicSize
{
    attr = [attr lowercaseString];
    if ([attr hasSuffix:@"px"]) {
        return [attr floatValue];
    }
    else if ([attr hasSuffix:@"em"]) {
        return [attr floatValue] * basicSize;
    }
    return [attr floatValue];
}

- (UIColor *)colorWithAttr:(NSString *)attr
{
    attr = [attr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if ([attr isEqualToString:@"transparent"]) {
        return [UIColor clearColor];
    }
    else if ([attr isEqualToString:@"black"]) {
        return [UIColor blackColor];
    }
    else if ([attr isEqualToString:@"white"]) {
        return [UIColor whiteColor];
    }
    else if ([attr isEqualToString:@"yellow"]) {
        return [UIColor yellowColor];
    }
    else if ([attr isEqualToString:@"blue"]) {
        return [UIColor blueColor];
    }
    else if ([attr isEqualToString:@"red"]) {
        return [UIColor redColor];
    }
    else if ([attr isEqualToString:@"orange"]) {
        return [UIColor orangeColor];
    }
    else if ([attr isEqualToString:@"purple"]) {
        return [UIColor purpleColor];
    }
    else if ([attr isEqualToString:@"green"]) {
        return [UIColor greenColor];
    }
    else if ([attr isEqualToString:@"gray"]) {
        return [UIColor grayColor];
    }
    else if ([attr isEqualToString:@"lightgray"]) {
        return [UIColor lightGrayColor];
    }
    
    if (attr.length == 4) {
        // Separate into r, g, b substrings
        NSRange range;
        range.location = 1;
        range.length = 1;
        //r
        NSString *rString = [attr substringWithRange:range];
        //g
        range.location = 2;
        NSString *gString = [attr substringWithRange:range];
        //b
        range.location = 3;
        NSString *bString = [attr substringWithRange:range];
        attr = [NSString stringWithFormat:@"#%@%@%@%@%@%@", rString, rString, gString, gString, bString, bString];
    }
    
    @try {
        // Separate into r, g, b substrings
        NSRange range;
        range.location = 1;
        range.length = 2;
        //r
        NSString *rString = [attr substringWithRange:range];
        //g
        range.location = 3;
        NSString *gString = [attr substringWithRange:range];
        //b
        range.location = 5;
        NSString *bString = [attr substringWithRange:range];
        unsigned int r, g, b;
        [[NSScanner scannerWithString:rString] scanHexInt:&r];
        [[NSScanner scannerWithString:gString] scanHexInt:&g];
        [[NSScanner scannerWithString:bString] scanHexInt:&b];
        return [UIColor colorWithRed:r /255.0f green:g/255.0f blue:b/255.0f alpha:1.0];
    } @catch (NSException *exception) {
        NSLog(@"%@", exception);
    }
    return [UIColor blackColor];
}

@end
