//
//  HIAudio.m
//  csstest
//
//  Created by YIZE LIN on 2017/11/25.
//  Copyright © 2017年 hive. All rights reserved.
//

#import "HIAudio.h"

#import "HIView.h"

@implementation HIAudio
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
