//
//  StockOutRecordModel.m
//  BatchQRCode
//
//  Created by 方景琦 on 2017/7/3.
//  Copyright © 2017年 miracle. All rights reserved.
//

#import "StockOutRecordModel.h"


@implementation StockOutRecordModel


-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    return  [self modelInitWithCoder:aDecoder];
}


-(void)encodeWithCoder:(NSCoder *)aCoder{
    [self modelEncodeWithCoder:aCoder];
}


@end
