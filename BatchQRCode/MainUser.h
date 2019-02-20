//
//  MainUser.h
//  BatchQRCode
//
//  Created by 方景琦 on 2017/6/29.
//  Copyright © 2017年 miracle. All rights reserved.
//

#import <Foundation/Foundation.h>


#define MAIN_USER  @"MainUserInfo"


@interface MainUser : NSObject

@property (nonatomic, copy) NSString  *user_id;//用户唯一id

@property (nonatomic, copy) NSString *username;//用户名

@property (nonatomic,copy) NSString *nickname;//用户昵称

@property (nonatomic, copy) NSString *avatar;//头像

@property (nonatomic, assign) int age;//年纪

@property (nonatomic, copy) NSString *birthday;//生日

@property (nonatomic, assign) int height;//身高

@property (nonatomic, assign) int weight;//体重

@property (nonatomic, assign) int parent_uid;//父用户id

@property (nonatomic, copy) NSString *phone;//手机号码

@property (nonatomic, copy) NSString *sex;//性别  M:男,F:女,O:保密

@property(nonatomic,copy)NSString *remark;//备注

@property(nonatomic,copy)NSString *subUser;//是否是子用户(0代表是主用户,1代表是子用户)

@property(nonatomic,copy)NSString *pushAlias;//推送别名

@property(nonatomic,copy)NSString *userOrgCode;//用户所属组织机构代码

@property(nonatomic,copy)NSString *userSerialNum;//用户所属组织机构序列

@end





