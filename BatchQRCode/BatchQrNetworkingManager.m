//
//  BatchQrNetworkingManager.m
//  BatchQRCode
//
//  Created by 方景琦 on 2017/6/21.
//  Copyright © 2017年 miracle. All rights reserved.
//

#import "BatchQrNetworkingManager.h"

#import "TJHApiManager.h"


//识别组织机构的唯一标示(用来分别用户和设备的所属组织)
#define ORGNIZATION_CODE    @"0"//此标示代表所属苏仁总部
#define APPORGCODE          @"appOrgCode"
#define SERIAL_NUMBER       @"MIS0812778904"
#define APPSERIALNUM        @"appSerialNum"



@implementation BatchQrNetworkingManager

+ (BatchQrNetworkingManager *)shareHTTPService
{
    static BatchQrNetworkingManager *httpService;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        httpService = [[self alloc] init];
    });
    return httpService;
}



- (void)loginWithParaId:(NSString *)paraId paraPsw:(NSString *)psw success:(succeeBlock)result errorresult:(errorBlock)errorresult{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    dict[@"username"] = paraId;
    long timestamp = [NSDate date].timeIntervalSince1970;
    dict[@"timestamp"] = @(timestamp);
    NSString *str = [NSString stringWithFormat:@"%@%@%ldapp", paraId, [psw md5String], timestamp];
    NSString *token = [str md5String];
    dict[@"token"] = token;
    
    dict[@"type"] = @(0);
    
    //组织识别码
    [dict setObject:ORGNIZATION_CODE forKey:APPORGCODE];
    [dict setObject:SERIAL_NUMBER forKey:APPSERIALNUM];
    
    
    [RetouchNetworking postWithUrl:TJHAPIMANAGER.API_login params:dict progressBlock:^(int64_t bytesRead, int64_t totalBytes) {
        
    } successBlock:^(id response) {
        result(response);
    } failBlock:^(NSError *error) {
        errorresult(error);
    }];
}


-(void)getDeviceDetailInfoInDataBaseWithDevicesString:(NSString *)devciesString success:(succeeBlock)result errorresult:(errorBlock)errorresult{
    
    NSDictionary *dic = @{@"macs":devciesString};
    
    [RetouchNetworking postWithUrl:TJHAPIMANAGER.API_deviceDetailInfo params:dic progressBlock:^(int64_t bytesRead, int64_t totalBytes) {
        
    } successBlock:^(id response) {
        result(response);
    } failBlock:^(NSError *error) {
        errorresult(error);
    }];
}


-(void)getAllOrganizationForDistributionSuccess:(succeeBlock)result errorresult:(errorBlock)errorresult{

    [RetouchNetworking postWithUrl:TJHAPIMANAGER.API_allOrganization params:nil progressBlock:^(int64_t bytesRead, int64_t totalBytes) {
        
    } successBlock:^(id response) {
        result(response);
    } failBlock:^(NSError *error) {
        errorresult(error);
    }];
}


-(void)devicesRelateOtherOrganizationWithMacString:(NSString *)macString organizationID:(int )organizationID success:(succeeBlock)result errorresult:(errorBlock)errorresult{
    
    NSDictionary *dic = @{@"macs":macString,
                          @"orgId":[NSNumber numberWithInt:organizationID]};
    
    [RetouchNetworking postWithUrl:TJHAPIMANAGER.API_relateOtherOrganization params:dic progressBlock:^(int64_t bytesRead, int64_t totalBytes) {
        
    } successBlock:^(id response) {
        result(response);
    } failBlock:^(NSError *error) {
        errorresult(error);
    }];

}


@end
