//
//  GizDeviceController.m
//  GBOSA
//
//  Created by Zono on 16/5/6.
//  Copyright © 2016年 Gizwits. All rights reserved.
//

#import "DeviceController.h"
#import "GizLog.h"

#import "GosCommon.h"

@interface DeviceController () {
    
    UIAlertView *_alertView;
    MBProgressHUD *hud;
    int rank_open,rank_lock,rank_mode,rank_fun,rank_time;
}
@property (nonatomic,retain) NSArray *timeArray;//存储时间数组
@property (readonly, nonatomic) GizWifiDevice *device;

@end

@implementation DeviceController

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
    [self init_view_data];
}

- (void) init_view_data{
    rank_open =rank_lock=rank_mode=rank_fun=rank_time=-1;
    self.timeArray = @[@"0:00",@"1:00",@"2:00",@"3:00",@"4:00",@"5:00",@"6:00",@"7:00",@"8:00",@"9:00",@"10:00",@"11:00",@"12:00",@"13:00",@"14:00",@"15:00",@"16:00",@"17:00",@"18:00",@"19:00",@"20:00",@"21:00",@"22:00",@"23:00"];
    self.Pic_time.dataSource = self;
    self.Pic_time.delegate=self;
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
    //    [remainTimer invalidate];
    //    remainTimer = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)menuBtnPressed {
    UIActionSheet *actionSheet = nil;
    if (self.device.isLAN) {
        actionSheet = [[UIActionSheet alloc]
                       initWithTitle:nil
                       delegate:self
                       cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                       destructiveButtonTitle:nil
                       otherButtonTitles:@"定时开机", NSLocalizedString(@"get device hardware info", nil), NSLocalizedString(@"set device info", nil),nil];
    }
    else {
        actionSheet = [[UIActionSheet alloc]
                       initWithTitle:nil
                       delegate:self
                       cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                       destructiveButtonTitle:nil
                       otherButtonTitles:@"定时开机", NSLocalizedString(@"set device info", nil), nil];
    }
    
    actionSheet.actionSheetStyle = UIBarStyleBlackTranslucent;
    [actionSheet showInView:self.view];
}

#pragma mark - actionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        //[MBProgressHUD showHUDAddedTo:self.view animated:YES];
        //[self.device getDeviceStatus];
        [self.V_picker setHidden:NO];
    }else if (buttonIndex == 1 && self.device.isLAN) {
        [self.device getHardwareInfo];
    }else if ((buttonIndex == 1 && !self.device.isLAN) || (buttonIndex == 2 && self.device.isLAN)){
        //        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"tip", nil) message:@"暂不支持" delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil, nil] show];
        UIAlertView *customAlertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"set alias and remark", nil) message:nil delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) otherButtonTitles:NSLocalizedString(@"OK", nil), nil];
        
        [customAlertView setAlertViewStyle:UIAlertViewStyleLoginAndPasswordInput];
        
        UITextField *aliasField = [customAlertView textFieldAtIndex:0];
        aliasField.placeholder = NSLocalizedString(@"input alias", nil);
        aliasField.text = self.device.alias;
        
        UITextField *remarkField = [customAlertView textFieldAtIndex:1];
        [remarkField setSecureTextEntry:NO];
        remarkField.placeholder = NSLocalizedString(@"input remark", nil);
        remarkField.text = self.device.remark;
        
        [customAlertView show];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == alertView.firstOtherButtonIndex) {
        UITextField *aliasField = [alertView textFieldAtIndex:0];
        UITextField *remarkField = [alertView textFieldAtIndex:1];
        [aliasField resignFirstResponder];
        [remarkField resignFirstResponder];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self.device setCustomInfo:remarkField.text alias:aliasField.text];
    }
}

- (void)device:(GizWifiDevice *)device didSetCustomInfo:(NSError *)result {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    if (result.code == GIZ_SDK_SUCCESS) {
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"tip", nil) message:NSLocalizedString(@"set successful", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil, nil] show];
        //        [self toast:NSLocalizedString(@"success", nil)];
    }
    else {
        NSString *info = [NSString stringWithFormat:@"%@\n%@ - %@", NSLocalizedString(@"set failed", nil), @(result.code), [result.userInfo objectForKey:@"NSLocalizedDescription"]];
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"tip", nil) message:info delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil, nil] show];
        //        [self toast:info];
    }
}

- (void)device:(GizWifiDevice *)device didGetHardwareInfo:(NSError *)result hardwareInfo:(NSDictionary *)hardwareInfo {
    NSString *hardWareInfo = [NSString stringWithFormat:@"WiFi Hardware Version: %@,\nWiFi Software Version: %@,\nFirmware Id: %@,\nFirmware Version: %@,\nMCU Hardware Version: %@,\nMCU Software Version: %@,\nProduct Key: %@,\nDevice ID: %@,\nDevice IP: %@,\nDevice MAC: %@"
                              , [hardwareInfo valueForKey:@"wifiHardVersion"]
                              , [hardwareInfo valueForKey:@"wifiSoftVersion"]
                              , [hardwareInfo valueForKey:@"wifiFirmwareId"]
                              , [hardwareInfo valueForKey:@"wifiFirmwareVer"]
                              , [hardwareInfo valueForKey:@"mcuHardVersion"]
                              , [hardwareInfo valueForKey:@"mcuSoftVersion"]
                              , [hardwareInfo valueForKey:@"productKey"]
                              , self.device.did, self.device.ipAddress, self.device.macAddress];
    dispatch_async(dispatch_get_main_queue(), ^{
        _alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"device hardware info", nil) message:hardWareInfo delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil];
        [_alertView show];
    });
}

#pragma mark - GizWifiDeviceDelegate
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
    NSDictionary *_alerts = [data valueForKey:@"alerts"];
    NSDictionary *_data   = [data valueForKey:@"data"];
    NSDictionary *_faults = [data valueForKey:@"faults"];
    if (!_data || !_alerts || !_faults || _data.count==0 || _alerts.count==0 || _faults.count==0) {
        return;
    }
    
    NSLog(@"_alerts=%@",_alerts);
    NSLog(@"data=%@",_data);
    NSLog(@"_faults=%@",_faults);
    
    NSString  *rec_alert_filter     =[_alerts valueForKey:POINT_NAME_ALERT_FILTER_LIFE];
    
    NSString  *rec_switch           =[_data valueForKey:POINT_NAME_SWITCH];
    NSString  *rec_wind             =[_data valueForKey:POINT_NAME_WIND_VELOCITY];
    NSString  *rec_lock             =[_data valueForKey:POINT_NAME_CHILD_SECURITY_LOCK];
    NSString  *rec_pm               =[_data valueForKey:POINT_NAME_PM25_AIR_QUALITY];
    NSString  *rec_filter_life      =[_data valueForKey:POINT_NAME_FILTER_LIFE];
    NSString  *rec_time_off         =[_data valueForKey:POINT_NAME_TIMING_OFF];
    NSString  *rec_mode             =[_data valueForKey:POINT_NAME_MODE_TYPE];
    NSString  *rec_time_on          =[_data valueForKey:POINT_NAME_TIMING_ON];
    
    NSString  *rec_fault_motor      =[_faults valueForKey:POINT_NAME_FAULT_MOTOR];
    NSString  *rec_fault_air        =[_faults valueForKey:POINT_NAME_FAULT_AIR_SENSORS];
    
    
    
    //滤芯寿命报警
    NSInteger ns1=[rec_alert_filter integerValue];
    if (ns1==1) {
        [self.I_filter setHidden:YES];
        [self.L_filter_num setHidden:YES];
        [self.I_filter_warn setHidden:NO];
    }else{
        [self.I_filter setHidden:NO];
        [self.L_filter_num setHidden:NO];
        [self.I_filter_warn setHidden:YES];
    }
    
    //开关状态
    NSInteger ns2=[rec_switch integerValue];
    if (ns2==0) {
        NSLog(@"关机状态");
        rank_open=0;
        [self.V_close setHidden:NO];
    }else{
        NSLog(@"开机状态");
        rank_open=1;
        [self.V_close setHidden:YES];
    }
    
    //更新模式
    NSInteger ns_mode=[rec_mode integerValue];
    if (ns_mode==0) {
        rank_mode=0;
        [self.I_mode1 setImage:[UIImage imageNamed:@"b8_mode1_off.png"]];
        [self.I_mode2 setImage:[UIImage imageNamed:@"b8_mode2_off.png"]];
    }else if (ns_mode==1){
        rank_mode=1;
        [self.I_mode1 setImage:[UIImage imageNamed:@"b8_mode1_on.png"]];
        [self.I_mode2 setImage:[UIImage imageNamed:@"b8_mode2_off.png"]];
    }else if (ns_mode==2){
        rank_mode=2;
        [self.I_mode1 setImage:[UIImage imageNamed:@"b8_mode1_off.png"]];
        [self.I_mode2 setImage:[UIImage imageNamed:@"b8_mode2_on.png"]];
    }
    
    //更新风速
    NSInteger ns_wind=[rec_wind integerValue];
    if (ns_wind==0) {
        rank_fun=0;
        [self Updata_fun:1];
    }else if (ns_wind==1) {
        rank_fun=1;
        [self Updata_fun:2];
    }else if (ns_wind==2) {
        rank_fun=2;
        [self Updata_fun:3];
    }else if (ns_wind==3) {
        rank_fun=3;
        [self Updata_fun:4];
    }
    
    //更新童锁
    NSInteger ns3=[rec_lock integerValue];
    if (ns3==0) {
        rank_lock=0;
        [self.B_lock setBackgroundImage:[UIImage imageNamed:@"b8_lock_off.png"] forState:UIControlStateNormal];
    }else{
        rank_lock=1;
        [self.B_lock setBackgroundImage:[UIImage imageNamed:@"b8_lock_on.png"] forState:UIControlStateNormal];
    }
    
    //更新PM2.5值
    NSInteger ns4=[rec_pm integerValue];
    if (ns4<=9 && ns4>=0) {
        [self Updata_pm:self.I_pm1 with:0];
        [self Updata_pm:self.I_pm2 with:0];
        [self Updata_pm:self.I_pm3 with:ns4];
    }else if (ns4>=10 && ns4<=99){
        NSInteger n2=ns4/10;
        NSInteger n3=ns4-n2*10;
        [self Updata_pm:self.I_pm1 with:0];
        [self Updata_pm:self.I_pm2 with:n2];
        [self Updata_pm:self.I_pm3 with:n3];
    }else{
        NSInteger n1=ns4/100;
        NSInteger n2=(ns4-n1*100)/10;
        NSInteger n3=ns4-n1*100-n2*10;
        [self Updata_pm:self.I_pm1 with:n1];
        [self Updata_pm:self.I_pm2 with:n2];
        [self Updata_pm:self.I_pm3 with:n3];
    }
    
    //更新滤芯寿命
    NSInteger ns5=[rec_filter_life integerValue];
    NSString *filter_num=[NSString stringWithFormat:@"%ld%%", ns5];
    self.L_filter_num.text=filter_num;
    
    //定时关机
    NSInteger ns_time=[rec_time_off integerValue];
    if (ns_time==0) {
        rank_time=0;
        [self Updata_time:0];
    }else if (ns_time==1){
        rank_time=1;
        [self Updata_time:1];
    }else if (ns_time==2){
        rank_time=2;
        [self Updata_time:2];
    }else if (ns_time==3){
        rank_time=3;
        [self Updata_time:3];
    }else if (ns_time==4){
        rank_time=4;
        [self Updata_time:4];
    }
    
    //定时开机
    NSInteger ns6=[rec_time_on integerValue];
    //设备故障
    NSInteger ns7=[rec_fault_air integerValue];
    NSInteger ns8=[rec_fault_motor integerValue];
    if (ns7==1 || ns8==1) {
        if (ns7==1 && ns8==0) {
            [self toast:@"空气传感器故障"];
        }else if (ns7==0 && ns8==1){
            [self toast:@"电机故障"];
        }else{
            [self toast:@"空气传感器和电机故障"];
        }
        
    }
}

- (void)device:(GizWifiDevice *)device didUpdateNetStatus:(GizWifiDeviceNetStatus)netStatus {
    if (netStatus == GizDeviceOffline || netStatus == GizDeviceUnavailable) {
        GIZ_LOG_BIZ("device_notify_disconnected", "success", "device notify disconnected, device mac is %s, did is %s, LAN is %s", self.device.macAddress.UTF8String, self.device.did.UTF8String, self.device.isLAN?"true":"false");
        [_alertView dismissWithClickedButtonIndex:0 animated:YES];
        _alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"连接已断开" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [_alertView show];
        [self performSelector:@selector(onBack) withObject:nil afterDelay:0.5];
    }
}

#pragma mark - tool

- (void)Updata_pm:(UIImageView *)view with:(NSInteger)n{
    switch (n) {
        case 0:
            [view setImage:[UIImage imageNamed:@"b8_all_b0.png"]];
            break;
        case 1:
            [view setImage:[UIImage imageNamed:@"b8_all_b1.png"]];
            break;
        case 2:
            [view setImage:[UIImage imageNamed:@"b8_all_b2.png"]];
            break;
        case 3:
            [view setImage:[UIImage imageNamed:@"b8_all_b3.png"]];
            break;
        case 4:
            [view setImage:[UIImage imageNamed:@"b8_all_b4.png"]];
            break;
        case 5:
            [view setImage:[UIImage imageNamed:@"b8_all_b5.png"]];
            break;
        case 6:
            [view setImage:[UIImage imageNamed:@"b8_all_b6.png"]];
            break;
        case 7:
            [view setImage:[UIImage imageNamed:@"b8_all_b7.png"]];
            break;
        case 8:
            [view setImage:[UIImage imageNamed:@"b8_all_b8.png"]];
            break;
        case 9:
            [view setImage:[UIImage imageNamed:@"b8_all_b9.png"]];
            break;
        default:
            break;
    }
}

- (void)Updata_fun:(int)n{
    switch (n) {
        case 1:
            [self.I_fun1 setImage:[UIImage imageNamed:@"b8_fun1_on.png"]];
            [self.I_fun2 setImage:[UIImage imageNamed:@"b8_fun2_off.png"]];
            [self.I_fun3 setImage:[UIImage imageNamed:@"b8_fun3_off.png"]];
            [self.I_fun4 setImage:[UIImage imageNamed:@"b8_fun4_off.png"]];
            break;
        case 2:
            [self.I_fun1 setImage:[UIImage imageNamed:@"b8_fun1_off.png"]];
            [self.I_fun2 setImage:[UIImage imageNamed:@"b8_fun2_on.png"]];
            [self.I_fun3 setImage:[UIImage imageNamed:@"b8_fun3_off.png"]];
            [self.I_fun4 setImage:[UIImage imageNamed:@"b8_fun4_off.png"]];
            break;
        case 3:
            [self.I_fun1 setImage:[UIImage imageNamed:@"b8_fun1_off.png"]];
            [self.I_fun2 setImage:[UIImage imageNamed:@"b8_fun2_off.png"]];
            [self.I_fun3 setImage:[UIImage imageNamed:@"b8_fun3_on.png"]];
            [self.I_fun4 setImage:[UIImage imageNamed:@"b8_fun4_off.png"]];
            break;
        case 4:
            [self.I_fun1 setImage:[UIImage imageNamed:@"b8_fun1_off.png"]];
            [self.I_fun2 setImage:[UIImage imageNamed:@"b8_fun2_off.png"]];
            [self.I_fun3 setImage:[UIImage imageNamed:@"b8_fun3_off.png"]];
            [self.I_fun4 setImage:[UIImage imageNamed:@"b8_fun4_on.png"]];
            break;
        default:
            break;
    }
}

- (void)Updata_time:(int)n{
    switch (n) {
        case 0:
            [self.I_time1 setImage:[UIImage imageNamed:@"b8_time1_off.png"]];
            [self.I_time2 setImage:[UIImage imageNamed:@"b8_time2_off.png"]];
            [self.I_time3 setImage:[UIImage imageNamed:@"b8_time3_off.png"]];
            [self.I_time4 setImage:[UIImage imageNamed:@"b8_time4_off.png"]];
            break;
        case 1:
            [self.I_time1 setImage:[UIImage imageNamed:@"b8_time1_on.png"]];
            [self.I_time2 setImage:[UIImage imageNamed:@"b8_time2_off.png"]];
            [self.I_time3 setImage:[UIImage imageNamed:@"b8_time3_off.png"]];
            [self.I_time4 setImage:[UIImage imageNamed:@"b8_time4_off.png"]];
            break;
        case 2:
            [self.I_time1 setImage:[UIImage imageNamed:@"b8_time1_off.png"]];
            [self.I_time2 setImage:[UIImage imageNamed:@"b8_time2_on.png"]];
            [self.I_time3 setImage:[UIImage imageNamed:@"b8_time3_off.png"]];
            [self.I_time4 setImage:[UIImage imageNamed:@"b8_time4_off.png"]];
            break;
        case 3:
            [self.I_time1 setImage:[UIImage imageNamed:@"b8_time1_off.png"]];
            [self.I_time2 setImage:[UIImage imageNamed:@"b8_time2_off.png"]];
            [self.I_time3 setImage:[UIImage imageNamed:@"b8_time3_on.png"]];
            [self.I_time4 setImage:[UIImage imageNamed:@"b8_time4_off.png"]];
            break;
        case 4:
            [self.I_time1 setImage:[UIImage imageNamed:@"b8_time1_off.png"]];
            [self.I_time2 setImage:[UIImage imageNamed:@"b8_time2_off.png"]];
            [self.I_time3 setImage:[UIImage imageNamed:@"b8_time3_off.png"]];
            [self.I_time4 setImage:[UIImage imageNamed:@"b8_time4_on.png"]];
            break;
        default:
            break;
    }
}

- (void)toast:(NSString *)strToast {
    //弹出一段字符，最多不超过3行
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:strToast delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
    [alertView show];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        sleep(3);
        dispatch_async(dispatch_get_main_queue(), ^{
            [alertView dismissWithClickedButtonIndex:alertView.cancelButtonIndex animated:YES];
        });
    });
}
#pragma mark - datapoint_wright_read
- (void)writeDataPoint:(NSDictionary *)data {
    [self.device write:data withSN:0];
    //[self.device getDeviceStatus];
}


#pragma mark - event
- (void)onBack {
    //[self.device setSubscribe:NO];
    _device.delegate = nil;
    [self.navigationController popViewControllerAnimated:YES];
}

//点击开机键
- (IBAction)BA_open:(id)sender {
    if (rank_open==0) {
        CGFloat value=1.0f;
        NSDictionary *data = @{POINT_NAME_SWITCH:@(value)};
        [self writeDataPoint:data];
    }
}

//点击关机键
- (IBAction)BA_close:(id)sender {
    if (rank_open==1) {
        CGFloat value=0.0f;
        NSDictionary *data = @{POINT_NAME_SWITCH:@(value)};
        [self writeDataPoint:data];
    }
}

//点击童锁键
- (IBAction)BA_lock:(id)sender {
    if (rank_lock==0) {
        CGFloat value=1.0f;
        NSDictionary *data = @{POINT_NAME_CHILD_SECURITY_LOCK:@(value)};
        [self writeDataPoint:data];
    }else{
        CGFloat value=0.0f;
        NSDictionary *data = @{POINT_NAME_CHILD_SECURITY_LOCK:@(value)};
        [self writeDataPoint:data];
    }
}

//点击模式键
- (IBAction)BA_mode:(id)sender {
    switch (rank_mode) {
        case 0:{
            CGFloat value=1.0f;
            NSDictionary *data = @{POINT_NAME_MODE_TYPE:@(value)};
            [self writeDataPoint:data];
            }
            break;
        case 1:{
            CGFloat value=2.0f;
            NSDictionary *data = @{POINT_NAME_MODE_TYPE:@(value)};
            [self writeDataPoint:data];
            }
            break;
        case 2:{
            CGFloat value=1.0f;
            NSDictionary *data = @{POINT_NAME_MODE_TYPE:@(value)};
            [self writeDataPoint:data];
            }
            break;
        default:
            break;
    }
}

//点击档位键
- (IBAction)BA_fun:(id)sender {
    switch (rank_fun) {
        case 0:
        {
            CGFloat value=1.0f;
            NSDictionary *data = @{POINT_NAME_WIND_VELOCITY:@(value)};
            [self writeDataPoint:data];
        }
            break;
        case 1:
        {
            CGFloat value=2.0f;
            NSDictionary *data = @{POINT_NAME_WIND_VELOCITY:@(value)};
            [self writeDataPoint:data];
        }
            break;
        case 2:
        {
            CGFloat value=3.0f;
            NSDictionary *data = @{POINT_NAME_WIND_VELOCITY:@(value)};
            [self writeDataPoint:data];
        }
            break;
        case 3:
        {
            CGFloat value=0.0f;
            NSDictionary *data = @{POINT_NAME_WIND_VELOCITY:@(value)};
            [self writeDataPoint:data];
        }
            break;
        default:
            break;
    }
}

//点击定时关机键
- (IBAction)BA_time:(id)sender {
    switch (rank_time) {
        case 0:
        {
            CGFloat value=1.0f;
            NSDictionary *data = @{POINT_NAME_TIMING_OFF:@(value)};
            [self writeDataPoint:data];
        }
            break;
        case 1:
        {
            CGFloat value=2.0f;
            NSDictionary *data = @{POINT_NAME_TIMING_OFF:@(value)};
            [self writeDataPoint:data];
        }
            break;
        case 2:
        {
            CGFloat value=3.0f;
            NSDictionary *data = @{POINT_NAME_TIMING_OFF:@(value)};
            [self writeDataPoint:data];
        }
            break;
        case 3:
        {
            CGFloat value=4.0f;
            NSDictionary *data = @{POINT_NAME_TIMING_OFF:@(value)};
            [self writeDataPoint:data];
        }
            break;
        case 4:
        {
            CGFloat value=0.0f;
            NSDictionary *data = @{POINT_NAME_TIMING_OFF:@(value)};
            [self writeDataPoint:data];
        }
            break;
        default:
            break;
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
        return self.timeArray.count;
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
        return self.timeArray[row];
    }
    return 0;
}
- (IBAction)Sw_change:(id)sender {
    if (self.Sw_repeat.on) {
        self.L_repeat.text=@"开启重复";
    }else{
        self.L_repeat.text=@"关闭重复";
    }
}
- (IBAction)time_on_ok:(id)sender {
    CGFloat ob=[self.Pic_time selectedRowInComponent:0];
    if (self.Sw_repeat.on) {
        CGFloat value=32.0f+ob;
        NSDictionary *data = @{POINT_NAME_TIMING_ON:@(value)};
        [self writeDataPoint:data];
    }else{ 
        NSDictionary *data = @{POINT_NAME_TIMING_ON:@(ob)};
        [self writeDataPoint:data];
    }
}

- (IBAction)time_on_cancel:(id)sender {
    [self.V_picker setHidden:YES];
}

- (IBAction)BA_close_time_on:(id)sender {
    CGFloat value=24.0f;
    NSDictionary *data = @{POINT_NAME_TIMING_ON:@(value)};
    [self writeDataPoint:data];
    [self.V_picker setHidden:YES];
}
@end
