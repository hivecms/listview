//
//  HIListView.m
//  csstest
//
//  Created by YIZE LIN on 2017/11/24.
//  Copyright © 2017年 hive. All rights reserved.
//

#import "HIListView.h"

#import "TouchXML.h"
#import "CSSStyleSheet.h"
#import "Masonry.h"
#import "HIListViewCell.h"
#import "HIComponents.h"
#import "HIView.h"
#import "HIButton.h"

@interface HIListView () <UITableViewDelegate, UITableViewDataSource, HIComponentDelegate>

@property (nonatomic, strong) NSString *defaultType;
@property (nonatomic, strong) NSMutableDictionary *components;
@property (nonatomic, strong) NSMutableArray *datas;
@property (nonatomic, strong) CSSStyleSheet *css;

@end

@implementation HIListView

// 递归嵌套
- (NSDictionary *)dictWithElement:(CXMLElement *)element cellStyleClass:(NSString *)cellStyleClass
{
    CXMLNode *node = (CXMLNode *)element;
    NSString *text = node.stringValue;
    NSString *styleClass = [element attributeForName:@"class"].stringValue;
    NSMutableArray *classNames = [NSMutableArray new];
    if (cellStyleClass) {
        [classNames addObject:cellStyleClass];
    }
    if (styleClass && ![styleClass isEqualToString:cellStyleClass]) {
        [classNames addObject:styleClass];
    }
    NSDictionary *styleDict = [_css styleForTag:node.name classNames:classNames];
    NSMutableDictionary *itemDict = [NSMutableDictionary new];
    [itemDict setObject:node.name forKey:@"_name"];
    if (styleDict) {
        [itemDict setObject:styleDict forKey:@"_style"];
    }
    NSMutableDictionary *attrDict = [NSMutableDictionary new];
    if (text.length > 0) {
        [attrDict setObject:text forKey:@"_text"];
    }
    for (CXMLNode *attrNode in element.attributes) {
        NSString *attrValue = attrNode.stringValue;
        if (attrValue) {
            attrDict[attrNode.name] = attrValue;
        }
    }
    [itemDict setObject:attrDict forKey:@"_attrs"];
    
    NSMutableArray *items = [NSMutableArray new];
    for (int i = 0; i < [node childCount]; i++) {
        CXMLNode *subNode = [node childAtIndex:i];
        if ([subNode isKindOfClass:[CXMLElement class]]) {
            CXMLElement *subElement = (CXMLElement *)subNode;
            NSDictionary *subItemDict = [self dictWithElement:subElement cellStyleClass:cellStyleClass];
            [items addObject:subItemDict];
        }
    }
    if (items.count > 0) {
        [itemDict setObject:items forKey:@"_items"];
    }
    return itemDict;
}

- (void)setHIML:(NSString *)himl style:(NSString *)style
{
    _defaultType = nil;
    
    // 解析style
    _css = [CSSStyleSheet new];
    [_css parseString:style];
    [_css ensureRuleSet];
    
    // 解析himl，初始化components
    NSMutableDictionary *components = [NSMutableDictionary new];
    CXMLDocument *doc = [[CXMLDocument alloc] initWithData:[himl dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
    CXMLElement *rootElement = [doc rootElement];
    for(int i = 0; i < [rootElement childCount]; i++) {
        CXMLNode *node = [rootElement childAtIndex:i];
        if ([node isKindOfClass:[CXMLElement class]]) {
            CXMLElement *element = (CXMLElement *)node;
            if ([node.name isEqualToString:@"cell"]) {
                NSString *cellStyleClass = [element attributeForName:@"class"].stringValue;
                NSDictionary *cellDict = [self dictWithElement:element cellStyleClass:cellStyleClass];
                [components setObject:cellDict forKey:cellStyleClass];
                
                if (!_defaultType) {
                    // 取第一个组件作为默认组件
                    _defaultType = cellStyleClass;
                }
            }
        }
    }
    _components = components;
}

- (void)addComponentToView:(UIView *)itemView itemDict:(NSDictionary *)itemDict
{
    NSString *name = itemDict[@"_name"];
    NSDictionary *styleDict = itemDict[@"_style"];
    NSDictionary *attrDict = itemDict[@"_attrs"];
    NSString *styleClass = attrDict[@"class"];
    NSDictionary *dataBindingExt = [HIListView dataBindingExtWithAttrDict:attrDict];
    NSString *propertyName = nil;
    if (styleClass && name) {
        propertyName = [NSString stringWithFormat:@"%@%@", styleClass, [name capitalizedString]];
    }
    else {
        propertyName = name;
    }
    NSString *nativeClass = [NSString stringWithFormat:@"HI%@", [HIListView capitalString:name]];
    Class classPointer = NSClassFromString(nativeClass);
    if (classPointer)
    {
        // 创建控件
        id object = [classPointer new];
        if ([object isKindOfClass:[UIView class]] && [object conformsToProtocol:@protocol(HIComponent)]) {
            // 赋值，添加到cell
            id <HIComponent> component = (id <HIComponent>)object;
            UIView *view = (UIView *)object;
            [component setDataBindingExt:dataBindingExt];
            [component setStyleDict:styleDict];
            [component setAttrDict:attrDict];
            if (propertyName) {
                [component setPropertyName:propertyName];
            }
            [itemView addSubview:view];
            
            // 应用样式
            //[component applyStyle];
            
            // 子控件
            NSArray *subItems = itemDict[@"_items"];
            for (id subItem in subItems) {
                [self addComponentToView:view itemDict:subItem];
            }
            
            // 回调
            if ([component respondsToSelector:@selector(setDelegate:)]) {
                component.delegate = self;
            }
        }
    }
}

- (void)addComponentToCell:(HIListViewCell *)cell cellDict:(NSDictionary *)cellDict
{
    // cell子控件
    NSArray *items = cellDict[@"_items"];
    for (id item in items) {
        [self addComponentToView:cell.contentView itemDict:item];
    }
    
    // cell数据绑定
    NSDictionary *attrDict = cellDict[@"_attrs"];
    cell.dataBindingExt = [HIListView dataBindingExtWithAttrDict:attrDict];
    
    // cell样式
    NSString *name = @"cell";
    NSString *cellStyleClass = attrDict[@"class"];
    NSString *propertyName = nil;
    if (cellStyleClass) {
        propertyName = [NSString stringWithFormat:@"%@%@", cellStyleClass, [name capitalizedString]];
    }
    else {
        propertyName = name;
    }
    if (propertyName) {
        [cell setPropertyName:propertyName];
    }
    cell.styleDict = cellDict[@"_style"];
    //[cell applyStyle];
}

- (void)applyStyleToView:(UIView *)view
{
    for (UIView *subview in view.subviews) {
        if ([subview conformsToProtocol:@protocol(HIComponent)]) {
            id<HIComponent> component = (id<HIComponent>)subview;
            [component applyStyle];
            [self applyStyleToView:subview];
        }
    }
}

- (void)applyStyleToCell:(HIListViewCell *)cell
{
    [cell applyStyle];
    [self applyStyleToView:cell.contentView];
}

- (void)bindDataWithComponent:(id<HIComponent>)component view:(UIView *)view rowData:(NSDictionary *)rowData row:(NSInteger)row
{
    component.dataIndex = row;
    @try {
        if (component.dataBindingExt) {
            component.dataValueExt = [HIListView dataValueExt:component.dataBindingExt rowData:rowData];
        }
    } @catch (NSException *exception) {
        NSLog(@"%@", exception);
    }
    
    for (UIView *subview in view.subviews) {
        if ([subview conformsToProtocol:@protocol(HIComponent)]) {
            [self bindDataWithComponent:(id<HIComponent>)subview view:subview rowData:rowData row:row];
        }
    }
}

- (void)loadData:(NSDictionary *)data completion:(void (^)(NSError *error))completion
{
    _datas = [NSMutableArray arrayWithArray:data[@"data"]];
    [self.tableView reloadData];
    if (completion) {
        completion(nil);
    }
}

- (void)appendData:(NSDictionary *)data completion:(void (^)(NSError *error))completion
{
    if (!_datas) {
        _datas = [NSMutableArray new];
    }
    [_datas addObjectsFromArray:data[@"data"]];
    [self.tableView reloadData];
    if (completion) {
        completion(nil);
    }
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.estimatedRowHeight = 300.0;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        [self addSubview:_tableView];
        
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.and.top.and.bottom.equalTo(self);
        }];
    }
    return _tableView;
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id rowData = [self.datas objectAtIndex:indexPath.row];
    NSString *type = rowData[@"type"];
    NSDictionary *cellDict = self.components[type];
    if (!cellDict) {
        type = self.defaultType;
        cellDict = self.components[type];
    }
    
    HIListViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:type];
    if (!cell) {
        cell = [[HIListViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:type];

        // 创建view结构
        [self addComponentToCell:cell cellDict:cellDict];
        
        // 设定样式
        [self applyStyleToCell:cell];
    }
    // 绑定数据
    [self bindDataWithComponent:(id<HIComponent>)cell view:cell.contentView rowData:rowData row:indexPath.row];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datas.count;
}

#pragma mark - UITableViewDelegate

// 点击cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < self.datas.count) {
        id rowData = [self.datas objectAtIndex:indexPath.row];
        if (self.delegate) {
            [self.delegate listView:self didSelectCellWithData:rowData];
        }
    }
    else {
        NSLog(@"越界");
    }
}

#pragma mark - HIComponentDelegate

// 点击组件
- (void)touch:(id<HIComponent>)component
{
    if (component.dataIndex < self.datas.count) {
        id rowData = [self.datas objectAtIndex:component.dataIndex];
        if (self.delegate) {
            [self.delegate listView:self touchComponentWithData:rowData action:component.attrDict[@"action"] component:component];
        }
    }
    else {
        NSLog(@"越界");
    }
}

#pragma mark - data binding

// 通过数据绑定表达式，获得数据
// 目前支持4种形式：
// 1、 第一层属性，例子 title
// 2、 第二层属性，例子 prop.type
// 3、 数组中指定元素的某个属性， 例子 medias[0].image
// 4、 数组中全部元素的某个属性， 例子 medias.image  返回数组形式
+ (id)dataWithBinding:(NSString *)dataBinding rowData:(NSDictionary *)rowData
{
    if (!dataBinding) {
        return nil;
    }
    if ([dataBinding rangeOfString:@"["].location != NSNotFound) {
        NSRange r1 = [dataBinding rangeOfString:@"["];
        NSRange r2 = [dataBinding rangeOfString:@"]"];
        NSRange r3 = [dataBinding rangeOfString:@"."];
        NSString *prop = [dataBinding substringToIndex:r1.location];
        NSInteger index = [[dataBinding substringWithRange:NSMakeRange(r1.location+1, r2.location - r1.location-1)] integerValue];
        NSString *subprop = [dataBinding substringWithRange:NSMakeRange(r3.location+1, dataBinding.length - r3.location-1)];
        NSArray *arr = rowData[prop];
        if (!arr || ![arr isKindOfClass:[NSArray class]]) {
            NSLog(@"数据错误");
            return nil;
        }
        if (index >= arr.count) {
            NSLog(@"数据越界");
            return nil;
        }
        id dict = arr[index];
        if (!dict || ![dict isKindOfClass:[NSDictionary class]]) {
            NSLog(@"数据错误");
            return nil;
        }
        return dict[subprop];
    }
    else if ([dataBinding rangeOfString:@"."].location != NSNotFound) {
        NSArray *arr = [dataBinding componentsSeparatedByString:@"."];
        if (arr.count > 2) {
            NSLog(@"暂时不支持2层以上的数据绑定");
            return nil;
        }
        NSString *prop = arr[0];
        NSString *subprop = arr[1];
        id dict = rowData[prop];
        if ([dict isKindOfClass:[NSDictionary class]]) {
            return dict[subprop];
        }
        else if ([dict isKindOfClass:[NSArray class]]) {
            NSMutableArray *valueArray = [NSMutableArray new];
            NSArray *array = (NSArray *)dict;
            for (id subdict in array) {
                if (![subdict isKindOfClass:[NSDictionary class]]) {
                    NSLog(@"数据错误");
                    return nil;
                }
                id value = subdict[subprop];
                if (value) {
                    [valueArray addObject:value];
                }
            }
            return valueArray;
        }
        else {
            NSLog(@"数据错误");
            return nil;
        }
    }
    return rowData[dataBinding];
}

+ (NSDictionary *)dataBindingExtWithAttrDict:(NSDictionary *)attrDict
{
    NSMutableDictionary *dataBindingExt = [NSMutableDictionary new];
    NSArray *keys = [attrDict allKeys];
    for (NSString *key in keys) {
        if ([key hasPrefix:@"data-"]) {
            dataBindingExt[key] = attrDict[key];
        }
        else if ([key isEqualToString:@"data"]) {
            dataBindingExt[key] = attrDict[key];
        }
    }
    return dataBindingExt;
}

+ (NSDictionary *)dataValueExt:(NSDictionary *)dataBindingExt rowData:(NSDictionary *)rowData
{
    NSMutableDictionary *dataValueExt = [NSMutableDictionary new];
    NSArray *keys = [dataBindingExt allKeys];
    for (NSString *key in keys) {
        id dataBinding = dataBindingExt[key];
        id dataValue = [self dataWithBinding:dataBinding rowData:rowData];
        if (dataBinding && dataValue) {
            dataValueExt[key] = dataValue;
        }
    }
    return dataValueExt;
}

#pragma mark - capitalString

+ (NSString *)capitalString:(NSString *)str
{
    if (str.length < 2) {
        return [str capitalizedString];
    }
    return [NSString stringWithFormat:@"%@%@",[[str substringToIndex:1] uppercaseString],[str substringFromIndex:1]];
}

@end
