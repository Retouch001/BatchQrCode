//
//  RetouchNetworking.h
//  网络层的封装
//
//  Created by 方景琦 on 2016/11/23.
//  Copyright © 2016年 iBreezeeWiFiDemo. All rights reserved.
//

#import <Foundation/Foundation.h>

#define SERVICE_ERROR_RESULT  @"未知错误"


/**
 网络状态
 */
typedef NS_ENUM(NSInteger,RetouchNetworkStatus){
    
    /**
     *  未知网络
     */
    RetouchNetworkStatusUnknown             = 1 << 0,
    /**
     *  无法连接
     */
    RetouchNetworkStatusNotReachable        = 1 << 1,
    /**
     *  WWAN网络
     */
    RetouchNetworkStatusReachableViaWWAN    = 1 << 2,
    /**
     *  WiFi网络
     */
    RetouchNetworkStatusReachableViaWiFi    = 1 << 3

};


static RetouchNetworkStatus networkStatus;


//请求任务
typedef NSURLSessionTask  RetouchURLSessionTask;


//请求成功的回调
typedef void(^ RetouchResponseSuccessBlock) (id response);


//请求失败的回调
typedef void(^ RetouchResponseFailBlock)(NSError *error);



/**
 *  下载进度
 *
 *  @param bytesRead              已下载的大小
 *  @param totalBytes                总下载大小
 */
typedef void (^RetouchDownloadProgress)(int64_t bytesRead,
int64_t totalBytes);



//post请求进度
typedef RetouchDownloadProgress RetouchPostProgress;



/**
 *  上传进度
 *
 *  @param bytesWritten              已上传的大小
 *  @param totalBytes                总上传大小
 */
typedef void(^RetouchUploadProgressBlock)(int64_t bytesWritten,
int64_t totalBytes);







@interface RetouchNetworking : NSObject


/**
 *  正在运行的网络任务
 *
 *  @return 返回所有正在运行的网络任务
 */
+ (NSArray *)currentRunningTasks;




/**
 配置请求头

 @param httpHeader 请求头
 */
+(void)configureHttpHeader:(NSDictionary *)httpHeader;




/**
 *  取消所有请求
 */
+ (void)cancleAllRequest;




/**
 Post请求

 @param url 请求路径
 @param params 请求携带的参数
 @param progressBlock 进度回调
 @param successBlock 成功回调
 @param failBlock 失败回调
 */
+(RetouchURLSessionTask *)postWithUrl:(NSString *)url params:(NSDictionary *)params progressBlock:(RetouchDownloadProgress )progressBlock successBlock:(RetouchResponseSuccessBlock )successBlock failBlock:(RetouchResponseFailBlock )failBlock;




/**
 *  文件上传
 *
 *  @param url              上传文件接口地址
 *  @param image             上传文件数据
 *  @param name             上传文件服务器文件夹名
 *  @param dict             附带的参数
 *  @param mimeType         mimeType
 *  @param progressBlock    上传文件路径
 *	@param successBlock     成功回调
 *	@param failBlock		失败回调
 *
 */
+ (RetouchURLSessionTask *)uploadFileWithUrl:(NSString *)url
                                dict:(NSMutableDictionary *)dict
                               fileData:(UIImage *)image
                                   name:(NSString *)name
                               mimeType:(NSString *)mimeType
                          progressBlock:(RetouchUploadProgressBlock)progressBlock
                           successBlock:(RetouchResponseSuccessBlock)successBlock
                              failBlock:(RetouchResponseFailBlock)failBlock;


@end
