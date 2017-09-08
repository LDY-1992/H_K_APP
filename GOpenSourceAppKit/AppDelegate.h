//
//  AppDelegate.h
//  GBOSA
//
//  Created by Zono on 16/3/22.
//  Copyright © 2016年 Gizwits. All rights reserved.
//

#import <UIKit/UIKit.h>

#define APP_ID  [GosCommon sharedInstance].appID
#define APP_SECRET  [GosCommon sharedInstance].appSecret

#define TENCENT_APP_ID [GosCommon sharedInstance].tencentAppID

#define WECHAT_APP_ID [GosCommon sharedInstance].wechatAppID
#define WECHAT_APP_SECRET [GosCommon sharedInstance].wechatAppSecret

#define PUSH_TYPE [GosCommon sharedInstance].pushType
#define JPUSH_APP_KEY [GosCommon sharedInstance].jpushAppKey
#define BPUSH_API_KEY [GosCommon sharedInstance].bpushAppKey

//产品KEY和Product_name
#define PRODUCT_KEY_MO @"241b6c897bb7469ea1b6180142b8b59c" //摩纳净水
#define NAME2       @"反渗透净水机"
#define NAME2_MODE     @"HKWT_RO50A"

#define PRODUCT_KEY_K19 @"c36689011a5f4c5f8081e0f83cc64fd8"    //
#define NAME1       @"空气净化器"
#define NAME1_MODE     @"HKJ_A600X6"

#define PRODUCT_KEY_K18 @"102bfdb2428341d3ba1fdfb169f69ca2"    //
#define NAME3       @"反渗透净水机K18"
#define NAME3_MODE     @"反渗透净水机K18"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (assign, nonatomic, readonly) BOOL isBackground;

@end

