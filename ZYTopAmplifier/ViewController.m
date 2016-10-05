//
//  ViewController.m
//  ZYTopAmplifier
//
//  Created by mac on 16/10/5.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "ViewController.h"
#import "ZYHeaderViewController.h"
@interface ViewController ()

@end

@implementation ViewController
- (void)viewDidLoad
{    [super viewDidLoad];


}

- (IBAction)clickButton:(UIBarButtonItem *)sender {
    ZYHeaderViewController *vc = [[ZYHeaderViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
 
}

- (void)viewWillAppear:(BOOL)animated
{
   //  显示导航栏
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

@end
