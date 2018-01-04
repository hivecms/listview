//
//  HILabel.m
//  csstest
//
//  Created by YIZE LIN on 2017/11/25.
//  Copyright © 2017年 hive. All rights reserved.
//

#import "HILabel.h"

#import "HIView.h"

@implementation HILabel
HIComponentSynthesize

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.numberOfLines = 0;
        self.lineBreakMode = NSLineBreakByWordWrapping;
        [self setContentHuggingPriority:UILayoutPriorityDefaultHigh
                                          forAxis:UILayoutConstraintAxisVertical];
        [self setContentCompressionResistancePriority:UILayoutPriorityRequired
                                                        forAxis:UILayoutConstraintAxisVertical];
        [self setFont:[UIFont systemFontOfSize:16.0]];
        [self setTextColor:[UIColor blackColor]];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)setDataValueExt:(NSDictionary *)dict
{
    if (![dict isKindOfClass:[NSDictionary class]]) {
        return;
    }
    dataValueExt = dict;
    
    self.text = dict[@"data"];
}

- (void)applyStyle
{
    [self applyStyleDefault:self.styleDict];
    
    NSString *fontSizeAttr = styleDict[@"font-size"];
    if (fontSizeAttr) {
        CGFloat size = [self sizeWithAttr:fontSizeAttr basicSize:16.0];
        self.font = [UIFont systemFontOfSize:size];
    }
    
    NSString *fontColorAttr = styleDict[@"color"];
    if (fontColorAttr) {
        UIColor *color = [self colorWithAttr:fontColorAttr];
        if (color) {
            [self setTextColor:color];
        }
    }
    
    if ([styleDict[@"text-align"] isEqualToString:@"center"]) {
        self.textAlignment = NSTextAlignmentCenter;
    }
}

- (void)prepareForReuse
{
    self.dataValueExt = nil;
    self.text = nil;
}

@end
