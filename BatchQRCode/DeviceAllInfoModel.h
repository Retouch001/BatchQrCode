//
//  DeviceAllInfoModel.h
//  BatchQRCode
//
//  Created by 方景琦 on 2017/6/28.
//  Copyright © 2017年 miracle. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeviceAllInfoModel : NSObject

@property (nonatomic, assign) BOOL exist;
@property (nonatomic, copy) NSString *mac;
@property (nonatomic, copy) NSString *serverName;
@property (nonatomic, copy) NSString *port;
@property (nonatomic, copy) NSString *bedBind;
@property (nonatomic, copy) NSString *bindUser;
@property (nonatomic, copy) NSString *usedUser;
@property (nonatomic, copy) NSString *deviceType;
@property (nonatomic, copy) NSString *organization;

@end
