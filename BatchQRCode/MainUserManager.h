//
//  MainUserManager.h
//  BatchQRCode
//
//  Created by 方景琦 on 2017/6/29.
//  Copyright © 2017年 miracle. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MainUser.h"


#define MAINUSERINSTANCE [MainUserManager shareMainUserManager]


@interface MainUserManager : NSObject

@property(nonatomic,strong)MainUser *user;

+ (MainUserManager *)shareMainUserManager;


@end
