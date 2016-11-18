//
//  wodeView.m
//  大话设计模式－delegate
//
//  Created by apple on 16/9/13.
//  Copyright © 2016年 wyzc_lrw. All rights reserved.
//

#import "wodeView.h"

@implementation wodeView


- (void)drawRect:(CGRect)rect {
     
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSLog(@"点击了");
    if ([self.delegate respondsToSelector:@selector(shakeWithMyMap:)]) {
        
        [self.delegate shakeWithMyMap:self];
    }
    else{
        NSLog(@"没人代理我");
    }
}

-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSLog(@"移动了");
    if ([self.delegate respondsToSelector:@selector(changeColor:)]) {
        [self.delegate changeColor:self];
    }
    else{
        NSLog(@"没有实现代理方法");
    }
}


@end
