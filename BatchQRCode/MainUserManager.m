//
//  MainUserManager.m
//  BatchQRCode
//
//  Created by 方景琦 on 2017/6/29.
//  Copyright © 2017年 miracle. All rights reserved.
//

#import "MainUserManager.h"

@implementation MainUserManager

+ (MainUserManager *)shareMainUserManager{
    
    static MainUserManager *httpService;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        httpService = [[self alloc] init];
    });
    return httpService;
}


@end
