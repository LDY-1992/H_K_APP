//
//  ViewController_Disconnect_Alert.h
//  GOpenSource_AppKit
//
//  Created by kingcom on 2017/6/30.
//  Copyright © 2017年 Gizwits. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^MyBlock) (BOOL OnStatus);

@interface ViewController_Disconnect_Alert : UIViewController
{
    MyBlock myBlock;
}

//UI
@property (strong, nonatomic) IBOutlet UIView *view_back;
@property (strong, nonatomic) IBOutlet UIView *view_alert;

@property (strong, nonatomic) IBOutlet UIButton *btn_ok;
- (IBAction)BA_ok:(id)sender;

//btn block
-(void)Btn_touch:(MyBlock)block;

@end
