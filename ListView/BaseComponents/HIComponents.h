//
//  HIComponents.h
//  csstest
//
//  Created by YIZE LIN on 2017/12/4.
//  Copyright © 2017年 hive. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HIComponent;

@protocol HIComponentDelegate <NSObject>

- (void)touch:(id<HIComponent>)component;

@end

@protocol HIComponent <NSObject>

@property (nonatomic, weak) id<HIComponentDelegate> delegate;
@property (nonatomic, strong) NSDictionary *dataBindingExt;
@property (nonatomic, strong) NSDictionary *dataValueExt;
@property (nonatomic, strong) NSString *propertyName;
@property (nonatomic, strong) NSDictionary *styleDict;
@property (nonatomic, strong) NSDictionary *attrDict;
@property (nonatomic, assign) NSInteger dataIndex;

- (void)applyStyle;
- (void)prepareForReuse;

@end

#define HIComponentSynthesize \
@synthesize dataBindingExt; \
@synthesize dataValueExt; \
@synthesize propertyName; \
@synthesize styleDict; \
@synthesize attrDict; \
@synthesize dataIndex; \
@synthesize delegate;

