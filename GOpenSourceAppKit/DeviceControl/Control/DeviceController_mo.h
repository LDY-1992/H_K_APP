//
//  DeviceController_mo.h
//  GizOpenSource_Gokit_iOS
//
//  Created by kingcom on 16/8/16.
//  Copyright © 2016年 Gizwits. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GizWifiSDK/GizWifiSDK.h>
#import <GizWifiSDK/GizWifiDevice.h>

//数据端点标识名
#define MONA_SWITCH                       @"Switch"                      //设备开关【布尔值】
#define MONA_FILTER_1_LIFE                @"Filter_1_Life"               //一级滤芯寿命【数值】【0 - 1000】
#define MONA_FILTER_2_LIFE                @"Filter_2_Life"               //二级滤芯寿命【数值】【0 - 1000】

#define MONA_FLUSH_SWITCH                 @"Flush_Switch"                //冲洗开关【布尔值】
#define MONA_RAW_WATER_TDS                @"Raw_Water_Tds"               //原水TDS值【数值】【0 - 1000】
#define MONA_PURE_WATER_TDS               @"Pure_Water_Tds"              //纯水TDS值【数值】【0 - 1000】

#define MONA_COVER_DETECTION_FAULT        @"Cover_Detection_Fault"       //水箱盖故障检测【布尔值】
#define MONA_WATER_LACK_ALARM             @"Water_Lack_Alarm"            //电流检测缺水报警【布尔值】
#define MONA_WATER_PRODUCTION_FAULT       @"Water_Production_Fault"      //制水异常故障【布尔值】
#define MONA_WATER_POOR_ALARM             @"Water_Poor_Alarm"            //原水水质差报警【布尔值】
#define MONA_WATER_HIGH_ALARM             @"Water_High_Alarm"            //干烧异常报警【布尔值】
#define MONA_RAW_WATER_TEMP_ALARM         @"Raw_Water_Temp_Alarm"        //原水温度检测异常报警【布尔值】

#define MONA_WATER_YIELD_TEMP             @"Water_Yield_Temp"            //水量调节_温度【枚举】【0.25度 1.60度 2.85度 3.100度】
#define MONA_MODE                         @"Mode"                        //模式【枚举】【0.制水 1.水满】
#define MONA_CHILD_SECURITY_LOCK          @"Child_Security_Lock"         //儿童锁【布尔值】
#define MONA_FACTORY_RESET                @"Factory_Reset"               //恢复出厂【布尔值】
#define MONA_WATER_YIELD_VALUE            @"Water_Yield_Value"           //水量调节_水量【枚举】【0.150ML 1.250ML 2.350ML 3.450ML 4.550ML 5.650ML 6.750ML 7.850ML 8.950ML 9.1050ML】
#define MONA_NET_WATER                    @"Net_water"                   //净水量【数值】【0 - 65500】

//异常报告
//可消除
#define MONA_TIP1                              @"原水箱缺水，请换水或加水。"     //换水
#define MONA_TIP2                              @"加热器件热保护，请取常温水。"   //干烧
#define MONA_TIP3                              @"原水温度检测异常，请取常温水。"  //原水温度异常
#define MONA_TIP4                              @"原水TDS偏高，建议换水。"       //换水
//不可消除
#define MONA_TIP5                              @"水箱盖未闭合，请换水后，盖好水箱盖。" //换水
#define MONA_TIP6                              @"制水异常，请检查机器后，重新启动机器。"//制水异常
//模式字符
#define MONA_PPM_OFF                           @"--ppm"
#define MONA_PPM                               @"ppm"

#define MONA_MODE_MES1                         @"当前状态：开机"
#define MONA_MODE_MES2                         @"当前状态：关机"
#define MONA_MODE_MES3                         @"当前状态：制水"
#define MONA_MODE_MES4                         @"当前状态：水满"
#define MONA_MODE_MES5                         @"当前状态：冲洗"
#define MONA_MODE_MES6                         @"当前状态：制水异常"
#define MONA_MODE_MES7                         @"当前状态：干烧"
#define MONA_MODE_MES8                         @"当前状态：原水温度异常"
#define MONA_MODE_MES9                         @"当前状态：换水"

#define MY_PI                                  314
#define MY_PI2                                 628
#define MY_PIM                                 -314
#define MY_PIM2                                -628

@interface DeviceController_mo : UIViewController<GizWifiSDKDelegate, GizWifiDeviceDelegate, UIAlertViewDelegate,UIGestureRecognizerDelegate,UIPickerViewDataSource,UIPickerViewDelegate>

- (id)initWithDevice:(GizWifiDevice *)device;

//view1
@property (strong, nonatomic) IBOutlet UIImageView *IV_top_line;
- (IBAction)BA_cancle:(id)sender;
@property (strong, nonatomic) IBOutlet UIImageView *IV_top_mes;
@property (strong, nonatomic) IBOutlet UIButton *B_cancle;

//view2
//middle_view
@property (strong, nonatomic) IBOutlet UIImageView *IV_washing;
@property (strong, nonatomic) IBOutlet UIImageView *IV_main_circle;
@property (strong, nonatomic) IBOutlet UIImageView *IV_circle_off;
@property (strong, nonatomic) IBOutlet UILabel *L_water;
@property (strong, nonatomic) IBOutlet UILabel *L_time;
//other
@property (strong, nonatomic) IBOutlet UIImageView *IV_fun1;
@property (strong, nonatomic) IBOutlet UIImageView *IV_fun2;
@property (strong, nonatomic) IBOutlet UIImageView *IV_fun3;
@property (strong, nonatomic) IBOutlet UIImageView *IV_fun4;
@property (strong, nonatomic) IBOutlet UILabel *L_tds1;
@property (strong, nonatomic) IBOutlet UILabel *L_tds2;
@property (strong, nonatomic) IBOutlet UIImageView *IV_all_filter1;
@property (strong, nonatomic) IBOutlet UIImageView *IV_all_filter2;
- (IBAction)BA_reset_filter1:(id)sender;
- (IBAction)BA_reset_filter2:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *L_filter1;
@property (strong, nonatomic) IBOutlet UILabel *L_filter2;
@property (strong, nonatomic) IBOutlet UIImageView *IV_washing_mes;
@property (strong, nonatomic) IBOutlet UIImageView *IV_show_water;

//view3
- (IBAction)BA_button1:(id)sender;
- (IBAction)BA_button2:(id)sender;
- (IBAction)BA_button3:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *B_button1;
@property (strong, nonatomic) IBOutlet UIButton *B_button2;
@property (strong, nonatomic) IBOutlet UIButton *B_button3;

//view4
- (IBAction)BA_button4:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *L_mode;
@property (strong, nonatomic) IBOutlet UILabel *L_water_num;
@property (strong, nonatomic) IBOutlet UIButton *B_button4;

@end
