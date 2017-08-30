//
//  GGNetworkManager.m
//  GGNetworkManager
//
//  Created by Hugin on 15/8/28.
//  Copyright © 2015年 Hugin. All rights reserved.
//

#import "GGNetworkManager.h"

@implementation GGNetworkManager

+ (instancetype)sharedInstanceWithBaseUrl:(NSString *)baseUrl {
    
    if (baseUrl == nil || [baseUrl isEqual: @""]) {
        return [GGNetworkManager sharedInstance];
    }
    
    static GGNetworkManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        instance = [[self alloc] initWithBaseURL:[NSURL URLWithString:baseUrl]];
        // 设置响应数据格式
        instance.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",
                                                              @"text/json",
                                                              @"text/javascript",
                                                              @"text/html", nil];
        // 当响应失败时可以试下这个。。。
        //instance.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        // 启动网络监听
        [instance.reachabilityManager startMonitoring];
    });
    return instance;
}

+ (void)GET:(NSString *)url
     params:(NSDictionary *)params
    success:(GGResponseSuccess)success
    failure:(GGResponseFail)failure {
    
    [[self managerWithBaseURL:nil] GET:url parameters:params progress:nil success:success failure:failure];
}

+ (void)GET:(NSString *)url
    baseURL:(NSString *)baseUrl
     params:(NSDictionary *)params
    success:(GGResponseSuccess)success
    failure:(GGResponseFail)failure {
    
    [[self managerWithBaseURL:baseUrl] GET:url parameters:params progress:nil success:success failure:failure];
}

+ (void)POST:(NSString *)url
      params:(NSDictionary *)params
     success:(GGResponseSuccess)success
     failure:(GGResponseFail)failure {
    
    [[self managerWithBaseURL:nil] POST:url parameters:params progress:nil success:success failure:failure];
}

+ (void)POST:(NSString *)url
     baseURL:(NSString *)baseUrl
      params:(NSDictionary *)params
     success:(GGResponseSuccess)success
     failure:(GGResponseFail)failure {
    
    [[self managerWithBaseURL:baseUrl] POST:url parameters:params progress:nil success:success failure:failure];
}

- (void)requestWithURLString:(NSString *)url
                  parameters:(NSDictionary *)parameters
                      method:(GGHTTPRequestType)method
                     success:(GGResponseSuccess)success
                     failure:(GGResponseFail)failure {
    if (method == GGHTTPRequestTypeGET) {
        [self GET:url parameters:parameters progress:nil success:success failure:failure];
    }
    if (method == GGHTTPRequestTypePOST) {
        [self POST:url parameters:parameters progress:nil success:success failure:failure];
    }
}

+ (void)uploadWithURL:(NSString *)url
               params:(NSDictionary *)params
             fileData:(NSData *)filedata
                 name:(NSString *)name
             fileName:(NSString *)filename
             mimeType:(NSString *) mimeType
             progress:(GGProgress)progress
              success:(GGResponseSuccess)success
              failure:(GGResponseFail)failure {
    
    [[self managerWithBaseURL:nil] POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:filedata name:name fileName:filename mimeType:mimeType];
    } progress:progress success:success failure:failure];
}

+ (void)uploadWithURL:(NSString *)url
              baseURL:(NSString *)baseUrl
               params:(NSDictionary *)params
             fileData:(NSData *)filedata
                 name:(NSString *)name
             fileName:(NSString *)filename
             mimeType:(NSString *) mimeType
             progress:(GGProgress)progress
              success:(GGResponseSuccess)success
              failure:(GGResponseFail)failure {
    
    [[self managerWithBaseURL:baseUrl] POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:filedata name:name fileName:filename mimeType:mimeType];
    } progress:progress success:success failure:failure];
}

- (void)uploadWithURL:(NSString *)url
           parameters:(NSDictionary *)parameters
             fileData:(NSData *)filedata
                 name:(NSString *)name
             fileName:(NSString *)filename
             mimeType:(NSString *) mimeType
             progress:(GGProgress)progress
              success:(GGResponseSuccess)success
              failure:(GGResponseFail)failure {
    
    [self POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:filedata name:name fileName:filename mimeType:mimeType];
    } progress:progress success:success failure:failure];
    
}

+ (NSURLSessionDownloadTask *)downloadWithURL:(NSString *)url
                                  savePathURL:(NSURL *)fileURL
                                     progress:(GGProgress )progress
                                      success:(void (^)(NSURLResponse *, NSURL *))success
                                      failure:(void (^)(NSError *))failure {
    NSURL *urlpath = [NSURL URLWithString:url];
    NSURLRequest *request = [NSURLRequest requestWithURL:urlpath];
    
    NSURLSessionDownloadTask *downloadtask = [[self managerWithBaseURL:nil] downloadTaskWithRequest:request progress:progress destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        return [fileURL URLByAppendingPathComponent:[response suggestedFilename]];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        if (error) {
            failure(error);
        }else{
            success(response,filePath);
        }
    }];
    
    [downloadtask resume];
    
    return downloadtask;
}

+ (NSURLSessionDownloadTask *)downloadWithURL:(NSString *)url
                                      baseURL:(NSString *)baseUrl
                                  savePathURL:(NSURL *)fileURL
                                     progress:(GGProgress )progress
                                      success:(void (^)(NSURLResponse *, NSURL *))success
                                      failure:(void (^)(NSError *))failure {
    NSURL *urlpath = [NSURL URLWithString:url];
    NSURLRequest *request = [NSURLRequest requestWithURL:urlpath];
    
    NSURLSessionDownloadTask *downloadtask = [[self managerWithBaseURL:baseUrl] downloadTaskWithRequest:request progress:progress destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        return [fileURL URLByAppendingPathComponent:[response suggestedFilename]];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        if (error) {
            failure(error);
        }else{
            success(response,filePath);
        }
    }];
    
    [downloadtask resume];
    
    return downloadtask;
}

- (NSURLSessionDownloadTask *)downloadWithURL:(NSString *)url
                                  savePathURL:(NSURL *)fileURL
                                     progress:(GGProgress )progress
                                      success:(void (^)(NSURLResponse *, NSURL *))success
                                      failure:(void (^)(NSError *))failure {
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    NSURLSessionDownloadTask *downloadtask = [self downloadTaskWithRequest:request progress:progress destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        return [fileURL URLByAppendingPathComponent:[response suggestedFilename]];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        if (error) {
            failure(error);
        }else{
            success(response,filePath);
        }
    }];
    return downloadtask;
}

#pragma mark - private
+ (instancetype)sharedInstance {
    static GGNetworkManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
        // 设置响应数据格式
        instance.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",
                                                              @"text/json",
                                                              @"text/javascript",
                                                              @"text/html", nil];
        // 当响应失败时可以试下这个。。。
        //instance.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        // 启动网络监听
        [instance.reachabilityManager startMonitoring];
    });
    return instance;
}

+ (AFHTTPSessionManager *)managerWithBaseURL:(NSString *)baseURL {
    
    AFHTTPSessionManager *manager = [[self alloc] initWithBaseURL:[NSURL URLWithString:baseURL]];
    
    // 设置响应数据格式
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",
                                                          @"text/json",
                                                          @"text/javascript",
                                                          @"text/html", nil];
    // 当响应失败时可以试下这个。。。
    //manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    
    return manager;
}


@end
