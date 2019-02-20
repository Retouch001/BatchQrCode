//
//  FailDeviceModel.h
//  BatchQRCode
//
//  Created by 方景琦 on 2017/6/28.
//  Copyright © 2017年 miracle. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FailDeviceModel : NSObject

@property(nonatomic,assign)BOOL deviceExist;
@property(nonatomic,copy)NSString *mac;
@property(nonatomic,copy)NSString *result;

@end
