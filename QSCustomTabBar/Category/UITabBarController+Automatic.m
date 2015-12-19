//
//  tabViewController.m
//  CustomTab
//
//  Created by qizhijian on 15/12/18.
//  Copyright © 2015年 qizhijian. All rights reserved.
//

#import "UITabBarController+Automatic.h"
#import "AutomaticTabBarInfo.h"
#import <objc/runtime.h>

static NSInteger const kStartTag = 100;

static CGFloat const shadowHeight = 0.5f;
static CGFloat const backgrounHeight = 49.0f;
static CGFloat const tabBarLabelHeight = 15.0f;

static const char * kTabBarTitleLabelKey;
static const char * kTabBarButtonKey;
static const char * kAutomaticTabBarInfo;

@interface UITabBarController(AssociatedObject)

@end

@implementation UITabBarController(AssociatedObject)

- (AutomaticTabBarInfo *)getAutomaticTabBarInfo
{
    return objc_getAssociatedObject(self, &kAutomaticTabBarInfo);
}

- (void)setAutomaticTabBarInfo:(AutomaticTabBarInfo *)info
{
    objc_setAssociatedObject(self, &kAutomaticTabBarInfo, info, OBJC_ASSOCIATION_RETAIN);
}

- (NSArray *)getTitleLabelArray
{
    if (!objc_getAssociatedObject(self, &kTabBarTitleLabelKey))
    {
        objc_setAssociatedObject(self, &kTabBarTitleLabelKey, [self initializeArray], OBJC_ASSOCIATION_RETAIN);
    }
    return (NSArray *)objc_getAssociatedObject(self, &kTabBarTitleLabelKey);
}

- (void)setTitleLabel:(UILabel *)label
{
    if (!objc_getAssociatedObject(self, &kTabBarTitleLabelKey))
    {
        objc_setAssociatedObject(self, &kTabBarTitleLabelKey, [self initializeArray], OBJC_ASSOCIATION_RETAIN);
    }
    NSMutableArray *array = objc_getAssociatedObject(self, &kTabBarTitleLabelKey);
    [array addObject:label];
}

- (NSArray *)getImageViewArray
{
    if (!objc_getAssociatedObject(self, &kTabBarButtonKey))
    {
        objc_setAssociatedObject(self, &kTabBarButtonKey, [self initializeArray], OBJC_ASSOCIATION_RETAIN);
    }
    return (NSArray *)objc_getAssociatedObject(self, &kTabBarButtonKey);
}

- (void)setImageView:(UIImageView *)image
{
    if (!objc_getAssociatedObject(self, &kTabBarButtonKey))
    {
        objc_setAssociatedObject(self, &kTabBarButtonKey, [self initializeArray], OBJC_ASSOCIATION_RETAIN);
    }
    NSMutableArray *array = objc_getAssociatedObject(self, &kTabBarButtonKey);
    [array addObject:image];
}

- (NSMutableArray *)initializeArray
{
    return [[NSMutableArray alloc] init];
}

@end

@interface QSImage : NSObject

@end

@implementation QSImage

+ (UIImage *)getShadowImage
{
    CGRect rect = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, shadowHeight);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context,
                                   [UIColor colorWithRed:0 green:0 blue:0 alpha:1].CGColor);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}

+ (UIImage *)getBackgroundImage
{
    CGRect rect1 = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, backgrounHeight);
    UIGraphicsBeginImageContext(rect1.size);
    CGContextRef context1 = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context1,
                                   [UIColor whiteColor].CGColor);
    CGContextFillRect(context1, rect1);
    UIImage *img1 = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img1;
}

@end

@implementation UITabBarController(Automatic)

- (void)showCustomImage:(AutomaticTabBarInfo *)info
{
    [self setAutomaticTabBarInfo:info];
    
    UITabBarController *tab = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    
    for (UITabBarItem *item in tab.tabBar.items) {
        
        item.image = nil;
        item.title = nil;
        
    }
    
    [tab.tabBar setShadowImage:[QSImage getShadowImage]];
//    [tab.tabBar setBackgroundImage:[QSImage getBackgroundImage]];
    
    [self creatOwnView:info];
}

- (void)creatOwnView:(AutomaticTabBarInfo *)info
{
    UITabBarController *tab = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    
    NSUInteger selected = tab.selectedIndex;
    
    UIView *baseView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, backgrounHeight)];
    baseView.backgroundColor = [UIColor whiteColor];
    [tab.tabBar addSubview:baseView];
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width/tab.tabBar.items.count;
    
    UIView *precedingView = nil;
    NSDictionary *dict = @{@"width":@(width)};
    
    for (int i = 0; i < tab.tabBar.items.count;i++)
    {
        UIView *view = ({
        
            UIView *v = [[UIView alloc] init];
            v.translatesAutoresizingMaskIntoConstraints = NO;
            [baseView addSubview:v];
            v.backgroundColor = info.tabBarBackground;
            v;
            
        });
        
        UILabel *label = ({
            
            UILabel *l = [[UILabel alloc] init];
            l.textAlignment = NSTextAlignmentCenter;
            l.font = [UIFont systemFontOfSize:12];
            l.translatesAutoresizingMaskIntoConstraints = NO;
            l.text = info.titleArray[i];
            [view addSubview:l];
            if (i == selected) l.textColor = info.titleSelectColor;
            else l.textColor = info.titleNormalColor;
            l;
            
        });
        
        UIImageView *imageView = ({
            
            UIImageView *imageV = [[UIImageView alloc] init];
            imageV.backgroundColor = [UIColor clearColor];
            imageV.translatesAutoresizingMaskIntoConstraints = NO;
            imageV.image = info.normalImage[i];
            imageV.highlightedImage = info.selectImage[i];
            if (i == selected) imageV.highlighted = YES;
            [view addSubview:imageV];
            imageV;
            
        });
    
        UIButton *button = ({
            
            UIButton *b = [UIButton buttonWithType:UIButtonTypeCustom];
            b.backgroundColor = [UIColor clearColor];
            b.tag = kStartTag + i;
            [b addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            b.translatesAutoresizingMaskIntoConstraints = NO;
            [view addSubview:b];
            b;
            
        });
        
        [self setTitleLabel:label];
        [self setImageView:imageView];
        
        if (!precedingView)
        {
            [baseView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view(==width)]" options:kNilOptions metrics:dict views:NSDictionaryOfVariableBindings(view)]];
            precedingView = view;
        }
        else
        {
            [baseView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"[precedingView][view(==precedingView)]" options:kNilOptions metrics:nil views:NSDictionaryOfVariableBindings(view,precedingView)]];
            precedingView = view;
        }
        [baseView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]|" options:kNilOptions metrics:nil views:NSDictionaryOfVariableBindings(view)]];
        
        NSDictionary *labelDict = @{@"height":@(tabBarLabelHeight)};
        
        [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[label]|" options:kNilOptions metrics:nil views:NSDictionaryOfVariableBindings(label)]];
        [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[label(==height)]|" options:kNilOptions metrics:labelDict views:NSDictionaryOfVariableBindings(label)]];
        
        NSDictionary *imageDict = @{@"height":@(info.imageHeight),@"width":@(info.imageWidth)};
        [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[imageView(==width)]" options:kNilOptions metrics:imageDict views:NSDictionaryOfVariableBindings(imageView)]];
        [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[imageView(==height)]-1-[label]" options:kNilOptions metrics:imageDict views:NSDictionaryOfVariableBindings(imageView,label)]];
        [view addConstraint:[NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
        
        [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[button]|" options:kNilOptions metrics:nil views:NSDictionaryOfVariableBindings(button)]];
        [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[button]|" options:kNilOptions metrics:nil views:NSDictionaryOfVariableBindings(button,label)]];
    }
}

- (void)buttonClick:(UIButton *)button
{
    NSInteger selected = button.tag - kStartTag;
    
    UITabBarController *tab = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    tab.selectedIndex = selected;
    
    for (UIImageView *imageView in [self getImageViewArray]) {
        imageView.highlighted = NO;
    }
    UIImageView *imageView = [[self getImageViewArray] objectAtIndex:selected];
    imageView.highlighted = YES;
    
    AutomaticTabBarInfo *info = [self getAutomaticTabBarInfo];
    for (UILabel *label in [self getTitleLabelArray]) {
        label.textColor = info.titleNormalColor;
    }
    UILabel *label = [[self getTitleLabelArray] objectAtIndex:selected];
    label.textColor = info.titleSelectColor;
}

@end


