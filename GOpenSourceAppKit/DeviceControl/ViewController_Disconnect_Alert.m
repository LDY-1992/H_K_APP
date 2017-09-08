//
//  ViewController_Disconnect_Alert.m
//  GOpenSource_AppKit
//
//  Created by kingcom on 2017/6/30.
//  Copyright © 2017年 Gizwits. All rights reserved.
//

#import "ViewController_Disconnect_Alert.h"

#define  RADIUS 8.0f

@interface ViewController_Disconnect_Alert ()

@end

@implementation ViewController_Disconnect_Alert

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //设置圆角
    _view_alert.layer.cornerRadius=RADIUS;
    [_view_alert.layer setMasksToBounds:YES];
    
    //添加背景图片点击事件
    UITapGestureRecognizer *tapGesturRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [_view_back addGestureRecognizer:tapGesturRecognizer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)tapAction:(id)tap
{
    if(myBlock) myBlock(NO);
}

-(void)Btn_touch:(MyBlock)block{
    myBlock=block;
}

- (IBAction)BA_ok:(id)sender {
    if(myBlock) myBlock(YES);
}
@end
