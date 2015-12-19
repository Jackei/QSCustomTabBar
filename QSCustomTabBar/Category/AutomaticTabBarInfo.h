//
//  AutomaticTabBarInfo.h
//  CustomTab
//
//  Created by qizhijian on 15/12/18.
//  Copyright © 2015年 qizhijian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface AutomaticTabBarInfo : NSObject

@property (nonatomic,strong) UIColor *tabBarBackground;

@property (nonatomic,assign) CGFloat imageHeight;
@property (nonatomic,assign) CGFloat imageWidth;

@property (nonatomic,strong) NSArray *titleArray;

@property (nonatomic,strong) UIColor *titleNormalColor;
@property (nonatomic,strong) UIColor *titleSelectColor;

@property (nonatomic,strong) NSArray<UIImage *> *normalImage;
@property (nonatomic,strong) NSArray<UIImage *> *selectImage;

@end
