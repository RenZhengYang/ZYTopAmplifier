//
//  ZYHeaderViewController.m
//  ZYTopAmplifier
//
//  Created by mac on 16/10/5.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "ZYHeaderViewController.h"
#import "HMObjcSugar.h"
//@import AFNetworking;
//  YYWebImage 不能直接使用@import 导入 @import YYWebImage; (作者做了限制)
#import "YYWebImage.h"
NSString *const cellId = @"cellId";
#define kHeaderHeight 200
@interface ZYHeaderViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation ZYHeaderViewController{
    UIView                  * _headerView;
    UIImageView        * _headerImageView;
    UIView                  * _lineView;
    UIStatusBarStyle     _statusBarStyle;
}


- (void)viewDidLoad {
    [super viewDidLoad];
 
    self.view.backgroundColor = [UIColor whiteColor];
  
    [self prepareTableView];
  
    [self prepareHeaderView];
    
    _statusBarStyle = UIStatusBarStyleLightContent;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return _statusBarStyle;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //   隐藏导航栏
    [self.navigationController setNavigationBarHidden:YES];
    //   取消自动调整滚动视图间距 -- viewController +NAV  会自动调整tableView 的 contentInset
    self.automaticallyAdjustsScrollViewInsets = NO;
}
///  准备顶部视图
- (void)prepareHeaderView
{
    _headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.hm_width, kHeaderHeight)];
    _headerView.backgroundColor = [UIColor hm_colorWithHex:0xF8F8F8 ];
    [self.view addSubview:_headerView];
    
     _headerImageView = [[UIImageView alloc]initWithFrame:_headerView.bounds];
    _headerImageView.backgroundColor = [UIColor hm_colorWithHex:0x000033];
    //   设置 contentMode
    _headerImageView.contentMode = UIViewContentModeScaleAspectFill;
    //   设置 图像裁切
    _headerImageView.clipsToBounds = YES;
    [_headerView addSubview:_headerImageView];
   
    //  添加分割线  一个像素点
    CGFloat lineHeight = 1 / [UIScreen mainScreen].scale;
     _lineView = [[UIView alloc]initWithFrame:(CGRect){0,kHeaderHeight-lineHeight,_headerView.hm_width,lineHeight}];
    _lineView.backgroundColor = [UIColor lightGrayColor];
    [_headerView addSubview:_lineView];
    
    //  设置图像
    NSURL *url = [NSURL URLWithString:@"http://www.who.int/entity/campaigns/immunization-week/2015/large-web-banner.jpg?ua=1"];
    //   AFN 加载图片
    //    [headerImageView setImageWithURL:url];
    
    [_headerImageView yy_setImageWithURL:url options:YYWebImageOptionShowNetworkActivity];
}

- (void)prepareTableView
{
    UITableView *tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    tableView.dataSource = self;
    tableView.delegate =self;
   
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellId];
    
    [self.view addSubview:tableView];
    
    //   设置表格间距
    tableView.contentInset = UIEdgeInsetsMake(kHeaderHeight, 0, 0, 0);
    //    设置滚动指示器的间距
    tableView.scrollIndicatorInsets =  tableView.contentInset;
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1000;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    cell.textLabel.text = @(indexPath.row).stringValue;
    return cell;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{  //    NSLog(@"%f",scrollView.contentOffset.y);
    CGFloat offset = scrollView.contentOffset.y + scrollView.contentInset.top;
   //    NSLog(@"%f",offset);
    
    if (offset <= 0){
        NSLog(@"放大处理");
        
        //  调整 headerView 和 headerImageView
        _headerView.hm_y = 0;
        _headerView.hm_height = kHeaderHeight -offset;
        _headerImageView.hm_height = _headerView.hm_height ;
        _headerImageView.alpha = 1;
}else{
        //        NSLog(@"整体移动");
        //  整体移动
        _headerView.hm_height = kHeaderHeight;
        _headerImageView.hm_height = _headerView.hm_height;
        
        //  headerView 最小的 y 值
        CGFloat min = kHeaderHeight - 64;
        _headerView.hm_y = -MIN(min, offset);
        
        //  设置透明度
        NSLog(@"==%f",offset / min);
        //  根据输出可以知道 offset / min = 1时，的不可见，彻底隐藏
        CGFloat progress = 1 - (offset / min);
        _headerImageView.alpha = progress;
        //  根据透明度  ，来修改状态栏的颜色
        _statusBarStyle = (progress < 0.5) ? UIStatusBarStyleDefault : UIStatusBarStyleLightContent;
        
}
    
      //   设置分割线的位置 -->无论放大缩小
    _lineView.hm_y = _headerView.hm_height - _lineView.hm_height;
     //    需要主动更新状态栏
    [self.navigationController setNeedsStatusBarAppearanceUpdate];
}
@end
