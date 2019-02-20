//
//  BatchQrNetworkingManager.h
//  BatchQRCode
//
//  Created by 方景琦 on 2017/6/21.
//  Copyright © 2017年 miracle. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "RetouchNetworking.h"
#import "RetouchNetworking+requestManager.h"

#define NETWORKINGMANAGER [BatchQrNetworkingManager shareHTTPService]


typedef void (^succeeBlock) (NSDictionary *dic);
typedef void (^errorBlock) (NSError *error);


@interface BatchQrNetworkingManager : NSObject


+ (BatchQrNetworkingManager *)shareHTTPService;



/**
 登录接口

 @param paraId 用户名
 @param psw 密码
 @param result 成功回调
 @param errorresult 失败回调
 */
- (void)loginWithParaId:(NSString *)paraId paraPsw:(NSString *)psw success:(succeeBlock)result errorresult:(errorBlock)errorresult;

/**
 获取设备的详细信息,包括设备的指向服务器,绑定者,使用者

 @param devciesString Mac地址
 @param result 成功回调
 @param errorresult 失败回调
 */
-(void)getDeviceDetailInfoInDataBaseWithDevicesString:(NSString *)devciesString success:(succeeBlock)result errorresult:(errorBlock)errorresult;



/**
 获取服务器中所有组织机构

 @param result 成功回调
 @param errorresult 失败回调
 */
-(void)getAllOrganizationForDistributionSuccess:(succeeBlock)result errorresult:(errorBlock)errorresult;



/**
 将设备数组统一指向到指定的组织机构下

 @param macString 所有设备mac拼接
 @param organizationID 组织机构
 @param result 成功回调
 @param errorresult 失败回调
 */
-(void)devicesRelateOtherOrganizationWithMacString:(NSString *)macString organizationID:(int )organizationID success:(succeeBlock)result errorresult:(errorBlock)errorresult;


@end
