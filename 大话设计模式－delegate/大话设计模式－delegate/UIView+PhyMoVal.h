//
//  UIView+PhyMoVal.h
//  万州V7宝iOS客户端[ObjC]
//
//  Created by DimChum_Haul on 16/1/3.
//  @"Dim.Chum_Haul in 重庆.江北区.汉庭酒店 2015.1.3 <Swift 2.0 :-> Animation_25_D_之基础动画类方法>";
//

#import <UIKit/UIKit.h>

/** NameSpace: Private */
extern NSString* const Meta_Signature;
extern const CGFloat timeFlag;

typedef void(^CompletionBlock)(BOOL isDone);

@interface UIView (PhyMoVal)
/** 2015.11.15汉庭酒店写的卡牌翻转动画 */
+(void) TinyShake:(UIView *)view shakeTimes:(NSUInteger)SKNum;
+(void) Rotate:(UIView *)view;
+(void) PokerFace:(UIView*)view ToPoint:(CGPoint)point;
+(void) Common3DAnimateVelocity:(UIView*)objectView
                afterCompletion:(CompletionBlock)block;

/** 魔兽世界<颤抖2.5D> */
+(CAKeyframeAnimation *)keyFrameScale;
@end
