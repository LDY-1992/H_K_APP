//
//  ViewController_Reset_Alert.m
//  GOpenSource_AppKit
//
//  Created by kingcom on 2017/6/30.
//  Copyright © 2017年 Gizwits. All rights reserved.
//

#import "ViewController_Reset_Alert.h"

#define  RADIUS 8.0f

@interface ViewController_Reset_Alert ()

@end

@implementation ViewController_Reset_Alert

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _view_alert.layer.cornerRadius=RADIUS;
    [_view_alert.layer setMasksToBounds:YES];
    
    [_btn_reset.layer setCornerRadius:RADIUS];
    [_btn_cancle.layer setCornerRadius:RADIUS];
    
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

-(void)Set_lable:(NSString *)l1 withL2:(NSString *)l2 withL3:(NSString *)l3 withL4:(NSString *)l4{
    _lable_1.text=l1;
    _lable_2.text=l2;
    _lable_3.text=l3;
    _lable_4.text=l4;
}

//btn block
-(void)Btn_touch:(MyBlock)block{
    myBlock=block;
}

- (IBAction)BA_reset:(id)sender {
    if(myBlock) myBlock(YES);
}

- (IBAction)BA_cancle:(id)sender {
    if(myBlock) myBlock(NO);
}
@end
