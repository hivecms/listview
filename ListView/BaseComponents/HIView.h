//
//  HIView.h
//  csstest
//
//  Created by YIZE LIN on 2017/11/25.
//  Copyright © 2017年 hive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HIComponents.h"
#import <objc/runtime.h>

@interface HIView : UIView <HIComponent>

@end

@interface UIView (HIView)

- (UIView *)componentWithName:(NSString *)name;
- (void)applyStyleDefault:(NSDictionary *)styleDict;
- (CGFloat)sizeWithAttr:(NSString *)attr basicSize:(CGFloat)basicSize;
- (UIColor *)colorWithAttr:(NSString *)attr;

@end
