//
//  HIVideo.h
//  csstest
//
//  Created by YIZE LIN on 2017/11/25.
//  Copyright © 2017年 hive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HIComponents.h"

#import "FLAnimatedImageView+WebCache.h"
#import "FLAnimatedImageView.h"

@interface HIVideo : FLAnimatedImageView <HIComponent>

@property (nonatomic, strong) NSString *videoURL;
@property (nonatomic, strong) NSString *coverURL;

@end
