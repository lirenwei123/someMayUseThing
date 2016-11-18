//
//  WZZEndlessLoopScrollView.m
//  WZZEndlessScrollView
//
//  Created by 王召洲 on 16/9/6.
//  Copyright © 2016年 wyzc. All rights reserved.
//

#import "WZZEndlessLoopScrollView.h"
#define Self_W  (self.frame.size.width)
#define Self_H  (self.frame.size.height)
//===================定时器私有分类==============================//
@interface NSTimer (ForEndlessLoopScrollView)
-(void)pause;
-(void)restart;
-(void)restartAfterTimeInterval:(NSTimeInterval)interVal;
@end
@implementation NSTimer (ForEndlessLoopScrollView)
-(void)pause {
    if ([self isValid]) {
        [self setFireDate:[NSDate distantFuture]];
    }
}
-(void)restart {
    if ([self isValid]) {
        [self setFireDate:[NSDate date]];
    }
}
-(void)restartAfterTimeInterval:(NSTimeInterval)interVal {
    if ([self isValid]) {
        [self setFireDate:[NSDate dateWithTimeIntervalSinceNow:interVal]];
    }
}
@end
//========================UIView分类============================//
@interface UIView (ForEndlessLoopScrollView)
-(UIView*)copyView;
@end
@implementation UIView (ForEndlessLoopScrollView)
-(UIView *)copyView {
    
    NSData  *data = [NSKeyedArchiver archivedDataWithRootObject:self];
    return [NSKeyedUnarchiver unarchiveObjectWithData:data];
}
@end
//==================================================================//

@interface WZZEndlessLoopScrollView ()<UIScrollViewDelegate>
{
    UIScrollView * _scrollView;
    NSInteger _totalPageCount;
    NSInteger _currnetPageIndex;
    NSTimer *_animationTimer;
    NSTimeInterval _animationDuration;
    BOOL _isHorizental;
}
@end
@implementation WZZEndlessLoopScrollView
-(instancetype)initWithFrame:(CGRect)frame animationScrollDuration:(NSTimeInterval)duration isHorizontal:(BOOL)isHorizontal {
    self = [super initWithFrame:frame];
    if (self) {
        _isHorizental = isHorizontal;
        [self initData];
        [self initScrollAnimationTimerWithDuration:duration];
        [self buildScrollView];
    }
    return self;
}
-(void)initData {
    _animationTimer = nil;
    _animationDuration = 0;
}
-(void)initScrollAnimationTimerWithDuration:(NSTimeInterval)duration {
    _animationDuration = duration;
    // 设置定时器 控制 自动滚动
    if (duration > 0) {
        _animationTimer = [NSTimer scheduledTimerWithTimeInterval:duration target:self selector:@selector(startScroll:) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_animationTimer forMode:NSRunLoopCommonModes];
        [_animationTimer pause];
    }
    else {
        NSLog(@"注意时间参数！！！");
    }
}
// 配置 滚动视图
-(void)buildScrollView {
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, Self_W, Self_H)];
    _scrollView.delegate = self;
    _scrollView.contentSize = CGSizeMake(Self_W * (_isHorizental ? 3:1), Self_H * (_isHorizental ? 1:3));
    _scrollView.contentOffset = CGPointMake(Self_W *(_isHorizental?1:0), Self_H * (_isHorizental ? 0:1));
    _scrollView.pagingEnabled = YES;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:_scrollView];
}
// 设置代理后就开始加载数据
-(void)setLoopDelegate:(id<WZZEndlessLoopScrollViewDelegate>)loopDelegate {
    
    _loopDelegate = loopDelegate;
    
    [self reloadData];
}
// 重新加载数据
-(void)reloadData {
    _currnetPageIndex = 0;
    _totalPageCount = 0;
    // 代理提供总页数
    if ([self.loopDelegate respondsToSelector:@selector(numberOfContentViewsInLoopScrollView:)]) {
        _totalPageCount = [self.loopDelegate numberOfContentViewsInLoopScrollView:self];
    }
    else {
        assert(NO);
    }
    // 设置内容视图
    [self resetContentViews];
    
    [_animationTimer restartAfterTimeInterval:_animationDuration];
}
#pragma mark - Action
// 设置滚动  ！！！
-(void)startScroll:(NSTimer *)timer {
    CGPoint newOffset;
    CGFloat contentOffsetXorY;
    contentOffsetXorY = _isHorizental ? ((int)(_scrollView.contentOffset.x+Self_W) / (int)Self_W ) * Self_W :((int)(_scrollView.contentOffset.y+Self_H) / (int)Self_H ) * Self_H;
    newOffset = CGPointMake(contentOffsetXorY * (_isHorizental? 1:0), contentOffsetXorY * (_isHorizental? 0:1));
    
    
    [_scrollView setContentOffset:newOffset animated:YES];
}
#pragma mark -ScrollViewDelegate
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [_animationTimer pause];
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    [_animationTimer restartAfterTimeInterval:_animationDuration];
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    float contentOffetXorY = _isHorizental ? scrollView.contentOffset.x:scrollView.contentOffset.y;
    
    if (contentOffetXorY >= 2 * (_isHorizental?Self_W:Self_H)) {
        
        _currnetPageIndex = [self getNextPageIndexWithCurrnetPageIndex:_currnetPageIndex];
        if ([self.loopDelegate respondsToSelector:@selector(loopScrollView:currentContentViewAtindex:)]) {
            [self.loopDelegate loopScrollView:self currentContentViewAtindex:_currnetPageIndex];
        }
        [self resetContentViews];
    }
    
    if (contentOffetXorY <= 0) {
        
        _currnetPageIndex = [self getPreviousPageIndexWithCurrnetPageIndex:_currnetPageIndex];
        
        if ([self.loopDelegate respondsToSelector:@selector(loopScrollView:currentContentViewAtindex:)]) {
            [self.loopDelegate loopScrollView:self currentContentViewAtindex:_currnetPageIndex];
        }
        [self resetContentViews];
    }
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    [scrollView setContentOffset:CGPointMake((_isHorizental?1:0)*Self_W, Self_H * (_isHorizental?0:1)) animated:YES];
}

#pragma -mark methods

-(void)resetContentViews {
    // 全部移除子视图
    [_scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    NSInteger previousPageIndex = [self getPreviousPageIndexWithCurrnetPageIndex:_currnetPageIndex];
    NSInteger currentPageIndex = _currnetPageIndex;
    NSInteger nextPageIndex = [self getNextPageIndexWithCurrnetPageIndex:_currnetPageIndex];
    UIView *previousContentView;
    UIView *currentContentView;
    UIView *nextContentView;
    
    // 添加新的子视图
    if ([self.loopDelegate respondsToSelector:@selector(loopScrollView:contentViewForIndex:)]){
        
        previousContentView = [self.loopDelegate loopScrollView:self contentViewForIndex:previousPageIndex];
        currentContentView = [self.loopDelegate loopScrollView:self contentViewForIndex:currentPageIndex];
        nextContentView = [self.loopDelegate loopScrollView:self contentViewForIndex:nextPageIndex];
        
        NSArray *viewsArr = @[previousContentView,currentContentView,nextContentView];
        
        for (int i =0; i < viewsArr.count; i++) {
            UIView *contentView = viewsArr[i];
            // 每一个子视图的大小和父视图相等
            [contentView setFrame:CGRectMake((_isHorizental?i*Self_W:0),(_isHorizental?0:i*Self_H), Self_W , Self_H)];
            
            contentView.userInteractionEnabled = YES;
            UITapGestureRecognizer *tapG = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapContentView:)];
            [contentView addGestureRecognizer:tapG];
            [_scrollView addSubview:contentView];
        }
        // 不要动画!!!
        [_scrollView setContentOffset:CGPointMake(_isHorizental?Self_W:0, _isHorizental?0:Self_H)];
    }
    else {
        NSLog(@"请实现 loopScrollView: contentViewAtIndex");
    }
    
}
// 当前页上一页序号
-(NSInteger)getPreviousPageIndexWithCurrnetPageIndex:(NSInteger)currentPageIndex{
    if (currentPageIndex == 0) {
        return _totalPageCount -1;
    }
    else {
        return currentPageIndex-1;
    }
}
// 当前页下一页序号
-(NSInteger)getNextPageIndexWithCurrnetPageIndex:(NSInteger)currentPageIndex{
    if (currentPageIndex == _totalPageCount -1) {
        return 0;
    }
    else {
        return currentPageIndex+1;
    }
}
#pragma mark - TapAction
// 手势处理
-(void)tapContentView:(UITapGestureRecognizer *)tap {
    
    if ([self.loopDelegate respondsToSelector:@selector(loopScrollView:DidSelectedContentViewAtIndex:)]) {
        [self.loopDelegate loopScrollView:self DidSelectedContentViewAtIndex:_currnetPageIndex];
    }
}
@end
