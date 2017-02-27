//
//  GuideView.h
//  Intelligent_Fire
//
//  Created by 高磊 on 2016/12/15.
//  Copyright © 2016年 高磊. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SynthesizeSingleton.h"

/**
 *
 新手引导界面
 *
 **/
@interface GuideView : NSObject

//单列
SYNTHESIZE_SINGLETON_FOR_CLASS_HEADER(GuideView);


/**
 展示新手引导界面 

 @param tapview 需要点击的view数组
 @param tips 对应点击view的提示信息 (提示信息如果没有 请加入@""这样的空字符串)
 */
+ (void)showGuideViewWithTapView:(NSArray <UIView *>*)tapview tips:(NSArray <NSString *> *)tips;

@end
