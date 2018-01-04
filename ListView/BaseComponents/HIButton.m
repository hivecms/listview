//
//  HIButton.m
//  csstest
//
//  Created by YIZE LIN on 2017/11/25.
//  Copyright © 2017年 hive. All rights reserved.
//

#import "HIButton.h"

#import "HIView.h"
#import "UIButton+WebCache.h"

@implementation HIButton
HIComponentSynthesize

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addTarget:self action:@selector(touch) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)touch
{
    if (self.delegate) {
        [self.delegate touch:self];
    }
}

- (void)applyStyle
{
    [self applyStyleDefault:self.styleDict];
    
    NSString *fontSizeAttr = styleDict[@"font-size"];
    if (fontSizeAttr) {
        CGFloat size = [self sizeWithAttr:fontSizeAttr basicSize:16.0];
        self.titleLabel.font = [UIFont systemFontOfSize:size];
    }
    
    NSString *fontColorAttr = styleDict[@"color"];
    if (fontColorAttr) {
        UIColor *color = [self colorWithAttr:fontColorAttr];
        if (color) {
            [self setTitleColor:color forState:UIControlStateNormal];
        }
    }
    
    NSString *titleColorNormalAttr = styleDict[@"-ios-button-normal-color"];
    if (titleColorNormalAttr) {
        UIColor *color = [self colorWithAttr:titleColorNormalAttr];
        if (color) {
            [self setTitleColor:color forState:UIControlStateNormal];
        }
    }
    
    NSString *titleColorHighlightAttr = styleDict[@"-ios-button-highlight-color"];
    if (titleColorHighlightAttr) {
        UIColor *color = [self colorWithAttr:titleColorHighlightAttr];
        if (color) {
            [self setTitleColor:color forState:UIControlStateHighlighted];
        }
    }
    
    NSString *bgColorNormalAttr = styleDict[@"-ios-button-normal-background-color"];
    if (bgColorNormalAttr) {
        UIColor *color = [self colorWithAttr:bgColorNormalAttr];
        if (color && !self.isHighlighted) {
            [self setBackgroundColor:color];
        }
    }
    
    NSString *bgColorHighlightAttr = styleDict[@"-ios-button-highlight-background-color"];
    if (bgColorHighlightAttr) {
        UIColor *color = [self colorWithAttr:bgColorHighlightAttr];
        if (color && self.isHighlighted) {
            [self setBackgroundColor:color];
        }
    }
    
    NSString *borderWidthNormalAttr = styleDict[@"-ios-button-normal-border-width"];
    if (borderWidthNormalAttr) {
        CGFloat width = [self sizeWithAttr:borderWidthNormalAttr basicSize:0];
        if (!self.isHighlighted) {
            [self.layer setBorderWidth:width];
        }
    }
    
    NSString *borderWidthHighlightAttr = styleDict[@"-ios-button-highlight-border-width"];
    if (borderWidthHighlightAttr) {
        CGFloat width = [self sizeWithAttr:borderWidthHighlightAttr basicSize:0];
        if (self.isHighlighted) {
            [self.layer setBorderWidth:width];
        }
    }
}

- (void)prepareForReuse
{
    self.dataValueExt = nil;
}

- (void)setDataValueExt:(NSDictionary *)dict
{
    dataValueExt = dict;
    
    if (dict[@"data-highlight"]) {
        self.highlighted = [dict[@"data-highlight"] boolValue];
    }
}

- (void)setAttrDict:(NSDictionary *)dict
{
    attrDict = dict;
    
    NSString *text = dict[@"_text"];
    if (text) {
        [self setTitle:text forState:UIControlStateNormal];
    }
    
    NSString *titleNormal = dict[@"title-normal"];
    if (titleNormal) {
        [self setTitle:titleNormal forState:UIControlStateNormal];
    }
    
    NSString *titleHighlight = dict[@"title-highlight"];
    if (titleHighlight) {
        [self setTitle:titleHighlight forState:UIControlStateHighlighted];
    }
    
    NSString *image = dict[@"image"];
    if (image) {
        [self sd_setImageWithURL:[NSURL URLWithString:image] forState:UIControlStateNormal];
    }
}

- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    
    if (highlighted) {
        NSString *bgColorHighlightAttr = styleDict[@"-ios-button-highlight-background-color"];
        if (bgColorHighlightAttr) {
            UIColor *color = [self colorWithAttr:bgColorHighlightAttr];
            if (color && self.isHighlighted) {
                [self setBackgroundColor:color];
            }
        }
        NSString *borderWidthHighlightAttr = styleDict[@"-ios-button-highlight-border-width"];
        if (borderWidthHighlightAttr) {
            CGFloat width = [self sizeWithAttr:borderWidthHighlightAttr basicSize:0];
            if (self.isHighlighted) {
                [self.layer setBorderWidth:width];
            }
        }
    }
    else {
        NSString *bgColorNormalAttr = styleDict[@"-ios-button-normal-background-color"];
        if (bgColorNormalAttr) {
            UIColor *color = [self colorWithAttr:bgColorNormalAttr];
            if (color && !self.isHighlighted) {
                [self setBackgroundColor:color];
            }
        }
        NSString *borderWidthNormalAttr = styleDict[@"-ios-button-normal-border-width"];
        if (borderWidthNormalAttr) {
            CGFloat width = [self sizeWithAttr:borderWidthNormalAttr basicSize:0];
            if (!self.isHighlighted) {
                [self.layer setBorderWidth:width];
            }
        }
    }
}

@end
