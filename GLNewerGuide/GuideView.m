//
//  GuideView.m
//  Intelligent_Fire
//
//  Created by 高磊 on 2016/12/15.
//  Copyright © 2016年 高磊. All rights reserved.
//

#import "GuideView.h"

#define UICOLOR_FROM_RGB_OxFF_ALPHA(rgbValue,al)     [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:al]

@interface GuideView ()

//蒙版背景
@property (nonatomic,strong) UIView *bgView;

//添加收拾
@property (nonatomic,strong) UITapGestureRecognizer *tapGesture;

//记录点击的次数
@property (nonatomic,assign) NSInteger tapNumber;

//点击的view数组
@property (nonatomic,strong) NSArray *tapViews;

//需要显示的文字数组
@property (nonatomic,strong) NSArray *tips;

@end

@implementation GuideView

SYNTHESIZE_SINGLETON_FOR_CLASS(GuideView)


+ (void)showGuideViewWithTapView:(NSArray<UIView *> *)tapview tips:(NSArray<NSString *> *)tips
{
    if (tapview.count == 0)
    {
        return;
    }
    [[GuideView sharedInstance] showGuideViewWithTapView:tapview tips:tips];
}

- (id)init
{
    self = [super init];
    if (self) {
        self.tapNumber  = 0;
    }
    return self;
}

- (void)showGuideViewWithTapView:(NSArray<UIView *> *)tapview tips:(NSArray<NSString *> *)tips
{
    self.tapNumber  = 0;
    self.tapViews = tapview;
    self.tips = tips;
    
    CGRect frame = [UIScreen mainScreen].bounds;
    UIView * bgView = [[UIView alloc] initWithFrame:frame];
    bgView.backgroundColor = UICOLOR_FROM_RGB_OxFF_ALPHA(0x323232, 0.8);

    self.bgView = bgView;

    self.tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(sureTapClick:)];
    [self.bgView addGestureRecognizer:self.tapGesture];
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.bgView];
    
    [self addBezierPathWithFrame:frame tapView:tapview[self.tapNumber] tip:tips[self.tapNumber]];
    
}

- (void)addBezierPathWithFrame:(CGRect)frame tapView:(UIView *)view tip:(NSString *)tip
{
    UIImage *guideImage = [UIImage imageNamed:@"guide3"];
    
    CGRect tap_frame = [[view superview] convertRect:view.frame toView:self.bgView];
    
    //通过 UIBezierPath 创建路径
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:frame];
    //画圆圈
    CGFloat radius = 42.5;
    
    [path appendPath:[UIBezierPath bezierPathWithArcCenter:CGPointMake(tap_frame.origin.x + tap_frame.size.width/2.0, tap_frame.origin.y + tap_frame.size.height/2.0) radius:radius startAngle:0 endAngle:2*M_PI clockwise:NO]];
    
    //利用CAShapeLayer 的 path 属性
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = path.CGPath;
    [self.bgView.layer setMask:shapeLayer];
    
    CGFloat x = CGRectGetMidX(tap_frame);
    CGFloat y = CGRectGetMaxY(tap_frame) + radius;

    for (UIView *view in self.bgView.subviews)
    {
        if ([view isKindOfClass:[UIImageView class]] || [view isKindOfClass:[UILabel class]])
        {
            [view removeFromSuperview];
        }
    }
    
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(x,y,guideImage.size.width,guideImage.size.height)];
    imageView.image = guideImage;
    [self.bgView addSubview:imageView];
    
    
    UILabel *lable = [[UILabel alloc] init];
    lable.text = tip;
    lable.font = [UIFont fontWithName:@"Wawati SC" size:20];
    lable.textColor = [UIColor whiteColor];
    //使用代码布局 需要将这个属性设置为NO
    lable.translatesAutoresizingMaskIntoConstraints = NO;
    [self.bgView addSubview:lable];
    
    NSLayoutConstraint * constraintx = nil;
    //将屏幕分成三等分 来确定文字是靠左还是居中 还是靠右 (大概 可以自己调整)
    if (x <= frame.size.width / 3.0) {
        //创建x居左的约束
        constraintx = [NSLayoutConstraint constraintWithItem:lable attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:imageView attribute:NSLayoutAttributeLeft multiplier:1 constant:0];
    }
    else if ((x > frame.size.width / 3.0) &&(x <= frame.size.width * 2 / 3.0))
    {
        //创建x居中的约束
        constraintx = [NSLayoutConstraint constraintWithItem:lable attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:imageView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    }
    else
    {
        //创建x居右的约束
        constraintx = [NSLayoutConstraint constraintWithItem:lable attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:imageView attribute:NSLayoutAttributeRight multiplier:1 constant:0];
    }

    //创建y坐标的约束
    NSLayoutConstraint * constrainty = [NSLayoutConstraint constraintWithItem:lable attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:imageView attribute:NSLayoutAttributeBottom multiplier:1 constant:10];
    
    [self.bgView addConstraints:@[constraintx,constrainty]];
    
    self.tapNumber ++;
}

#pragma mark == event response
- (void)sureTapClick:(UITapGestureRecognizer *)tap
{
    if (self.tapNumber == self.tapViews.count)
    {
        [self.bgView removeFromSuperview];
        return;
    }
    
    CGRect frame = [UIScreen mainScreen].bounds;
    
    [self addBezierPathWithFrame:frame tapView:self.tapViews[self.tapNumber] tip:self.tips[self.tapNumber]];
}


@end
