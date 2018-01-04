//
//  HIImg.m
//  csstest
//
//  Created by YIZE LIN on 2017/11/25.
//  Copyright © 2017年 hive. All rights reserved.
//

#import "HIImg.h"

#import "HIView.h"

@implementation HIImg
HIComponentSynthesize

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentMode = UIViewContentModeScaleAspectFill;
        self.clipsToBounds = YES;
    }
    return self;
}

- (void)setDataValueExt:(NSDictionary *)dict
{
    if (![dict isKindOfClass:[NSDictionary class]]) {
        return;
    }
    dataValueExt = dict;
    
    NSString *image = dict[@"data"];    
    if (image.length > 7) {
        [self sd_setImageWithURL:[NSURL URLWithString:image]];
    }
}

- (void)applyStyle
{
    [self applyStyleDefault:self.styleDict];
}

- (void)prepareForReuse
{
    self.dataValueExt = nil;
    [self setImage:nil];
}

@end
