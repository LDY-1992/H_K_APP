//
//  ViewController_Reset_Alert.h
//  GOpenSource_AppKit
//
//  Created by kingcom on 2017/6/30.
//  Copyright © 2017年 Gizwits. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^MyBlock) (BOOL OnStatus);

@interface ViewController_Reset_Alert : UIViewController
{
    MyBlock myBlock;
}

//UI
@property (strong, nonatomic) IBOutlet UIView *view_back;
@property (strong, nonatomic) IBOutlet UIView *view_alert;

@property (strong, nonatomic) IBOutlet UIButton *btn_reset;
@property (strong, nonatomic) IBOutlet UIButton *btn_cancle;
- (IBAction)BA_reset:(id)sender;
- (IBAction)BA_cancle:(id)sender;

@property (strong, nonatomic) IBOutlet UILabel *lable_1;
@property (strong, nonatomic) IBOutlet UILabel *lable_2;
@property (strong, nonatomic) IBOutlet UILabel *lable_3;
@property (strong, nonatomic) IBOutlet UILabel *lable_4;

//btn block
-(void)Btn_touch:(MyBlock)block;
-(void)Set_lable:(NSString *)l1 withL2:(NSString *)l2 withL3:(NSString *)l3 withL4:(NSString *)l4;
@end
