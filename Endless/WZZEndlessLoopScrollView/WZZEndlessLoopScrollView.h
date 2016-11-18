//
//  WZZEndlessLoopScrollView.h
//  WZZEndlessScrollView
//
//  Created by 王召洲 on 16/9/6.
//  Copyright © 2016年 wyzc. All rights reserved.
//


//两个对外接口
//分类私有
#import <UIKit/UIKit.h>
@class WZZEndlessLoopScrollView;
@protocol WZZEndlessLoopScrollViewDelegate <NSObject>
@required
-(NSInteger)numberOfContentViewsInLoopScrollView:(WZZEndlessLoopScrollView *)loopView;
-(UIView*)loopScrollView:(WZZEndlessLoopScrollView*)loopView contentViewForIndex:(NSInteger)index;
@optional
-(void)loopScrollView:(WZZEndlessLoopScrollView*)loopView currentContentViewAtindex:(NSInteger)index;
-(void)loopScrollView:(WZZEndlessLoopScrollView *)loopView DidSelectedContentViewAtIndex:(NSInteger)index;
@end

#import <UIKit/UIKit.h>

@interface WZZEndlessLoopScrollView : UIView
@property (weak,nonatomic) id <WZZEndlessLoopScrollViewDelegate> loopDelegate;
/**
 *  initializition
 *
 *  @param frame        frame
 *  @param duration     duration
 *  @param isHorizontal isHorizontal  
 *
 *  @return return an instance
 */
-(instancetype)initWithFrame:(CGRect)frame animationScrollDuration:(NSTimeInterval)duration isHorizontal:(BOOL)isHorizontal;

@end



