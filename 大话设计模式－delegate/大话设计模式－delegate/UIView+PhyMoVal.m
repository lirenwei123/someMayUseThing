//
//  UIView+PhyMoVal.m
//  万州V7宝iOS客户端[ObjC]
//
//  Created by DimChum_Haul on 16/3/12.
//  Copyright © 2016年 沙罗双树831. All rights reserved.
//

#import "UIView+PhyMoVal.h"

NSString* const Meta_Signature = @"Dim.Chum_Haul in 重庆.江北区.汉庭酒店 2015.1.3 <Swift 2.0 :-> Animation_25_D_之基础动画类方法>";
const CGFloat timeFlag = 0.33f;

@implementation UIView (PhyMoVal)
#pragma mark - Helper * Core Animation 核心动画与工厂方法
+ (CAKeyframeAnimation *)keyFrameScale
{
    CAKeyframeAnimation *animate = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    CGFloat deflection = 1.25;
    animate.duration = 0.33f;
    animate.removedOnCompletion = YES;
    animate.fillMode = kCAFillModeForwards;
    
    CATransform3D scaleAnimation1 = CATransform3DMakeScale(deflection, deflection, 1);
    CATransform3D scaleAnimation2 = CATransform3DMakeScale(1/deflection, 1/deflection, 1);
    CATransform3D scaleAnimation4 = CATransform3DMakeScale(1, 1, 1);
    animate.values = @[
                       [NSValue valueWithCATransform3D:scaleAnimation1],
                       [NSValue valueWithCATransform3D:scaleAnimation2],
                       [NSValue valueWithCATransform3D:scaleAnimation4]
                       ];
    return animate;
}

+ (void)Rotate:(UIView *)view{
    CATransform3D aniRotate = CATransform3DMakeRotation(M_PI, -1, 0, 0);
    [UIView animateWithDuration:timeFlag animations:^{
        view.layer.transform  = aniRotate;
        view.alpha = 0.55f;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:timeFlag/2 animations:^{
            view.alpha = 1.0f;
            view.layer.transform = CATransform3DRotate(aniRotate, M_PI, -1, 0, 0);
        }];
    }];
}

/** 抖动动画 */
+ (void)TinyShake:(UIView *)view shakeTimes:(NSUInteger)SKNum{
    if (SKNum >= 15) { SKNum /= 2;}
    
    CGMutablePathRef pathRef = CGPathCreateMutable();
    CAKeyframeAnimation* KeyFrameAni = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    CGPathMoveToPoint(pathRef, nil, view.center.x, view.center.y);
    for (int i = 0 ; i < SKNum ;i++){
        CGPathAddLineToPoint(pathRef, nil, view.center.x + pow(SKNum - i, 1.1), view.center.y + i * 1.1);
        CGPathAddLineToPoint(pathRef, nil, view.center.x - pow(SKNum - i, 1.1), view.center.y - i * 1.1);
    }
    CGPathCloseSubpath(pathRef);
    KeyFrameAni.duration = timeFlag;
    KeyFrameAni.path = pathRef;
    
    [view.layer addAnimation:KeyFrameAni forKey:nil];
}

+ (void)PokerFace:(UIView *)view ToPoint:(CGPoint)point{
    view.userInteractionEnabled = false;
    
    [UIView animateWithDuration:timeFlag animations:^{
        CGAffineTransform flip = CGAffineTransformMakeScale(-1.5, -1.5);
        view.transform = flip;
        
        CGSize slicerSize = CGSizeMake(view.bounds.size.width / 10, view.bounds.size.height / 10);
        CGSize minusSlicer = CGSizeMake(point.x, point.y);
        
        /// 跳跃效果
        CGAffineTransform transPosition;
        if (CGSizeEqualToSize(CGSizeZero, minusSlicer)){
            transPosition = CGAffineTransformMakeTranslation(minusSlicer.width, minusSlicer.height);
            view.layer.affineTransform = transPosition;
        }else{
            transPosition = CGAffineTransformMakeTranslation(slicerSize.width, slicerSize.height);
            view.layer.affineTransform = transPosition;
        }
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:timeFlag/2 animations:^{
            view.layer.transform = CATransform3DIdentity;
        }completion:^(BOOL finished) {
            view.userInteractionEnabled = YES;
        }];
    }];
}

+(void) Common3DAnimateVelocity:(UIView*)objectView
                afterCompletion:(CompletionBlock)block {
    
    ///设定3D视角
    CATransform3D position = CATransform3DIdentity;
    CATransform3D rotation = CATransform3DIdentity;
    position.m34 =rotation.m34 = -1/600;
    CGFloat offsetValueX = objectView.bounds.size.width/20.0;
    CGFloat offsetValueY = objectView.bounds.size.height/20.0;
    position = CATransform3DMakeTranslation(offsetValueX,offsetValueY,50);
    rotation = CATransform3DMakeRotation(M_PI, 0, 1, 0);
    
    [UIView animateWithDuration:timeFlag
                     animations:^{
                         objectView.layer.transform = rotation;
                         objectView.layer.transform = position;
                     } completion:^(BOOL finished) {
                         [UIView animateWithDuration:timeFlag animations:^{
                             objectView.layer.transform = CATransform3DIdentity;
                         }completion:^(BOOL finished) {
                             if(block){
                                 block(false);
                             }else{
                                 printf("请注入block结束操作");
                             }
                         }];
                     }];
}
@end


