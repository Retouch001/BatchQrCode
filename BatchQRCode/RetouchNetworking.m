//
//  RetouchNetworking.m
//  网络层的封装
//
//  Created by 方景琦 on 2016/11/23.
//  Copyright © 2016年 iBreezeeWiFiDemo. All rights reserved.
//

#import "RetouchNetworking.h"
#import "AFNetworking.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "Util.h"
#import "RetouchNetworking+requestManager.h"


static NSMutableArray   *requestTasksPool;

static NSDictionary     *headers;


static NSTimeInterval requestTimeout = 10.f;


@implementation RetouchNetworking


+ (void)configureHttpHeader:(NSDictionary *)httpHeader {
    headers = httpHeader;
}



#pragma mark - manager
+(AFHTTPSessionManager *)manager {
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    //默认解析模式
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    //配置请求序列化
    AFJSONResponseSerializer *serializer = [AFJSONResponseSerializer serializer];
    
    [serializer setRemovesKeysWithNullValues:YES];
    
    manager.requestSerializer.stringEncoding = NSUTF8StringEncoding;
    
    manager.requestSerializer.timeoutInterval = requestTimeout;
    
    for (NSString *key in headers.allKeys) {
        if (headers[key] != nil) {
            [manager.requestSerializer setValue:headers[key] forHTTPHeaderField:key];
        }
    }
    
    //配置响应序列化
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"application/json",
                                                                              @"text/html",
                                                                              @"text/json",
                                                                              @"text/plain",
                                                                              @"text/javascript",
                                                                              @"text/xml",
                                                                              @"image/*",
                                                                              @"application/octet-stream",
                                                                              @"application/zip"]];
    
    [self checkNetworkStatus];
    
    return manager;
}


#pragma mark  ------检测网络状态------
+(void)checkNetworkStatus{
    
    
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    
    [manager startMonitoring];
    
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                networkStatus = RetouchNetworkStatusUnknown;
                break;
                
            case AFNetworkReachabilityStatusNotReachable:
                networkStatus = RetouchNetworkStatusNotReachable;
                break;
                
            case AFNetworkReachabilityStatusReachableViaWWAN:
                networkStatus = RetouchNetworkStatusReachableViaWWAN;
                break;
                
            case AFNetworkReachabilityStatusReachableViaWiFi:
                networkStatus = RetouchNetworkStatusReachableViaWiFi;
                break;
                
            default:
                networkStatus = RetouchNetworkStatusUnknown;
                break;
        }
    }];
    

}




#pragma mark --------- post请求-------
+(RetouchURLSessionTask *)postWithUrl:(NSString *)url params:(NSDictionary *)params progressBlock:(RetouchDownloadProgress)progressBlock successBlock:(RetouchResponseSuccessBlock)successBlock failBlock:(RetouchResponseFailBlock)failBlock{
    __block RetouchURLSessionTask *session = nil;
    
    AFHTTPSessionManager *manager = [self manager];
    
    if (networkStatus == RetouchNetworkStatusNotReachable) {
        if (failBlock){
            NSError *error = [NSError errorWithDomain:@"com.RetouchNetworking.ErrorDomain" code:-4396 userInfo:@{ NSLocalizedDescriptionKey:@"当前网络不可用,请检查你的网络设置"}];
            
            [SVProgressHUD showErrorWithStatus:(@"当前网络不可用,请检查你的网络设置")];
            failBlock(error);
        }
        
        return session;
    }
    
    
    session = [manager POST:url parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        if (progressBlock) progressBlock(uploadProgress.completedUnitCount,
                                         uploadProgress.totalUnitCount);
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (successBlock) successBlock(responseObject);
        [SVProgressHUD dismiss];
        
        if ([[self allTasks] containsObject:session]) {
            [[self allTasks] removeObject:session];
        }

        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (error.code == -4396 || error.code == 1009) {
            [SVProgressHUD showErrorWithStatus:(@"当前网络不可用,请检查你的网络设置")];
        }else if (error.code == -1001){
            [SVProgressHUD showErrorWithStatus:(@"无法连接服务器,请检查你的网络设置")];
        }else{
            [SVProgressHUD showErrorWithStatus:SERVICE_ERROR_RESULT];
        }

        
        
        
        if (failBlock) failBlock(error);
        
        [[self allTasks] removeObject:session];

    }];
    
    
    
    if ([self haveSameRequestInTasksPool:session] ) {
        [session cancel];
        return session;
    }else {
        RetouchURLSessionTask *oldTask = [self cancleSameRequestInTasksPool:session];
        if (oldTask) [[self allTasks] removeObject:oldTask];
        if (session) [[self allTasks] addObject:session];
        [session resume];
        return session;
    }
    
}






#pragma mark - 文件上传
+(RetouchURLSessionTask *)uploadFileWithUrl:(NSString *)url
                            dict:(NSMutableDictionary *)dict
                               fileData:(UIImage *)image
                                   name:(NSString *)name
                               mimeType:(NSString *)mimeType
                          progressBlock:(RetouchUploadProgressBlock)progressBlock
                           successBlock:(RetouchResponseSuccessBlock)successBlock
                              failBlock:(RetouchResponseFailBlock)failBlock {
    __block RetouchURLSessionTask *session = nil;
    
    AFHTTPSessionManager *manager = [self manager];
    
    if (networkStatus == RetouchNetworkStatusNotReachable) {
        
        if (failBlock){
            NSError *error = [NSError errorWithDomain:@"com.RetouchNetworking.ErrorDomain" code:-4396 userInfo:@{ NSLocalizedDescriptionKey:@"当前网络不可用,请检查你的网络设置"}];
            failBlock(error);
        }

        
        return session;
    }
    
    session = [manager POST:url
                 parameters:dict
  constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
      
      if (image != nil) {
          [formData appendPartWithFileData:UIImageJPEGRepresentation(image, 0.3) name:@"file" fileName:name mimeType:mimeType];
      }

      
      
  } progress:^(NSProgress * _Nonnull uploadProgress) {
      if (progressBlock) progressBlock (uploadProgress.completedUnitCount,uploadProgress.totalUnitCount);
      
  } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
      if (successBlock) successBlock(responseObject);
      [[self allTasks] removeObject:session];

      
  } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
      if (failBlock) failBlock(error);
      [[self allTasks] removeObject:session];
  }];
    
    [session resume];
    
    if (session) [[self allTasks] addObject:session];
    
    return session;
}



+ (NSMutableArray *)allTasks {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (requestTasksPool == nil) requestTasksPool = [NSMutableArray array];
    });
    
    return requestTasksPool;
}


+ (NSArray *)currentRunningTasks {
    return [[self allTasks] copy];
}


+ (void)cancleAllRequest {
    @synchronized (self) {
        [[self allTasks] enumerateObjectsUsingBlock:^(RetouchURLSessionTask  *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[RetouchURLSessionTask class]]) {
                [obj cancel];
            }
        }];
        [[self allTasks] removeAllObjects];
    }
}



@end
