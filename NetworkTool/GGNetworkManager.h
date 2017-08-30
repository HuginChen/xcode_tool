//
//  GGNetworkManager.h
//  GGNetworkManager
//
//  Created by Hugin on 15/8/28.
//  Copyright © 2015年 Hugin. All rights reserved.
//

#import <AFNetworking.h>

/** 定义请求类型的枚举 */
typedef NS_ENUM(NSUInteger, GGHTTPRequestType) {
    GGHTTPRequestTypeGET = 0,
    GGHTTPRequestTypePOST
};

/** 定义请求成功的 block */
typedef void (^GGResponseSuccess)(NSURLSessionDataTask * task,id responseObject);

/** 定义请求失败的block*/
typedef void (^GGResponseFail)(NSURLSessionDataTask * task, NSError * error);

/** 上传或者下载的进度 */
typedef void (^GGProgress)(NSProgress *progress);

/** 缓存的block */
typedef void(^requestCache) (id jsonCache);

@interface GGNetworkManager : AFHTTPSessionManager

//+ (instancetype)sharedInstance;
+ (instancetype)sharedInstanceWithBaseUrl:(NSString *)baseUrl;

/**
 *  普通get方法请求网络数据
 *
 *  @param url      请求网址路径
 *  @param params   请求参数
 *  @param success  成功回调
 *  @param failure  失败回调
 */
+ (void)GET:(NSString *)url
     params:(NSDictionary *)params
    success:(GGResponseSuccess)success
    failure:(GGResponseFail)failure;
/**
 *  含有baseURL的get方法
 *
 *  @param url      请求网址路径
 *  @param baseUrl  请求网址根路径
 *  @param params   请求参数
 *  @param success  成功回调
 *  @param failure  失败回调
 */
+ (void)GET:(NSString *)url
    baseURL:(NSString *)baseUrl
     params:(NSDictionary *)params
    success:(GGResponseSuccess)success
    failure:(GGResponseFail)failure;

/**
 *  普通post方法请求网络数据
 *
 *  @param url      请求网址路径
 *  @param params   请求参数
 *  @param success  成功回调
 *  @param failure  失败回调
 */
+ (void)POST:(NSString *)url
      params:(NSDictionary *)params
     success:(GGResponseSuccess)success
     failure:(GGResponseFail)failure;

/**
 *  含有baseURL的post方法
 *
 *  @param url      请求网址路径
 *  @param baseUrl  请求网址根路径
 *  @param params   请求参数
 *  @param success  成功回调
 *  @param failure  失败回调
 */
+ (void)POST:(NSString *)url
     baseURL:(NSString *)baseUrl
      params:(NSDictionary *)params
     success:(GGResponseSuccess)success
     failure:(GGResponseFail)failure;

/**
 *  发起网络请求
 *
 *  @param url          请求网址路径
 *  @param parameters   请求参数
 *  @param method       请求方法
 *  @param success      成功回调
 *  @param failure      失败回调
 */
- (void)requestWithURLString:(NSString *)url
                  parameters:(NSDictionary *)parameters
                      method:(GGHTTPRequestType)method
                     success:(GGResponseSuccess)success
                     failure:(GGResponseFail)failure;


/**
 *  普通路径上传文件
 *
 *  @param url      请求网址路径
 *  @param params   请求参数
 *  @param filedata 文件
 *  @param name     指定参数名
 *  @param filename 文件名（要有后缀名）
 *  @param mimeType 文件类型
 *  @param progress 上传进度
 *  @param success  成功回调
 *  @param failure  失败回调
 */
+ (void)uploadWithURL:(NSString *)url
               params:(NSDictionary *)params
             fileData:(NSData *)filedata
                 name:(NSString *)name
             fileName:(NSString *)filename
             mimeType:(NSString *) mimeType
             progress:(GGProgress)progress
              success:(GGResponseSuccess)success
              failure:(GGResponseFail)failure;
/**
 *  含有baseURL的上传文件
 *
 *  @param url      请求网址路径
 *  @param baseUrl  请求网址根路径
 *  @param params   请求参数
 *  @param filedata 文件
 *  @param name     指定参数名
 *  @param filename 文件名（要有后缀名）
 *  @param mimeType 文件类型
 *  @param progress 上传进度
 *  @param success  成功回调
 *  @param failure  失败回调
 */
+ (void)uploadWithURL:(NSString *)url
              baseURL:(NSString *)baseUrl
               params:(NSDictionary *)params
             fileData:(NSData *)filedata
                 name:(NSString *)name
             fileName:(NSString *)filename
             mimeType:(NSString *) mimeType
             progress:(GGProgress)progress
              success:(GGResponseSuccess)success
              failure:(GGResponseFail)failure;

/**
 *  上传文件方法
 *
 *  @param url          请求网址路径
 *  @param parameters   请求参数
 *  @param filedata     文件
 *  @param name         指定参数名
 *  @param filename     文件名（要有后缀名）
 *  @param mimeType     文件类型
 *  @param progress     上传进度
 *  @param success      成功回调
 *  @param failure      失败回调
 */
- (void)uploadWithURL:(NSString *)url
           parameters:(NSDictionary *)parameters
             fileData:(NSData *)filedata
                 name:(NSString *)name
             fileName:(NSString *)filename
             mimeType:(NSString *) mimeType
             progress:(GGProgress)progress
              success:(GGResponseSuccess)success
              failure:(GGResponseFail)failure;

/**
 *  下载文件
 *
 *  @param url      请求网络路径
 *  @param fileURL  保存文件url
 *  @param progress 下载进度
 *  @param success  成功回调
 *  @param failure  失败回调
 *
 *  @return 返回NSURLSessionDownloadTask实例，可用于暂停继续，暂停调用suspend方法，重新开启下载调用resume方法
 */
+ (NSURLSessionDownloadTask *)downloadWithURL:(NSString *)url
                                  savePathURL:(NSURL *)fileURL
                                     progress:(GGProgress )progress
                                      success:(void (^)(NSURLResponse *, NSURL *))success
                                      failure:(void (^)(NSError *))failure;

/**
 *  含有baseURL的下载文件
 *
 *  @param url      请求网络路径
 *  @param baseUrl  请求网址根路径
 *  @param fileURL  保存文件url
 *  @param progress 下载进度
 *  @param success  成功回调
 *  @param failure  失败回调
 *
 *  @return 返回NSURLSessionDownloadTask实例，可用于暂停继续，暂停调用suspend方法，重新开启下载调用resume方法
 */
+ (NSURLSessionDownloadTask *)downloadWithURL:(NSString *)url
                                      baseURL:(NSString *)baseUrl
                                  savePathURL:(NSURL *)fileURL
                                     progress:(GGProgress )progress
                                      success:(void (^)(NSURLResponse *, NSURL *))success
                                      failure:(void (^)(NSError *))failure;

/**
 *  下载文件
 *
 *  @param url      请求网络路径
 *  @param fileURL  保存文件url
 *  @param progress 下载进度
 *  @param success  成功回调
 *  @param failure  失败回调
 *
 *  @return 返回NSURLSessionDownloadTask实例，可用于暂停继续，暂停调用suspend方法，重新开启下载调用resume方法
 */
- (NSURLSessionDownloadTask *)downloadWithURL:(NSString *)url
                                  savePathURL:(NSURL *)fileURL
                                     progress:(GGProgress )progress
                                      success:(void (^)(NSURLResponse *, NSURL *))success
                                      failure:(void (^)(NSError *))failure;

@end
