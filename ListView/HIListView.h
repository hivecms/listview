//
//  HIListView.h
//  csstest
//
//  Created by YIZE LIN on 2017/11/24.
//  Copyright © 2017年 hive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HIComponents.h"

@class HIListView;

@protocol HIListViewDelegate <NSObject>

- (void)listView:(HIListView *)listView didSelectCellWithData:(id)dataValue;
- (void)listView:(HIListView *)listView touchComponentWithData:(id)dataValue action:(id)action component:(id<HIComponent>)component;

@end

@interface HIListView : UIView

@property (nonatomic, weak) id<HIListViewDelegate> delegate;
@property (nonatomic, strong) UITableView *tableView;

- (void)setHIML:(NSString *)himl style:(NSString *)style;
- (void)loadData:(NSDictionary *)data completion:(void (^)(NSError *error))completion;
- (void)appendData:(NSDictionary *)data completion:(void (^)(NSError *error))completion;

@end
