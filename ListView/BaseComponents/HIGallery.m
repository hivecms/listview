//
//  HIGallery.m
//  HiveApp
//
//  Created by YIZE LIN on 2017/12/21.
//  Copyright © 2017年 Hive. All rights reserved.
//

#import "HIGallery.h"

#import "HIView.h"
#import "FLAnimatedImageView+WebCache.h"
#import "FLAnimatedImageView.h"
#import "Masonry.h"

@interface HIGallery ()
@property (nonatomic, assign) CGFloat imageGap;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) NSMutableArray *imageViews;
@end

@implementation HIGallery
HIComponentSynthesize

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.imageGap = 10;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
        tap.numberOfTouchesRequired = 1;
        tap.numberOfTapsRequired = 1;
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)tap
{
    if (self.delegate) {
        [self.delegate touch:self];
    }
}

- (void)setDataValueExt:(NSDictionary *)dict
{
    if (![dict isKindOfClass:[NSDictionary class]]) {
        return;
    }
    dataValueExt = dict;
    
    NSArray *imgArray = dict[@"data"];
    if ([imgArray isKindOfClass:[NSArray class]]) {
        [self setImageArray:imgArray];
    }
}

- (void)applyStyle
{
    [self applyStyleDefault:self.styleDict];
    
    // 图片间距
    NSString *imageGap = styleDict[@"image-gap"];
    if (imageGap) {
        _imageGap = [self sizeWithAttr:imageGap basicSize:10];
        if (_imageGap > 0 && _imageViews.count > 0) {
            UIView *prevView = nil;
            NSInteger index = 0;
            for (FLAnimatedImageView *imageView in _imageViews) {
                index += 1;
                
                [imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    if (prevView) {
                        make.left.equalTo(prevView.mas_right).offset(_imageGap);
                    }
                    else {
                        make.left.equalTo(_contentView);
                    }
                    make.top.and.bottom.equalTo(_contentView);
                    make.width.equalTo(_contentView.mas_height);
                    if (index == _imageViews.count) {
                        make.right.equalTo(_contentView);
                    }
                }];
                
                prevView = imageView;
            }
        }
    }
}

- (void)prepareForReuse
{
    self.dataValueExt = nil;
}

- (void)setImageArray:(NSArray *)array
{
    _contentView = [UIView new];
    [self addSubview:_contentView];
    [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
        make.height.equalTo(self);
    }];
    
    _imageViews = [NSMutableArray new];
    UIView *prevView = nil;
    NSInteger index = 0;
    for (NSString *imageurl in array) {
        index += 1;
        FLAnimatedImageView *imageView = [[FLAnimatedImageView alloc] initWithFrame:CGRectZero];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        [imageView sd_setImageWithURL:[NSURL URLWithString:imageurl]];
        [_contentView addSubview:imageView];
        
        [_imageViews addObject:imageView];
        
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            if (prevView) {
                make.left.equalTo(prevView.mas_right).offset(_imageGap);
            }
            else {
                make.left.equalTo(_contentView);
            }
            make.top.and.bottom.equalTo(_contentView);
            make.width.equalTo(_contentView.mas_height);
            if (index == array.count) {
                make.right.equalTo(_contentView);
            }
        }];
        
        prevView = imageView;
    }
}

@end
