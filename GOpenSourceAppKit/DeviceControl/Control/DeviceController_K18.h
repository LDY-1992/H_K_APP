//
//  DeviceController_K18.h
//  GOpenSource_AppKit
//
//  Created by kingcom on 2017/6/29.
//  Copyright © 2017年 Gizwits. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GizWifiSDK/GizWifiSDK.h>
#import <GizWifiSDK/GizWifiDevice.h>

//数据端点标识名
#define K18_Switch                              @"Switch"               //开关 布尔值
#define K18_Mode                                @"Mode"                 //运行模式 枚举 0.正常 1.冲洗 2.净水 3.假日
#define K18_Filter_1_Life                       @"Filter_1_Life"        //滤芯1寿命 数值 0 - 2160
#define K18_Filter_2_Life                       @"Filter_2_Life"        //滤芯2寿命 数值 0 - 4320
#define K18_Filter_3_Life                       @"Filter_3_Life"        //滤芯3寿命 数值 0 - 4320
#define K18_Filter_4_Life                       @"Filter_4_Life"        //滤芯4寿命 数值 0 - 12960
#define K18_Filter_5_Life                       @"Filter_5_Life"        //滤芯5寿命 数值 0 - 8640
#define K18_Device_Fault                        @"Device_Fault"         //设备故障 布尔值
#define K18_Tds0_Value                          @"Tds0_Value"           //自来水水质 数值 0 - 1000TDS
#define K18_Tds1_Value                          @"Tds1_Value"           //过滤后水质 数值 0 - 1000TDS
#define K18_Flow_Value                          @"Flow_Value"           //流量 数值 0 - 30000ml
#define K18_test_alarm                          @"test_alarm"           //test_alarm 布尔值


@interface DeviceController_K18 : UIViewController<GizWifiSDKDelegate, GizWifiDeviceDelegate, UIActionSheetDelegate, UIAlertViewDelegate>

- (id)initWithDevice:(GizWifiDevice *)device;

//UI power off
@property (strong, nonatomic) IBOutlet UIView *view_power_off;
@property (strong, nonatomic) IBOutlet UIButton *btn_power_on;

- (IBAction)BA_power_on:(id)sender;

//UI power on
@property (strong, nonatomic) IBOutlet UILabel *lable_tap_water;
@property (strong, nonatomic) IBOutlet UILabel *lable_filter_water;
@property (strong, nonatomic) IBOutlet UILabel *lable_flow;

@property (strong, nonatomic) IBOutlet UIImageView *image_filter_element1;
@property (strong, nonatomic) IBOutlet UIImageView *image_filter_element2;
@property (strong, nonatomic) IBOutlet UIImageView *image_filter_element3;
@property (strong, nonatomic) IBOutlet UIImageView *image_filter_element4;
@property (strong, nonatomic) IBOutlet UIImageView *image_filter_element5;

@property (strong, nonatomic) IBOutlet UILabel *lable_filter_status;
@property (strong, nonatomic) IBOutlet UILabel *lable_device_status;

@property (strong, nonatomic) IBOutlet UIButton *btn_start_clean;
- (IBAction)BA_start_clean:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *btn_start_rinse;
- (IBAction)BA_start_rines:(id)sender;

@end
