//
//  DeviceController_K18.m
//  GOpenSource_AppKit
//
//  Created by kingcom on 2017/6/29.
//  Copyright © 2017年 Gizwits. All rights reserved.
//

#import "DeviceController_K18.h"
#import "GizLog.h"

#import "GosCommon.h"
#import "Util.h"

//提示对话框
#import "ViewController_Alert.h"
#import "ViewController_Disconnect_Alert.h"
#import "ViewController_Reset_Alert.h"

@interface DeviceController_K18 ()
{
    MBProgressHUD *hud;
    UIAlertView *_alertView;
    bool isOn;
    NSDictionary *all_data;
    UIBarButtonItem *leftButton;
}
@property (readonly, nonatomic) GizWifiDevice *device;

@end

@implementation DeviceController_K18

- (id)initWithDevice:(GizWifiDevice *)device {
    self = [super init];
    if (self) {
        _device = device;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UIImage *image1=[UIImage imageNamed:@"icon_menu"];
    image1=[Util scaleToSize:image1 toSize:CGSizeMake(20, 20)];
    
    UIImage *image2=[UIImage imageNamed:@"icon_power"];
    image2=[Util scaleToSize:image2 toSize:CGSizeMake(20, 20)];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:image1 style:UIBarButtonItemStylePlain target:self action:@selector(menuBtnPressed)];
    
    leftButton=[[UIBarButtonItem alloc] initWithImage:image2 style:UIBarButtonItemStylePlain target:self action:@selector(power_off)];
    self.navigationItem.rightBarButtonItem = nil;
    
    //按钮圆角设置
    _btn_start_clean.layer.cornerRadius=5.0f;
    _btn_start_rinse.layer.cornerRadius=5.0f;
    
    isOn=false;
    
    UITapGestureRecognizer *tapGesturRecognizer1=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction1:)];
    [_image_filter_element1 addGestureRecognizer:tapGesturRecognizer1];
    _image_filter_element1.userInteractionEnabled=YES;
    
    UITapGestureRecognizer *tapGesturRecognizer2=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction2:)];
    [_image_filter_element2 addGestureRecognizer:tapGesturRecognizer2];
    _image_filter_element2.userInteractionEnabled=YES;
    
    UITapGestureRecognizer *tapGesturRecognizer3=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction3:)];
    [_image_filter_element3 addGestureRecognizer:tapGesturRecognizer3];
    _image_filter_element3.userInteractionEnabled=YES;
    
    UITapGestureRecognizer *tapGesturRecognizer4=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction4:)];
    [_image_filter_element4 addGestureRecognizer:tapGesturRecognizer4];
    _image_filter_element4.userInteractionEnabled=YES;
    
    UITapGestureRecognizer *tapGesturRecognizer5=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction5:)];
    [_image_filter_element5 addGestureRecognizer:tapGesturRecognizer5];
    _image_filter_element5.userInteractionEnabled=YES;
    
}

//滤芯点击事件
-(void)tapAction1:(id)tap
{
    [self sendFilterReset:1];
}

-(void)tapAction2:(id)tap
{
    [self sendFilterReset:2];
}

-(void)tapAction3:(id)tap
{
    [self sendFilterReset:3];
}

-(void)tapAction4:(id)tap
{
    [self sendFilterReset:4];
}

-(void)tapAction5:(id)tap
{
    [self sendFilterReset:5];
}

//处理 发送滤芯复位命令
-(void) sendFilterReset:(NSInteger)n{
    ViewController_Reset_Alert *reset_alert = [ViewController_Reset_Alert alloc];
    reset_alert.modalPresentationStyle=UIModalPresentationOverCurrentContext;
    [reset_alert setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    
    switch (n) {
        case 1:
        {
            if(all_data){
                NSNumber *rec_filter1 =[all_data valueForKey:K18_Filter_1_Life];
                NSInteger ns=[rec_filter1 integerValue];
                NSInteger x=(ns*100)/2160;
                NSString *n=@"类型：PP棉";
                NSString *t=[NSString stringWithFormat:@"时间：%ld小时",ns];
                NSString *l=[NSString stringWithFormat:@"寿命：%ld%%",x];
                NSString *s;
                if(ns<=(2160/7)){
                    s=@"状态：需要更换";
                }else{
                    s=@"状态：正常";
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    // UI更新代码
                    reset_alert.lable_1.text=n;
                    reset_alert.lable_2.text=t;
                    reset_alert.lable_3.text=l;
                    reset_alert.lable_4.text=s;
                });
            }
        }
            break;
        case 2:
        {
            if(all_data){
                NSNumber *rec_filter1 =[all_data valueForKey:K18_Filter_2_Life];
                NSInteger ns=[rec_filter1 integerValue];
                NSInteger x=(ns*100)/4320;
                NSString *n=@"类型：活性炭GAC";
                NSString *t=[NSString stringWithFormat:@"时间：%ld小时",ns];
                NSString *l=[NSString stringWithFormat:@"寿命：%ld%%",x];
                NSString *s;
                if(ns<=(4320/7)){
                    s=@"状态：需要更换";
                }else{
                    s=@"状态：正常";
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    // UI更新代码
                    reset_alert.lable_1.text=n;
                    reset_alert.lable_2.text=t;
                    reset_alert.lable_3.text=l;
                    reset_alert.lable_4.text=s;
                });
            }
        }
            break;
        case 3:
        {
            if(all_data){
                NSNumber *rec_filter1 =[all_data valueForKey:K18_Filter_3_Life];
                NSInteger ns=[rec_filter1 integerValue];
                NSInteger x=(ns*100)/4320;
                NSString *n=@"类型：活性炭GTO";
                NSString *t=[NSString stringWithFormat:@"时间：%ld小时",ns];
                NSString *l=[NSString stringWithFormat:@"寿命：%ld%%",x];
                NSString *s;
                if(ns<=(4320/7)){
                    s=@"状态：需要更换";
                }else{
                    s=@"状态：正常";
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    // UI更新代码
                    reset_alert.lable_1.text=n;
                    reset_alert.lable_2.text=t;
                    reset_alert.lable_3.text=l;
                    reset_alert.lable_4.text=s;
                });
            }
        }
            break;
        case 4:
        {
            if(all_data){
                NSNumber *rec_filter1 =[all_data valueForKey:K18_Filter_4_Life];
                NSInteger ns=[rec_filter1 integerValue];
                NSInteger x=(ns*100)/12960;
                NSString *n=@"类型：RO膜";
                NSString *t=[NSString stringWithFormat:@"时间：%ld小时",ns];
                NSString *l=[NSString stringWithFormat:@"寿命：%ld%%",x];
                NSString *s;
                if(ns<=(12960/7)){
                    s=@"状态：需要更换";
                }else{
                    s=@"状态：正常";
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    // UI更新代码
                    reset_alert.lable_1.text=n;
                    reset_alert.lable_2.text=t;
                    reset_alert.lable_3.text=l;
                    reset_alert.lable_4.text=s;
                });
            }
        }
            break;
        case 5:
        {
            if(all_data){
                NSNumber *rec_filter1 =[all_data valueForKey:K18_Filter_5_Life];
                NSInteger ns=[rec_filter1 integerValue];
                NSInteger x=(ns*100)/8640;
                NSString *n=@"类型：活性炭T33";
                NSString *t=[NSString stringWithFormat:@"时间：%ld小时",ns];
                NSString *l=[NSString stringWithFormat:@"寿命：%ld%%",x];
                NSString *s;
                if(ns<=(8640/7)){
                    s=@"状态：需要更换";
                }else{
                    s=@"状态：正常";
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    // UI更新代码
                    reset_alert.lable_1.text=n;
                    reset_alert.lable_2.text=t;
                    reset_alert.lable_3.text=l;
                    reset_alert.lable_4.text=s;
                });
            }
        }
            break;
            
        default:
            break;
    }
    
    [self presentViewController:reset_alert animated:YES completion:^{ }];
    [reset_alert Btn_touch:^(BOOL OnStatus) {
        [self dismissViewControllerAnimated:YES completion:nil];
        if(OnStatus){
            NSLog(@"点击复位");
            switch (n) {
                case 1:
                {
                    NSInteger value=2160;
                    NSDictionary *data = @{K18_Filter_1_Life:@(value)};
                    [self writeDataPoint:data];
                }
                    break;
                case 2:
                {
                    NSInteger value=4320;
                    NSDictionary *data = @{K18_Filter_2_Life:@(value)};
                    [self writeDataPoint:data];
                }
                    break;
                case 3:
                {
                    NSInteger value=4320;
                    NSDictionary *data = @{K18_Filter_3_Life:@(value)};
                    [self writeDataPoint:data];
                }
                    break;
                case 4:
                {
                    NSInteger value=12960;
                    NSDictionary *data = @{K18_Filter_4_Life:@(value)};
                    [self writeDataPoint:data];
                }
                    break;
                case 5:
                {
                    NSInteger value=8640;
                    NSDictionary *data = @{K18_Filter_5_Life:@(value)};
                    [self writeDataPoint:data];
                }
                    break;
                default:
                    break;
            }
        }
    }];
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
    //[self.device isBind];
    //[MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    GIZ_LOG_BIZ("device_control_page_hide", "success", "device control page is hiden");
    if (self.device.netStatus == GizDeviceControlled){
        [self.device getDeviceStatus:nil];
    }
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //    [remainTimer invalidate];
    //    remainTimer = nil;
}

-(void)power_off{
    
    ViewController_Alert *devCtrl = [ViewController_Alert alloc];
    devCtrl.modalPresentationStyle=UIModalPresentationOverCurrentContext;
    [devCtrl setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    [self presentViewController:devCtrl animated:YES completion:^{ }];
    [devCtrl Btn_touch:^(BOOL OnStatus) {
        [self dismissViewControllerAnimated:YES completion:nil];
        if(OnStatus){
            NSLog(@"点击确定");
            [self send_power_off];
        }
    }];
}

//关闭设备
-(void)send_power_off{
    CGFloat value=0.0f;
    NSDictionary *data = @{K18_Switch:@(value)};
    [self writeDataPoint:data];
}

//弹出更多选项
-(void)menuBtnPressed{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *back = [UIAlertAction actionWithTitle:@"返回列表" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self onBack];
    }];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"设置设备名称" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self Set_name];
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }];
    
    [alertController addAction:back];
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

#pragma mark - GizWifiDeviceDelegate
//设备状态改变
- (void)device:(GizWifiDevice *)device didUpdateNetStatus:(GizWifiDeviceNetStatus)netStatus {
    if (netStatus == GizDeviceOffline || netStatus == GizDeviceUnavailable) {
        GIZ_LOG_BIZ("device_notify_disconnected", "success", "device notify disconnected, device mac is %s, did is %s, LAN is %s", self.device.macAddress.UTF8String, self.device.did.UTF8String, self.device.isLAN?"true":"false");
        
        ViewController_Disconnect_Alert *devCtrl = [ViewController_Disconnect_Alert alloc];
        devCtrl.modalPresentationStyle=UIModalPresentationOverCurrentContext;
        [devCtrl setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
        [self presentViewController:devCtrl animated:YES completion:^{ }];
        [devCtrl Btn_touch:^(BOOL OnStatus) {
            [self dismissViewControllerAnimated:YES completion:nil];
            [self performSelector:@selector(onBack) withObject:nil afterDelay:0.5];
        }];
        
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
    all_data=_data;
    NSDictionary *_faults = [data valueForKey:@"faults"];
    if (!_data || _data.count==0 || !_faults || _faults.count==0) {
        return;
    }
    NSLog(@"data=%@",_data);
    NSLog(@"_faults=%@",_faults);
    
    //接收数据
    NSNumber *rec_switch              =[_data valueForKey:K18_Switch];
    NSInteger ns1=[rec_switch integerValue];
    
    NSNumber *rec_mode                =[_data valueForKey:K18_Mode];
    NSInteger ns2=[rec_mode integerValue];
    
    NSNumber *rec_tds0                =[_data valueForKey:K18_Tds0_Value];
    NSInteger ns3=[rec_tds0 integerValue];
    
    NSNumber *rec_tds1                =[_data valueForKey:K18_Tds1_Value];
    NSInteger ns4=[rec_tds1 integerValue];
    
    NSNumber *rec_flow                =[_data valueForKey:K18_Flow_Value];
    NSInteger ns5=[rec_flow integerValue];
    
    NSNumber *rec_filter1             =[_data valueForKey:K18_Filter_1_Life];
    NSInteger ns6=[rec_filter1 integerValue];
    
    NSNumber *rec_filter2             =[_data valueForKey:K18_Filter_2_Life];
    NSInteger ns7=[rec_filter2 integerValue];
    
    NSNumber *rec_filter3             =[_data valueForKey:K18_Filter_3_Life];
    NSInteger ns8=[rec_filter3 integerValue];
    
    NSNumber *rec_filter4             =[_data valueForKey:K18_Filter_4_Life];
    NSInteger ns9=[rec_filter4 integerValue];
    
    NSNumber *rec_filter5             =[_data valueForKey:K18_Filter_5_Life];
    NSInteger ns10=[rec_filter5 integerValue];
    
    //故障
    NSNumber *rec_fault               =[_faults valueForKey:K18_Device_Fault];
    NSInteger ns11=[rec_fault integerValue];
    
    //开机状态
    if(ns1==1){
        NSLog(@"进入开机状态");
        self.navigationItem.rightBarButtonItem = leftButton;
        isOn=true;
        [_view_power_off setHidden:YES];
        
        //设备运行模式
        switch (ns2) {
            case 0:
                _lable_device_status.textColor=[UIColor blackColor];
                _lable_device_status.text=@"运行良好";
                break;
            case 1:
                _lable_device_status.textColor=[UIColor blueColor];
                _lable_device_status.text=@"正在冲洗";
                break;
            case 2:
                _lable_device_status.textColor=[UIColor blueColor];
                _lable_device_status.text=@"正在净水";
                break;
            case 3:
                _lable_device_status.textColor=[UIColor blueColor];
                _lable_device_status.text=@"假日";
                break;
                
            default:
                break;
        }
        
        //自来水 TDS
        NSString *tab_str=[NSString stringWithFormat:@"自来水水质：%ld TDS",ns3];
        NSMutableAttributedString *str1 = [[NSMutableAttributedString alloc] initWithString:tab_str];
        [str1 addAttribute:NSForegroundColorAttributeName
                    value:[UIColor darkGrayColor]
                    range:NSMakeRange(0,6)];
        [str1 addAttribute:NSForegroundColorAttributeName
                     value:[UIColor blueColor]
                     range:NSMakeRange(6,tab_str.length-6)];
        [_lable_tap_water setAttributedText:str1];
        
        //过滤后 TDS
        NSString *filter_str=[NSString stringWithFormat:@"过滤后水质：%ld TDS",ns4];
        NSMutableAttributedString *str2 = [[NSMutableAttributedString alloc] initWithString:filter_str];
        [str2 addAttribute:NSForegroundColorAttributeName
                     value:[UIColor darkGrayColor]
                     range:NSMakeRange(0,6)];
        [str2 addAttribute:NSForegroundColorAttributeName
                     value:[UIColor blueColor]
                     range:NSMakeRange(6,filter_str.length-6)];
        [_lable_filter_water setAttributedText:str2];
        
        //流量
        NSString *flow_str=[NSString stringWithFormat:@"流量：%ld TDS",ns5];
        NSMutableAttributedString *str3 = [[NSMutableAttributedString alloc] initWithString:flow_str];
        [str3 addAttribute:NSForegroundColorAttributeName
                     value:[UIColor darkGrayColor]
                     range:NSMakeRange(0,3)];
        [str3 addAttribute:NSForegroundColorAttributeName
                     value:[UIColor blueColor]
                     range:NSMakeRange(3,flow_str.length-3)];
        [_lable_flow setAttributedText:str3];
        
        //滤芯1
        NSInteger nn=0;
        NSInteger l1=2160/7;
        if(ns6<=l1){
            _image_filter_element1.image=[UIImage imageNamed:@"failed_pp.png"];

        }else{
            _image_filter_element1.image=[UIImage imageNamed:@"normal_pp.png"];
            nn=nn+1;
        }
        
        //滤芯2
        NSInteger l2=4320/7;
        if(ns7<=l2){
            _image_filter_element2.image=[UIImage imageNamed:@"failed_gac.png"];
            
        }else{
            _image_filter_element2.image=[UIImage imageNamed:@"normal_gac.png"];
            nn=nn+1;
        }
        
        //滤芯3
        NSInteger l3=4320/7;
        if(ns8<=l3){
            _image_filter_element3.image=[UIImage imageNamed:@"failed_cto.png"];
            
        }else{
            _image_filter_element3.image=[UIImage imageNamed:@"normal_cto.png"];
            nn=nn+1;
        }
        
        //滤芯4
        NSInteger l4=12960/7;
        if(ns9<=l4){
            _image_filter_element4.image=[UIImage imageNamed:@"failed_ro.png"];
            
        }else{
            _image_filter_element4.image=[UIImage imageNamed:@"normal_ro.png"];
            nn=nn+1;
        }
        
        //滤芯5
        NSInteger l5=8640/7;
        if(ns10<=l5){
            _image_filter_element5.image=[UIImage imageNamed:@"failed_t33.png"];
            
        }else{
            _image_filter_element5.image=[UIImage imageNamed:@"normal_t33.png"];
            nn=nn+1;
            
        }
        
        if(nn==5){
            _lable_filter_status.text=@"正常";
            _lable_filter_status.textColor=[UIColor blackColor];
        }else{
            _lable_filter_status.text=@"需要更换";
            _lable_filter_status.textColor=[UIColor blueColor];
        }
        
    }
    //关机状态
    else{
        NSLog(@"进入关机状态");
        self.navigationItem.rightBarButtonItem = nil;
        isOn=false;
        [_view_power_off setHidden:NO];
    }
    
}

#pragma mark - datapoint_wright_read
- (void)writeDataPoint:(NSDictionary *)data {
    [self.device write:data withSN:0];
}

#pragma mark - event
- (void)onBack {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)BA_power_on:(id)sender {
    CGFloat value=1.0f;
    NSDictionary *data = @{K18_Switch:@(value)};
    [self writeDataPoint:data];
}
- (IBAction)BA_start_clean:(id)sender {
    CGFloat value=2.0f;
    NSDictionary *data = @{K18_Mode:@(value)};
    [self writeDataPoint:data];
}
- (IBAction)BA_start_rines:(id)sender {
    CGFloat value=1.0f;
    NSDictionary *data = @{K18_Mode:@(value)};
    [self writeDataPoint:data];
}
@end
