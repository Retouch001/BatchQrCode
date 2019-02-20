//
//  TJHApiManager.m
//  BatchQRCode
//
//  Created by 方景琦 on 2017/6/29.
//  Copyright © 2017年 miracle. All rights reserved.
//

#import "TJHApiManager.h"

@implementation TJHApiManager

+ (TJHApiManager *)shareTJHApiManager
{
    static TJHApiManager *httpService;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        httpService = [[self alloc] init];
        
        NSInteger appServcieCode = [[NSUserDefaults standardUserDefaults] integerForKey:APPSERVICEFIELDCODE];
        
        switch (appServcieCode) {
            case 1:
                
                httpService.appServiceBaseIP = appServiceDistribution;
                
                break;
                
            case 2:
                
                httpService.appServiceBaseIP = appServiceDevelopment;
                
                break;
                
            case 3:
                
                httpService.appServiceBaseIP = appServiceDistribution_AD_HOC;
                
                break;
                
            case 4:
                
                httpService.appServiceBaseIP = appServiceHAOWEI;
                
                break;
                
            case 5:
                
                httpService.appServiceBaseIP = appServiceMAPEI;
                
                break;
                
            case 6:
                
                httpService.appServiceBaseIP = appServiceFangjinqi;
                
                break;
                
            case 7:
                
                httpService.appServiceBaseIP = appServiceTest;
                
                break;
                
                
            default:
                
                httpService.appServiceBaseIP = appServiceDevelopment;
                
                break;
        }
    });
    return httpService;
}



-(NSString *)API_login{
    return [self.appServiceBaseIP stringByAppendingString:@"/user/login"];
}

-(NSString *)API_allOrganization{
    return [self.appServiceBaseIP stringByAppendingString:@"/organization/getOrganization"];
}

-(NSString *)API_deviceDetailInfo{
    return [self.appServiceBaseIP stringByAppendingString:@"/bindTips/getIpAndBindOrRel"];
}

-(NSString *)API_relateOtherOrganization{
    return [self.appServiceBaseIP stringByAppendingString:@"/device/relateOtherOrg"];
}

-(NSString *)API__USER_ICON_BASE_URL{
    return [self.appServiceBaseIP stringByAppendingString:@"/user/getAvatar?uid="];
}


@end
