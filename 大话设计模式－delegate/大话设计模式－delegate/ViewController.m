//
//  ViewController.m
//  大话设计模式－delegate
//
//  Created by apple on 16/9/13.
//  Copyright © 2016年 wyzc_lrw. All rights reserved.
//

#import "ViewController.h"
#import "UIView+PhyMoVal.h"
#import "wodeView.h"

@interface ViewController ()<viewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [self learnDelegate];

}


-(void)learnDelegate{
    [super viewDidLoad];
    UIView *view1 =[[UIView alloc]initWithFrame:CGRectMake(100, 100, 300, 400)];
    view1.backgroundColor =[UIColor redColor];
    [self.view addSubview:view1];
    view1.tag =2;
    
    wodeView *view2 =[[wodeView alloc]initWithFrame:CGRectMake(10, 10, 50, 50)];
    view2.backgroundColor =[UIColor greenColor];
    [view1  addSubview:view2];
    view2.delegate =self;

}

-(void)shakeWithMyMap:(wodeView *)view{
    NSLog(@"我要改变点什么");
    UIView *view1 =[self.view viewWithTag:2];
    [UIView Common3DAnimateVelocity:view1 afterCompletion:nil];
}

-(void)changeColor:(wodeView *)view{
    UIView *view1 =[self.view viewWithTag:2];
    [UIView PokerFace:view1 ToPoint:CGPointMake(200, 400)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
