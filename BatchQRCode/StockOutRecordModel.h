//
//  StockOutRecordModel.h
//  BatchQRCode
//
//  Created by 方景琦 on 2017/7/3.
//  Copyright © 2017年 miracle. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface StockOutRecordModel : NSObject<NSCoding>

@property(nonatomic,copy)NSString *mac;
@property(nonatomic,copy)NSString *stockOutDate;
@property(nonatomic,copy)NSString *organizationName;

@property(nonatomic,copy)NSString *result;

@end
