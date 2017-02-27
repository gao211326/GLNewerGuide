//
//  ViewController.m
//  GLNewerGuide
//
//  Created by 高磊 on 2017/2/27.
//  Copyright © 2017年 高磊. All rights reserved.
//

#import "ViewController.h"
#import "GuideView.h"

@interface ViewController ()

@property (nonatomic,strong) UIImageView *imageView_left;

@property (nonatomic,strong) UIImageView *imageView_middle;

@property (nonatomic,strong) UIImageView *imageView_right;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.view addSubview:self.imageView_left];
    [self.view addSubview:self.imageView_middle];
    [self.view addSubview:self.imageView_right];

}

//如果是程序打开的第一个界面就是引导界面 建议在 viewDidAppear 中调用，因为此时 [UIApplication sharedApplication].keyWindow 为nil，keywindow实际上没有初始化完成
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [GuideView showGuideViewWithTapView:@[self.imageView_left,self.imageView_middle,self.imageView_right] tips:@[@"点击试试看",@"下一步",@"完了😯"]];
}


#pragma mark == 懒加载
- (UIImageView *)imageView_left
{
    if (nil == _imageView_left)
    {
        _imageView_left = [[UIImageView alloc] initWithFrame:CGRectMake(80, 80, 40, 40)];
        _imageView_left.image = [UIImage imageNamed:@"1.jpg"];
    }
    return _imageView_left;
}

- (UIImageView *)imageView_middle
{
    if (nil == _imageView_middle)
    {
        _imageView_middle = [[UIImageView alloc] initWithFrame:CGRectMake(150, 100, 40, 40)];
        _imageView_middle.image = [UIImage imageNamed:@"2.jpg"];
    }
    return _imageView_middle;
}

- (UIImageView *)imageView_right
{
    if (nil == _imageView_right)
    {
        _imageView_right = [[UIImageView alloc] initWithFrame:CGRectMake(250, 200, 40, 40)];
        _imageView_right.image = [UIImage imageNamed:@"3.jpg"];
    }
    return _imageView_right;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
