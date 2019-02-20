//
//  TJHApiManager.h
//  BatchQRCode
//
//  Created by 方景琦 on 2017/6/29.
//  Copyright © 2017年 miracle. All rights reserved.
//

#import <Foundation/Foundation.h>

#define TJHAPIMANAGER [TJHApiManager shareTJHApiManager]



static NSString *const appServiceDistribution = @"http://117.78.49.136/appServer";

static NSString *const appServiceDevelopment = @"http://117.78.48.143/appServer";

static NSString *const appServiceDistribution_AD_HOC = @"http://112.64.32.206/appServer";

static NSString *const appServiceTest = @"http://117.78.48.140/appServer";

static NSString *const appServiceHAOWEI = @"http://192.168.8.106:8080/appServer";

static NSString *const appServiceMAPEI = @"http://192.168.8.224:8080/appServer";

static NSString *const appServiceFangjinqi = @"http://192.168.0.2:8080/appServer";



#define APPSERVICEFIELDCODE @"appServiceFieldCode"



typedef NS_ENUM(NSUInteger, IBREEZEEServiceBaseIP) {
    IBREEZEEServiceDistribution  =1 ,       //正式版
    IBREEZEEServiceDevelopment,             //开发
    IBREEZEEServiceDistribution_AD_HOC,     //仿真
    IBREEZEEServiceHAOWEI,                  //浩伟
    IBREEZEEServiceMAPEI,                   //马佩
    IBREEZEEServiceFANGJINQI,               //方景琦
    IBREEZEEServiceTest                     //测试
};



@interface TJHApiManager : NSObject


@property(nonatomic,copy)NSString *appServiceBaseIP;

@property(nonatomic,copy)NSString *API__USER_ICON_BASE_URL;

@property(nonatomic,copy)NSString *API_login;

@property(nonatomic,copy)NSString *API_deviceDetailInfo;

@property(nonatomic,copy)NSString *API_allOrganization;

@property(nonatomic,copy)NSString *API_relateOtherOrganization;



+ (TJHApiManager *)shareTJHApiManager;




@end
