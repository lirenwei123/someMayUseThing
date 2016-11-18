//
//  ViewController.m
//  Endless
//
//  Created by 王召洲 on 2016/10/9.
//  Copyright © 2016年 wyzc. All rights reserved.
//

#import "ViewController.h"
#import "WZZEndlessLoopScrollView/WZZEndlessLoopScrollView.h"
@interface ViewController ()<WZZEndlessLoopScrollViewDelegate>
{
    UIPageControl *page;
}
@property (nonatomic,strong) WZZEndlessLoopScrollView * myE;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _myE = [[WZZEndlessLoopScrollView alloc]initWithFrame:CGRectMake(0, 100, self.view.bounds.size.width*0.7, 100) animationScrollDuration:3 isHorizontal:YES];
    [self.view addSubview:_myE];
    page = [[UIPageControl alloc]initWithFrame:CGRectMake(0, 0, 100, 10)];
    [_myE addSubview:page];
    page.numberOfPages = 4;
    _myE.loopDelegate = self;
}

-(NSInteger)numberOfContentViewsInLoopScrollView:(WZZEndlessLoopScrollView *)loopView {
    return 10;
}
- (UIView *)loopScrollView:(WZZEndlessLoopScrollView *)loopView contentViewForIndex:(NSInteger)index {
    
    UIView *v = [[UIView alloc]init];
    UILabel *la = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 50)];
    la.text = [NSString stringWithFormat:@"index -> %ld",index];
    [v addSubview:la];
    v.backgroundColor = [UIColor grayColor];
    return v;
}
-(void)loopScrollView:(WZZEndlessLoopScrollView *)loopView currentContentViewAtindex:(NSInteger)index {
    
    NSLog(@"当前---index--> %ld",index);
    [page setCurrentPage:index % 4];
}
-(void)loopScrollView:(WZZEndlessLoopScrollView *)loopView DidSelectedContentViewAtIndex:(NSInteger)index {
    
    NSLog(@"点击 index --> %ld",index);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
