//
//  HIListViewCell.m
//  csstest
//
//  Created by YIZE LIN on 2017/11/29.
//  Copyright © 2017年 hive. All rights reserved.
//

#import "HIListViewCell.h"

#import "HIView.h"

@implementation HIListViewCell
HIComponentSynthesize

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)applyStyle
{
    [self.contentView applyStyleDefault:self.styleDict];
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    
    self.dataValueExt = nil;
    
    for (UIView *subview in self.contentView.subviews) {
        if ([subview conformsToProtocol:@protocol(HIComponent)]) {
            id <HIComponent> component = (id <HIComponent>)subview;
            [component prepareForReuse];
        }
    }
}

@end
