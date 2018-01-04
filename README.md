# listview

Display a list view using xml+css.

# Installtion

```bash
vi Podfile
```
```text
platform :ios, '8.0'

source 'https://github.com/hivecms/Specs.git'
source 'https://github.com/CocoaPods/Specs.git'

target 'your_target_name' do
    pod 'ListView'
end
```
```bash
pod install
```


# Usage

```objc

#import "HIListView.h"
#import "Masonry.h"

...

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.listView setHIML:
     @"<tableview>"
     @"  <cell class='text'>"
     @"    <label data='title' class='title'/>"
     @"    <label data='desc' class='desc'/>"
     @"    <line />"
     @"  </cell>"
     @"  <cell class='textAndImage'>"
     @"    <label data='title' class='title' />"
     @"    <button action='touch'>...</button>"
     @"    <img data='imageurl' />"
     @"    <line />"
     @"  </cell>"
     @"</tableview>"
                     style:
     @"line {"
     @"  background-color: #f9f9f9;"
     @"  -ios-constraints: height 5,left 0,right 0,bottom 0;"
     @"}"
     @"label.title {"
     @"  font-size: 20px;"
     @"  -ios-constraints: top 15,left 15,right -15;"
     @"}"
     @"label.desc {"
     @"  font-size: 16px;"
     @"  -ios-constraints: top 10 titleLabel bottom,left 15,right -15,bottom -15;"
     @"}"
     @".textAndImage label.title {"
     @"  -ios-constraints: top 15,left 15,right -105;"
     @"}"
     @".textAndImage button {"
     @"  font-size: 40px;"
     @"  color: gray;"
     @"  -ios-constraints: centerY -10 titleLabel,left 10 titleLabel right,right -15, height 50;"
     @"}"
     @".textAndImage img {"
     @"  -ios-corner-radius: 10px;"
     @"  -ios-constraints: top 10 titleLabel bottom,left 15,right -15,bottom -15,height 0.5;"
     @"}"
     ];
    [self.listView loadData:
     	@{@"data":@[@{
            @"id":@"111",
            @"title":@"中央军委举行2018年开训动员大会 习近平向全军发布训令",
            @"desc":@"央视网消息（新闻联播）：新年伊始，万象更新，全军上下厉兵秣马，练兵正当时。3日上午，中央军委隆重举行2018年开训动员大会，中共中央总书记、国家主席、中央军委主席习近平向全军发布训令，号召全军贯彻落实党的十九大精神和新时代党的强军思想，全面加强实战化军事训练，全面提高打赢能力。",
            @"imageurl":@"http://p1.img.cctvpic.com/photoworkspace/contentimg/2018/01/03/2018010319561342847.jpg",
            @"type":@"textAndImage"
            },@{
            @"id":@"222",
            @"title":@"80米长巨型雪雕亮相长春",
            @"desc":@"1月4日，长春净月潭内，一座巨型雪雕吸引众多游人。这座巨型雪雕取名为“龙腾盛世”，80米长、20米宽、30米高，总用雪量3.5万立方米。整体造型以巨龙为主体，背景配以蜿蜒的长城。",
            @"imageurl":@"http://01.imgmini.eastday.com/mobile/20180104/20180104140229_423e8f744beb1a11d50a216b64cb398b_1.jpeg",
            @"type":@"textAndImage"
            },@{
            @"id":@"333",
            @"title":@"中央军委举行2018年开训动员大会 习近平向全军发布训令",
            @"desc":@"央视网消息（新闻联播）：新年伊始，万象更新，全军上下厉兵秣马，练兵正当时。3日上午，中央军委隆重举行2018年开训动员大会，中共中央总书记、国家主席、中央军委主席习近平向全军发布训令，号召全军贯彻落实党的十九大精神和新时代党的强军思想，全面加强实战化军事训练，全面提高打赢能力。",
            @"type":@"text"
            }
        ]}
                 completion:^(NSError *error) {
                     if (error) {
                         NSLog(@"%@", error);
                     }
                 }];
}

- (HIListView *)listView
{
    if (!_listView) {
        _listView = [HIListView new];
        _listView.delegate = self;
        [self.view addSubview:_listView];
        
        [_listView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.and.top.and.bottom.equalTo(self.view);
        }];
    }
    return _listView;
}

#pragma mark - HIListViewDelegate

- (void)listView:(HIListView *)listView didSelectCellWithData:(id)dataValue
{
    NSLog(@"touchCell %@", dataValue);
}

- (void)listView:(HIListView *)listView touchComponentWithData:(id)dataValue action:(id)action component:(id<HIComponent>)component
{
    NSLog(@"touchComponent %@ %@", dataValue, action);
}

```
![](http://7b1gcw.com1.z0.glb.clouddn.com/listview3.png?1)


# Ref

CSS Parser
https://github.com/gavinkwoe/BeeFramework/tree/master/framework/mvc/view/css
