
#import <Foundation/Foundation.h>

/// 文件管理类
@interface LXFileManager : NSObject



/**
 把对象归档存到沙盒里

 @param object 对象名
 @param fileName 文件保存名
 */
+(void)saveObject:(id)object byFileName:(NSString*)fileName;




/**
 通过文件名从沙盒中找到归档的对象

 @param fileName 本地文件保存名
 @return 返回对象
 */
+(id)getObjectByFileName:(NSString*)fileName;






/**
 根据文件名删除沙盒中的 plist 文件

 @param fileName 本地文件保存名
 */
+(void)removeFileByFileName:(NSString*)fileName;





/**
 存储用户偏好设置 到 NSUserDefults

 @param data 偏好设置的数据流
 @param key 键名
 */
+(void)saveUserData:(id)data forKey:(NSString*)key;






/**
 读取用户偏好设置

 @param key 键名
 @return 返回偏好设置的数据流
 */
+(id)readUserDataForKey:(NSString*)key;





/**
 删除用户偏好设置

 @param key 键名
 */
+(void)removeUserDataForkey:(NSString*)key;




@end
