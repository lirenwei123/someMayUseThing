//
//  wodeView.h
//  大话设计模式－delegate
//
//  Created by apple on 16/9/13.
//  Copyright © 2016年 wyzc_lrw. All rights reserved.
//

#import <UIKit/UIKit.h>

@class wodeView;

@protocol viewDelegate <NSObject>

-(void)shakeWithMyMap:(wodeView *)view;
-(void)changeColor:(wodeView *)view;

@end

@interface wodeView : UIView


@property (weak)id<viewDelegate> delegate;


@end
