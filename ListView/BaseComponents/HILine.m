//
//  HILine.m
//  csstest
//
//  Created by YIZE LIN on 2017/12/5.
//  Copyright © 2017年 hive. All rights reserved.
//

#import "HILine.h"

#import "HIView.h"

@implementation HILine
HIComponentSynthesize

- (void)applyStyle
{
    [self applyStyleDefault:self.styleDict];
}

- (void)prepareForReuse
{
    self.dataValueExt = nil;
}

@end
