//
//  RetouchNetworking+requestManager.h
//  网络层的封装
//
//  Created by 方景琦 on 2016/11/30.
//  Copyright © 2016年 iBreezeeWiFiDemo. All rights reserved.
//

#import "RetouchNetworking.h"

@interface RetouchNetworking (requestManager)

/**
 *  判断网络请求池中是否有相同的请求
 *
 *  @param task 网络请求任务
 *
 *  @return 存在相同的请求返回YES
 */
+ (BOOL)haveSameRequestInTasksPool:(RetouchURLSessionTask *)task;

/**
 *  如果有旧请求则取消旧请求
 *
 *  @param task 新请求
 *
 *  @return 旧请求
 */
+ (RetouchURLSessionTask *)cancleSameRequestInTasksPool:(RetouchURLSessionTask *)task;




@end
