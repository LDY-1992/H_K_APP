//
//  DeviceController_mo.m
//  GizOpenSource_Gokit_iOS
//
//  Created by kingcom on 16/8/16.
//  Copyright © 2016年 Gizwits. All rights reserved.
//

#import "DeviceController_mo.h"
#import "GizLog.h"
#import "UIView+Toast.h"

#import "GosCommon.h"

@interface DeviceController_mo () {
    
    //GIF
    NSData *top_line_gif,*circle_gif;
    //bool
    BOOL ison,isreset,ischild,iswash,isfull;
    NSInteger top_mes_num;
    UIPickerView *pic_net;
    //rotation
    float c_x,c_y,all_ro,_initAngle;
    
    UIAlertView *_alertView,*_alertView0,*_alertView1,*_alertView2,*_alertView3,*_alertView4,*_alertView5;
    MBProgressHUD *hud;
}
@property (nonatomic,retain) NSArray *timeArray,*netArray,*net_ar;//存储时间数组
@property (readonly, nonatomic) GizWifiDevice *device;

@end

@implementation DeviceController_mo

- (id)initWithDevice:(GizWifiDevice *)device {
    self = [super init];
    if (self) {
        _device = device;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back_arrow"] style:UIBarButtonItemStylePlain target:self action:@selector(onBack)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"more"] style:UIBarButtonItemStylePlain target:self action:@selector(menuBtnPressed)];
    [self Init_all_data];
}

- (void)viewWillAppear:(BOOL)animated {
    GIZ_LOG_BIZ("device_control_page_show", "success", "device control page is shown");
    [super viewWillAppear:animated];
    
    
    NSString *devName = _device.alias;
    if (devName == nil || devName.length == 0) {
        devName = _device.productName;
    }
    self.navigationItem.title = devName;
    
    _device.delegate = self;
    
    
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = NSLocalizedString(@"Waiting for device ready", @"HUD loading title");
    [self.device isBind];
    //    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    GIZ_LOG_BIZ("device_control_page_hide", "success", "device control page is hiden");
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - GizWifiDeviceDelegate
//设备状态改变
- (void)device:(GizWifiDevice *)device didUpdateNetStatus:(GizWifiDeviceNetStatus)netStatus {
    if (netStatus == GizDeviceOffline || netStatus == GizDeviceUnavailable) {
        GIZ_LOG_BIZ("device_notify_disconnected", "success", "device notify disconnected, device mac is %s, did is %s, LAN is %s", self.device.macAddress.UTF8String, self.device.did.UTF8String, self.device.isLAN?"true":"false");
        [_alertView dismissWithClickedButtonIndex:0 animated:YES];
        _alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"连接已断开" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [_alertView show];
        [self performSelector:@selector(onBack) withObject:nil afterDelay:0.5];
    }
}
//设备接受信息
- (void)device:(GizWifiDevice *)device didReceiveData:(NSError *)result data:(NSDictionary *)data withSN:(NSNumber *)sn {
    
    const char *strMacAddr = device.macAddress.UTF8String;
    const char *strDid = device.did.UTF8String;
    const char *strIsLAN = device.isLAN?"true":"false";
    
    // 8308 GIZ_SDK_REQUEST_TIMEOUT
    
    if (result.code != GIZ_SDK_SUCCESS) {
        NSString *info = [NSString stringWithFormat:@"%@ - %@", @(result.code), [result.userInfo objectForKey:@"NSLocalizedDescription"]];
        GIZ_LOG_BIZ("device_notify_error", "failed", "device notify error, result is %s, device mac is %s, did is %s, LAN is %s", info.UTF8String, strMacAddr, strDid, strIsLAN);
        //        [self toast:[NSString stringWithFormat:@"状态回调错误：%@", info]];
        return;
    }
    
    [hud hideAnimated:YES];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    /**
     * 数据部分
     */
    //NSDictionary *_alerts = [data valueForKey:@"alerts"];
    NSDictionary *_data   = [data valueForKey:@"data"];
    NSDictionary *_faults = [data valueForKey:@"faults"];
    if (!_data || _data.count==0 || !_faults || _faults.count==0) {
        return;
    }
    NSLog(@"data=%@",_data);
    //接收数据
    NSNumber *rec_switch                =[_data valueForKey:MONA_SWITCH];
    NSInteger ns1=[rec_switch integerValue];
    
    NSNumber  *rec_child_lock            =[_data valueForKey:MONA_CHILD_SECURITY_LOCK];
    NSInteger ns2=[rec_child_lock integerValue];
    
    NSNumber  *rec_factory_reset         =[_data valueForKey:MONA_FACTORY_RESET];
    NSInteger ns3=[rec_factory_reset integerValue];
    
    NSNumber  *rec_filter_1_life         =[_data valueForKey:MONA_FILTER_1_LIFE];
    NSInteger ns4=[rec_filter_1_life integerValue];
    
    NSNumber  *rec_filter_2_life         =[_data valueForKey:MONA_FILTER_2_LIFE];
    NSInteger ns5=[rec_filter_2_life integerValue];
    
    NSNumber  *rec_flush_switch          =[_data valueForKey:MONA_FLUSH_SWITCH];
    NSInteger ns6=[rec_flush_switch integerValue];
    
    NSNumber  *rec_mode                  =[_data valueForKey:MONA_MODE];
    NSInteger ns7=[rec_mode integerValue];
    //出水量
    //NSString  *rec_net_water             =[_data valueForKey:MONA_NET_WATER];
    //NSInteger ns7=[rec_net_water integerValue];
    
    NSNumber  *rec_pure_water_tds        =[_data valueForKey:MONA_PURE_WATER_TDS];
    NSInteger ns8=[rec_pure_water_tds integerValue];
    
    NSNumber  *rec_raw_water_tds         =[_data valueForKey:MONA_RAW_WATER_TDS];
    NSInteger ns9=[rec_raw_water_tds integerValue];
    
    NSNumber  *rec_raw_water_temp_alarm  =[_data valueForKey:MONA_RAW_WATER_TEMP_ALARM];
    NSInteger ns10=[rec_raw_water_temp_alarm integerValue];
    
    NSNumber  *rec_water_high_alarm      =[_data valueForKey:MONA_WATER_HIGH_ALARM];
    NSInteger ns11=[rec_water_high_alarm integerValue];
    
    NSNumber  *rec_water_lack_alarm      =[_data valueForKey:MONA_WATER_LACK_ALARM];
    NSInteger ns12=[rec_water_lack_alarm integerValue];
    
    NSNumber  *rec_water_poor_alarm      =[_data valueForKey:MONA_WATER_POOR_ALARM];
    NSInteger ns13=[rec_water_poor_alarm integerValue];
    
    NSNumber  *rec_water_yield_temp      =[_data valueForKey:MONA_WATER_YIELD_TEMP];
    NSInteger ns16=[rec_water_yield_temp integerValue];
    
    NSNumber  *rec_water_yield_value     =[_data valueForKey:MONA_WATER_YIELD_VALUE];
    NSInteger ns17=[rec_water_yield_value integerValue];
    
    //接收故障
    NSNumber  *rec_cover_detection_fault     =[_faults valueForKey:MONA_COVER_DETECTION_FAULT];
    NSInteger ns14=[rec_cover_detection_fault integerValue];
    
    NSNumber  *rec_water_production_fault    =[_faults valueForKey:MONA_WATER_PRODUCTION_FAULT];
    NSInteger ns15=[rec_water_production_fault integerValue];
    
    if (ns1==1) {
        NSLog(@"进入开机状态");
        //开机状态
        ison=YES;
        [self.IV_top_line startGIF];
        
        [self.B_button4 setBackgroundImage:[UIImage imageNamed:@"button4_on.png"] forState:UIControlStateNormal];
        //儿童锁
        if (ns2==1) {
            ischild=YES;
            [self.B_button3 setBackgroundImage:[UIImage imageNamed:@"button3_on.png"] forState:UIControlStateNormal];
        }else{
            ischild=NO;
            [self.B_button3 setBackgroundImage:[UIImage imageNamed:@"button3_off.png"] forState:UIControlStateNormal];
        }
        
        //恢复出厂设置
        if (ns3==1) {
            
        }else{
            
        }
        
        //滤芯寿命
        NSString *astring1 = [[NSString alloc] initWithString:[NSString stringWithFormat:@"%ld%%",ns4]];
        self.L_filter1.text=astring1;
        [self Updata_filter1:ns4];
        NSString *astring2 = [[NSString alloc] initWithString:[NSString stringWithFormat:@"%ld%%",ns5]];
        self.L_filter2.text=astring2;
        [self Updata_filter2:ns5];
        
        //冲洗开关
        if (ns6==1) {
            [self.B_button2 setBackgroundImage:[UIImage imageNamed:@"button2_on.png"] forState:UIControlStateNormal];
            if (!iswash) {
                [self Show_circle_washing];
                if (![self.IV_washing isGIFPlaying]) {
                    [self.IV_washing startGIF];
                }
                [self Washing_time];
            }
            iswash=YES;
        }else{
            [self.B_button2 setBackgroundImage:[UIImage imageNamed:@"button2_off.png"] forState:UIControlStateNormal];
            iswash=NO;
            [self Show_circle_main];
            if ([self.IV_washing isGIFPlaying]) {
                [self.IV_washing stopGIF];
            }
        }
        
        //模式
        if (ns7==0) {
            isfull=NO;
            self.L_mode.text=MONA_MODE_MES3;
        }
        else{
            isfull=YES;
            self.L_mode.text=MONA_MODE_MES4;
        }
        
        //纯水TDS
        NSString *chr1=[NSString stringWithFormat:@"%ld%@",ns8,MONA_PPM];
        self.L_tds2.text=chr1;
        //原水TDS
        NSString *chr2=[NSString stringWithFormat:@"%ld%@",ns9,MONA_PPM];
        self.L_tds1.text=chr2;
        
        
        //原水温度检测异常报警【布尔值】
        
        if (ns10==0 && ns11==0 && ns12==0 && ns13==0 && ns14==0 && ns15==0) {
            [self Show_alarm_mes:NO];
            top_mes_num=0;
            [self.IV_top_mes setHidden:YES];
            [self.B_cancle setHidden:YES];
        }
        
        if (ns10==1 || ns11==1 || ns12==1 || ns13==1 || ns14==1 || ns15==1) {
            [self Show_alarm_mes:YES];
        }
        
        
        if (ns10==1) {
            top_mes_num=1;
            [self Pic_alarm:1];
            [self.B_cancle setHidden:NO];
        }else{
            
        }
        
        //干烧异常报警【布尔值】
        if (ns11==1) {
            top_mes_num=2;
            [self Pic_alarm:2];
            [self.B_cancle setHidden:NO];
        }else{
            
        }
        
        //电流检测缺水报警【布尔值】
        if (ns12==1) {
            top_mes_num=3;
            [self Pic_alarm:3];
            [self.B_cancle setHidden:NO];
        }else{
            
        }
        
        //原水水质差报警【布尔值】
        if (ns13==1) {
            top_mes_num=4;
            [self Pic_alarm:4];
            [self.B_cancle setHidden:NO];
        }else{
            
        }
        
        //
        if (ns14==1) {
            top_mes_num=5;
            [self Pic_alarm:5];
            [self.B_cancle setHidden:YES];
        }else{
            
        }
        
        //
        if (ns15==1) {
            top_mes_num=6;
            [self Pic_alarm:6];
            [self.B_cancle setHidden:YES];
        }else{
            
        }
        
        
        //制水温度
        if (ns16==0) {
            self.IV_main_circle.transform = CGAffineTransformMakeRotation(0);
            [self.IV_main_circle setImage:[UIImage imageNamed:@"main_circle1.png"]];
        }else if (ns16==1){
            self.IV_main_circle.transform = CGAffineTransformMakeRotation(M_PI/2);
            [self.IV_main_circle setImage:[UIImage imageNamed:@"main_circle2.png"]];
        }else if (ns16==2){
            self.IV_main_circle.transform = CGAffineTransformMakeRotation(M_PI);
            [self.IV_main_circle setImage:[UIImage imageNamed:@"main_circle3.png"]];
        }else if (ns16==3){
            self.IV_main_circle.transform = CGAffineTransformMakeRotation(3*M_PI/2);
            [self.IV_main_circle setImage:[UIImage imageNamed:@"main_circle4.png"]];
        }
        
        //制水量
        NSString *nt=[NSString stringWithFormat:@"%ld",(ns17+1)*100+50];
        self.L_water.text=nt;
        
    }else{
        NSLog(@"进入关机状态");
        //关机状态
        ison=NO;
        iswash=NO;
        ischild=NO;
        
        [self Show_close];
        
    }
}

//显示关机UI
-(void)Show_close{
    //view1
    if ([self.IV_top_line isGIFPlaying]) {
        [self.IV_top_line stopGIF];
    }
    //[self.IV_top_mes setHidden:YES];
    //[self.B_cancle setHidden:YES];
    
    //view2
    
    [self Show_circle_off];
    if ([self.IV_washing isGIFPlaying]) {
        [self.IV_washing stopGIF];
    }
    
    self.L_tds1.text=MONA_PPM_OFF;
    self.L_tds2.text=MONA_PPM_OFF;
    
    [self.B_button1 setBackgroundImage:[UIImage imageNamed:@"button1_off.png"] forState:UIControlStateNormal];
    [self.B_button2 setBackgroundImage:[UIImage imageNamed:@"button2_off.png"] forState:UIControlStateNormal];
    [self.B_button3 setBackgroundImage:[UIImage imageNamed:@"button3_off.png"] forState:UIControlStateNormal];
    [self.B_button4 setBackgroundImage:[UIImage imageNamed:@"button4_off.png"] forState:UIControlStateNormal];
    
    self.L_mode.text=MONA_MODE_MES2;
}

#pragma mark - UpdataView
//初始化数据
-(void)Init_all_data{
    //初始化界面
    ison=iswash=ischild=isreset=isfull=NO;
    top_mes_num=0;
    //加载GIF
    top_line_gif = [NSData dataWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"top_line" ofType:@"gif"]];
    circle_gif = [NSData dataWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"circle" ofType:@"gif"]];
    //旋转GIF
    self.IV_top_line.gifData=top_line_gif;
    self.IV_washing.gifData=circle_gif;
    //[self.IV_top_line startGIF];
    //[self.IV_washing startGIF];
    
    //主圈添加旋转手势
    UIPanGestureRecognizer *recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(rotateView:)];
    [self.IV_main_circle addGestureRecognizer:recognizer];
    self.IV_main_circle.userInteractionEnabled = YES;
    recognizer.delegate = self;
    CGRect cf=self.IV_main_circle.frame;
    c_x=cf.origin.x+cf.size.width/2;
    c_y=cf.origin.y+cf.size.height/2;
    all_ro=0;
    //初始化对话框
    //显示滤芯1重置对话框
    _alertView0 = [[UIAlertView alloc] initWithTitle:@"滤芯恢复" message:@"是否对滤芯进行清零？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    _alertView0.tag=0;
    //显示滤芯2重置对话框
    _alertView1 = [[UIAlertView alloc] initWithTitle:@"滤芯恢复" message:@"是否对滤芯进行清零？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    _alertView1.tag=1;
    //显示冲洗对话框
    _alertView2 = [[UIAlertView alloc] initWithTitle:@"冲洗" message:@"机器水满，请取水后再操作。" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    _alertView2.tag=2;
    //显示恢复出厂设置对话框
    _alertView3 = [[UIAlertView alloc] initWithTitle:@"恢复出厂设置" message:@"是否对机器恢复出厂设置？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    _alertView3.tag=3;
    //显示设置水量对话框
    _alertView4 = [[UIAlertView alloc] initWithTitle:@"设置水量" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    _alertView4.tag=4;
    
    //添加流量选择框
    
    self.netArray = @[@"150ML",@"250ML",@"350ML",@"450ML",@"550ML",@"650ML",@"750ML",@"850ML",@"950ML",@"1050ML"];
    self.net_ar=@[@"150",@"250",@"350",@"450",@"550",@"650",@"750",@"850",@"950",@"1050"];
    pic_net=[[UIPickerView alloc] init];
    pic_net.delegate=self;
    pic_net.dataSource = self;
    
    self.L_water.userInteractionEnabled=YES;
    UITapGestureRecognizer *labelTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(Show_net_pic)];
    
    [self.L_water addGestureRecognizer:labelTapGestureRecognizer];
}

//显示水量选择对话框
-(void)Show_net_pic{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"设置水量\n\n\n\n\n\n\n\n\n" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        NSInteger ob=[pic_net selectedRowInComponent:0];
        //self.L_water.text=self.net_ar[ob];
        
        NSDictionary *data = @{MONA_WATER_YIELD_VALUE:@(ob)};
        [self writeDataPoint:data];
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }];
    
    [alert addAction:cancel];
    [alert addAction:ok];
    
    [self presentViewController:alert animated:YES completion:^{ }];
    
    pic_net.frame=CGRectMake(80, 40, 110, 200);//weight 270
    [alert.view addSubview:pic_net];
}

//弹出更多选项
-(void)menuBtnPressed{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"设置设备名称" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self Set_name];
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }];
    
    [alertController addAction:ok];
    [alertController addAction:cancel];
    
    [self presentViewController:alertController animated:YES completion:^{ }];
}

//设置名称对话框
-(void)Set_name{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"设置设备名称" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSArray * textfields = alert.textFields;
        UITextField * namefield = textfields[0];
        if (namefield.text) {
            [self.device setCustomInfo:nil alias:namefield.text];
        }else{
            
        }

    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }];
    
    [alert addAction:cancel];
    [alert addAction:ok];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        
        textField.placeholder=@"请输入设备名称";
        textField.textColor = [UIColor blueColor];
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.borderStyle = UITextBorderStyleRoundedRect;
        
    }];
    
    [self presentViewController:alert animated:YES completion:^{ }];
}

//旋转图片
- (void)rotateView:(UIPanGestureRecognizer *)recognizer {
    
    CGPoint touchPoint = [recognizer locationInView:self.IV_main_circle];
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        _initAngle = atan2(touchPoint.y-c_y, touchPoint.x-c_x);
        //NSLog(@"_initAngle=%f",_initAngle);
    }else if (recognizer.state == UIGestureRecognizerStateChanged) {
        //旋转
        float ang = atan2(touchPoint.y - c_y,touchPoint.x - c_x);
        all_ro = _initAngle - ang + all_ro;
        self.IV_main_circle.transform = CGAffineTransformMakeRotation(-all_ro);
        //NSLog(@"_initAngle=%f || ang=%f || all_ro=%f",_initAngle,ang,all_ro);
    }else{
        //切换图片
        NSInteger nn=all_ro*100;
        NSInteger mm=nn%MY_PI2;
        //NSLog(@"mm=%ld",(long)mm);
        if (mm<=0 && mm>=-78) {
            self.IV_main_circle.transform = CGAffineTransformMakeRotation(0);
            [self.IV_main_circle setImage:[UIImage imageNamed:@"main_circle1.png"]];
            
            CGFloat value=0.0f;
            NSDictionary *data = @{MONA_WATER_YIELD_TEMP:@(value)};
            [self writeDataPoint:data];
            
        }else if(mm<=-549){
            self.IV_main_circle.transform = CGAffineTransformMakeRotation(0);
            [self.IV_main_circle setImage:[UIImage imageNamed:@"main_circle1.png"]];
            
            CGFloat value=0.0f;
            NSDictionary *data = @{MONA_WATER_YIELD_TEMP:@(value)};
            [self writeDataPoint:data];
            
        }else if (mm<-78 && mm>=-235) {
            self.IV_main_circle.transform = CGAffineTransformMakeRotation(M_PI/2);
            [self.IV_main_circle setImage:[UIImage imageNamed:@"main_circle2.png"]];
            
            CGFloat value=1.0f;
            NSDictionary *data = @{MONA_WATER_YIELD_TEMP:@(value)};
            [self writeDataPoint:data];
            
        }else if(mm<-235 && mm>=-392){
            self.IV_main_circle.transform = CGAffineTransformMakeRotation(M_PI);
            [self.IV_main_circle setImage:[UIImage imageNamed:@"main_circle3.png"]];
            
            CGFloat value=2.0f;
            NSDictionary *data = @{MONA_WATER_YIELD_TEMP:@(value)};
            [self writeDataPoint:data];
            
        }else if (mm<-392 && mm>-549){
            self.IV_main_circle.transform = CGAffineTransformMakeRotation(3*M_PI/2);
            [self.IV_main_circle setImage:[UIImage imageNamed:@"main_circle4.png"]];
            
            CGFloat value=3.0f;
            NSDictionary *data = @{MONA_WATER_YIELD_TEMP:@(value)};
            [self writeDataPoint:data];
            
        }else if (mm>0 && mm<=78){
            self.IV_main_circle.transform = CGAffineTransformMakeRotation(0);
            [self.IV_main_circle setImage:[UIImage imageNamed:@"main_circle1.png"]];
            
            CGFloat value=0.0f;
            NSDictionary *data = @{MONA_WATER_YIELD_TEMP:@(value)};
            [self writeDataPoint:data];
            
        }else if(mm>=549){
            self.IV_main_circle.transform = CGAffineTransformMakeRotation(0);
            [self.IV_main_circle setImage:[UIImage imageNamed:@"main_circle1.png"]];
            
            CGFloat value=0.0f;
            NSDictionary *data = @{MONA_WATER_YIELD_TEMP:@(value)};
            [self writeDataPoint:data];
            
        }else if (mm>78 && mm<=235){
            self.IV_main_circle.transform = CGAffineTransformMakeRotation(3*M_PI/2);
            [self.IV_main_circle setImage:[UIImage imageNamed:@"main_circle4.png"]];
            
            CGFloat value=3.0f;
            NSDictionary *data = @{MONA_WATER_YIELD_TEMP:@(value)};
            [self writeDataPoint:data];
            
        }else if (mm>235 && mm<=392){
            self.IV_main_circle.transform = CGAffineTransformMakeRotation(M_PI);
            [self.IV_main_circle setImage:[UIImage imageNamed:@"main_circle3.png"]];
            
            CGFloat value=2.0f;
            NSDictionary *data = @{MONA_WATER_YIELD_TEMP:@(value)};
            [self writeDataPoint:data];
            
        }else if (mm>392 && mm<549){
            self.IV_main_circle.transform = CGAffineTransformMakeRotation(M_PI/2);
            [self.IV_main_circle setImage:[UIImage imageNamed:@"main_circle2.png"]];
            
            CGFloat value=1.0f;
            NSDictionary *data = @{MONA_WATER_YIELD_TEMP:@(value)};
            [self writeDataPoint:data];
            
        }
        
        all_ro=0;
    }
    
}

//更新一级滤网
-(void)Updata_filter1:(NSInteger)n{
    if (n==0) {
        [self.IV_all_filter1 setImage:[UIImage imageNamed:@"all_filter1_0.png"]];
    }else if (n>0&&n<=20){
        [self.IV_all_filter1 setImage:[UIImage imageNamed:@"all_filter1_1.png"]];
    }else if (n>20&&n<=40){
        [self.IV_all_filter1 setImage:[UIImage imageNamed:@"all_filter1_2.png"]];
    }else if (n>40&&n<=60){
        [self.IV_all_filter1 setImage:[UIImage imageNamed:@"all_filter1_3.png"]];
    }else if (n>60&&n<=80){
        [self.IV_all_filter1 setImage:[UIImage imageNamed:@"all_filter1_4.png"]];
    }else{
        [self.IV_all_filter1 setImage:[UIImage imageNamed:@"all_filter1_5.png"]];
    }
}

//更新二级滤网
-(void)Updata_filter2:(NSInteger)n{
    if (n==0) {
        [self.IV_all_filter2 setImage:[UIImage imageNamed:@"all_filter2_0.png"]];
    }else if (n>0&&n<=20){
        [self.IV_all_filter2 setImage:[UIImage imageNamed:@"all_filter2_1.png"]];
    }else if (n>20&&n<=40){
        [self.IV_all_filter2 setImage:[UIImage imageNamed:@"all_filter2_2.png"]];
    }else if (n>40&&n<=60){
        [self.IV_all_filter2 setImage:[UIImage imageNamed:@"all_filter2_3.png"]];
    }else if (n>60&&n<=80){
        [self.IV_all_filter2 setImage:[UIImage imageNamed:@"all_filter2_4.png"]];
    }else{
        [self.IV_all_filter2 setImage:[UIImage imageNamed:@"all_filter2_5.png"]];
    }
}

//显示关机圈
-(void)Show_circle_off{
    
    [self.IV_circle_off setHidden:NO];
    
    [self.IV_fun1 setHidden:NO];
    [self.IV_fun2 setHidden:NO];
    [self.IV_fun3 setHidden:NO];
    [self.IV_fun4 setHidden:NO];
    
    [self.IV_main_circle setHidden:YES];
    [self.IV_show_water setHidden:YES];
    [self.L_water setHidden:YES];
    
    [self.IV_washing_mes setHidden:YES];
    [self.IV_washing setHidden:YES];
    [self.L_time setHidden:YES];
}

//显示开机圈
-(void)Show_circle_main{
    
    [self.IV_circle_off setHidden:YES];
    
    [self.IV_fun1 setHidden:NO];
    [self.IV_fun2 setHidden:NO];
    [self.IV_fun3 setHidden:NO];
    [self.IV_fun4 setHidden:NO];
    
    [self.IV_main_circle setHidden:NO];
    [self.IV_show_water setHidden:NO];
    [self.L_water setHidden:NO];
    
    [self.IV_washing_mes setHidden:YES];
    [self.IV_washing setHidden:YES];
    [self.L_time setHidden:YES];
}

//显示冲洗圈
-(void)Show_circle_washing{
    
    [self.IV_circle_off setHidden:YES];
    
    [self.IV_fun1 setHidden:YES];
    [self.IV_fun2 setHidden:YES];
    [self.IV_fun3 setHidden:YES];
    [self.IV_fun4 setHidden:YES];
    
    [self.IV_main_circle setHidden:YES];
    [self.IV_show_water setHidden:YES];
    [self.L_water setHidden:YES];
    
    [self.IV_washing_mes setHidden:NO];
    [self.IV_washing setHidden:NO];
    [self.L_time setHidden:NO];
}

//冲洗倒计时（10分钟）
-(void)Washing_time{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 耗时的操作
        NSInteger i,a,b;
        NSString *chr,*chr1,*chr2;
        for (i=599 ; i>=0; i--) {
            if (iswash) {
                a=i/60;
                chr1=[NSString stringWithFormat:@"0%ld",(long)a];
                b=i%60;
                if (b<10) {
                    chr2=[NSString stringWithFormat:@"0%ld",(long)b];
                }else{
                    chr2=[NSString stringWithFormat:@"%ld",(long)b];
                }
                chr=[NSString stringWithFormat:@"%@:%@",chr1,chr2];
                [NSThread sleepForTimeInterval:1];
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.L_time.text=chr;
                });
            }else{
                break;
            }
            
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.L_time.text=@"10:00";
        });
        
    });
    
}

//选择顶部报警信息
-(void)Pic_alarm:(NSInteger)n{
    switch (n) {
        case 1:
            [self.IV_top_mes setImage:[UIImage imageNamed:@"tip3.png"]];
            break;
        case 2:
            [self.IV_top_mes setImage:[UIImage imageNamed:@"tip2.png"]];
            break;
        case 3:
            [self.IV_top_mes setImage:[UIImage imageNamed:@"tip1.png"]];
            break;
        case 4:
            [self.IV_top_mes setImage:[UIImage imageNamed:@"tip4.png"]];
            break;
        case 5:
            [self.IV_top_mes setImage:[UIImage imageNamed:@"tip7.png"]];
            break;
        case 6:
            [self.IV_top_mes setImage:[UIImage imageNamed:@"tip8.png"]];
            break;
        default:
            break;
    }
}

//显示顶部报警UI
-(void)Show_alarm_mes:(NSInteger)n{
    if (n==1) {
        [self.IV_top_mes setHidden:NO];
        [self.IV_top_line setHidden:YES];
    }else{
        [self.IV_top_mes setHidden:YES];
        [self.IV_top_line setHidden:NO];
    }
    
}

#pragma mark --- 与DataSource有关的代理方法
//返回列数（必须实现）
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

//返回每列里边的行数（必须实现）
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    //如果是第一列
    if (component == 0) {
        //返回姓名数组的个数
        return self.netArray.count;
    }
    return 0;
}

//设置组件的宽度
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    if (component == 0) {
        return 100;
    }
    else
    {
        return 80;
    }
    
}
//设置组件中每行的高度
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    if (component == 0) {
        return 60;
    }
    else
    {
        return 60;
    }
}

//设置组件中每行的标题row:行
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == 0) {
        return self.netArray[row];
    }
    return 0;
}


#pragma mark - datapoint_wright_read
- (void)writeDataPoint:(NSDictionary *)data {
    [self.device write:data withSN:0];
    //[self.device isBind];
}

#pragma mark - event
- (void)onBack {
    //[self.device setSubscribe:NO];
    _device.delegate = nil;
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) labelTouchUpInside:(UITapGestureRecognizer *)recognizer{
   
    [_alertView4 show];
}

//处理弹出框
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    switch (alertView.tag) {
        case 0:
            if (buttonIndex == 1) {
                CGFloat value=100.0f;
                NSDictionary *data = @{MONA_FILTER_1_LIFE:@(value)};
                [self writeDataPoint:data];
            }
            break;
        case 1:
            if (buttonIndex == 1) {
                CGFloat value=100.0f;
                NSDictionary *data = @{MONA_FILTER_2_LIFE:@(value)};
                [self writeDataPoint:data];
            }
            break;
        case 3:
            if (buttonIndex == 1) {
                CGFloat value=1.0f;
                NSDictionary *data = @{MONA_FACTORY_RESET:@(value)};
                [self writeDataPoint:data];
            }
            break;
        case 4:
            if (buttonIndex == 1) {
                
            }
            break;
        default:
            break;
    }
}



//按钮点击操作
//消除顶部报警
- (IBAction)BA_cancle:(id)sender {
    switch (top_mes_num) {
        case 1:
        {
            CGFloat value=0.0f;
            NSDictionary *data = @{MONA_RAW_WATER_TEMP_ALARM:@(value)};
            [self writeDataPoint:data];
        }
            break;
        case 2:
        {
            CGFloat value=0.0f;
            NSDictionary *data = @{MONA_WATER_HIGH_ALARM:@(value)};
            [self writeDataPoint:data];
        }
            break;
        case 3:
        {
            CGFloat value=0.0f;
            NSDictionary *data = @{MONA_WATER_LACK_ALARM:@(value)};
            [self writeDataPoint:data];
        }
            break;
        case 4:
        {
            CGFloat value=0.0f;
            NSDictionary *data = @{MONA_WATER_POOR_ALARM:@(value)};
            [self writeDataPoint:data];
        }
            break;
            
        default:
            break;
    }
}

//显示恢复滤芯1对话框
- (IBAction)BA_reset_filter1:(id)sender {
    if (ison) {
        [_alertView0 show];
    }else{
        [self.view makeToast:@"请开机"];
    }
}

//显示恢复滤芯2对话框
- (IBAction)BA_reset_filter2:(id)sender {
    if (ison) {
        [_alertView1 show];
    }else{
       [self.view makeToast:@"请开机"];
    }
    
}

//恢复出厂设置
- (IBAction)BA_button1:(id)sender {
    if (ison) {
        [_alertView3 show];
    }else{
        [self.view makeToast:@"请开机"];
    }
    
}

//冲洗
- (IBAction)BA_button2:(id)sender {
    
    if (ison) {
        if (isfull) {
            [_alertView2 show];
        }else{
            if (iswash) {
                CGFloat value=0.0f;
                NSDictionary *data = @{MONA_FLUSH_SWITCH:@(value)};
                [self writeDataPoint:data];
            }else{
                CGFloat value=1.0f;
                NSDictionary *data = @{MONA_FLUSH_SWITCH:@(value)};
                [self writeDataPoint:data];
            }
            
        }
    }else{
        [self.view makeToast:@"请开机"];
    }
}

//童锁
- (IBAction)BA_button3:(id)sender {
    
    if (ison) {
        if (ischild) {
            CGFloat value=0.0f;
            NSDictionary *data = @{MONA_CHILD_SECURITY_LOCK:@(value)};
            [self writeDataPoint:data];
        }else{
            CGFloat value=1.0f;
            NSDictionary *data = @{MONA_CHILD_SECURITY_LOCK:@(value)};
            [self writeDataPoint:data];
        }
    }else{
       [self.view makeToast:@"请开机"];
    }
    
}

//开关
- (IBAction)BA_button4:(id)sender {
    if (ison) {
        CGFloat value=0.0f;
        NSDictionary *data = @{MONA_SWITCH:@(value)};
        [self writeDataPoint:data];
    }else{
        CGFloat value=1.0f;
        NSDictionary *data = @{MONA_SWITCH:@(value)};
        [self writeDataPoint:data];
    }
}

@end

