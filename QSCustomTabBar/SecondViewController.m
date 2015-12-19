//
//  SecondViewController.m
//  QSCustomTabBar
//
//  Created by qizhijian on 15/12/19.
//  Copyright © 2015年 qizhijian. All rights reserved.
//

#import "SecondViewController.h"
#import "UITabBarController+Automatic.h"
#import "AutomaticTabBarInfo.h"

@interface SecondViewController ()

@end

@implementation SecondViewController

- (IBAction)change:(id)sender
{
    UITabBarController *tab = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    
    AutomaticTabBarInfo *info = [[AutomaticTabBarInfo alloc] init];
    info.tabBarBackground = [UIColor whiteColor];
    info.imageHeight = 46;
    info.imageWidth = 46;
    info.titleArray = @[@"test1",@"test2",@"test3"];
    info.titleNormalColor = [UIColor redColor];
    info.titleSelectColor = [UIColor blueColor];
    
    UIImage *image1 = [UIImage imageNamed:@"normal"];
    UIImage *image2 = [UIImage imageNamed:@"pressed"];
    
    info.normalImage = @[image1,image1,image1];
    info.selectImage = @[image2,image2,image2];
    
    [tab showCustomImage:info];
}


@end
