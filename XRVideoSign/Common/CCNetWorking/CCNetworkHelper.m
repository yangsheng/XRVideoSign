//
//  CCNetworkHelper.m
//  DullRadish
//
//  Created by zhu yangsheng on 1/20/19.
//  Copyright © 2019 xrinfo. All rights reserved.
//

#import "CCNetworkHelper.h"

#define CCAppBaseHostURL @"http://123.207.109.93:9010/xrspip"

@implementation CCNetworkHelper

static BOOL _isOpenLog;   // 是否已开启日志打印
// 存储着所有的请求task数组
static NSMutableArray *_allSessionTasks;
static AFHTTPSessionManager *_sessionManager;


+ (void)initialize
{
    
#ifdef DEBUG
    _isOpenLog = YES;
#endif
    
    _sessionManager = [AFHTTPSessionManager manager];
    
    // 设置请求的超时时间
    _sessionManager.requestSerializer.timeoutInterval = 30.f;
    
    // 设置服务器返回结果的类型:JSON (AFJSONResponseSerializer,AFHTTPResponseSerializer)
    _sessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
    _sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", @"text/json", @"text/plain", @"text/javascript", @"text/xml", @"image/*",@"text/encode", nil];
}

+ (void)cancelAllRequest
{
    // 锁操作
    @synchronized(self) {
        [[self allSessionTask] enumerateObjectsUsingBlock:^(NSURLSessionTask  *_Nonnull task, NSUInteger idx, BOOL * _Nonnull stop) {
            [task cancel];
        }];
        [[self allSessionTask] removeAllObjects];
    }
}

+ (void)cancelRequestWithURL:(NSString *)URL {
    if (!URL) { return; }
    @synchronized (self) {
        [[self allSessionTask] enumerateObjectsUsingBlock:^(NSURLSessionTask  *_Nonnull task, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([task.currentRequest.URL.absoluteString hasPrefix:URL]) {
                [task cancel];
                [[self allSessionTask] removeObject:task];
                *stop = YES;
            }
        }];
    }
}

#pragma mark - GET请求无缓存
+ (NSURLSessionTask *)GET:(NSString *)URL
               parameters:(id)parameters
                  success:(CCHttpRequestSuccess)success
                  failure:(CCHttpRequestFailed)failure
{
    return [self GET:URL parameters:parameters responseCache:nil success:success failure:failure];
}

#pragma mark POST请求无缓存
+ (NSURLSessionTask *)POST:(NSString *)URL
                parameters:(id)parameters
                   success:(CCHttpRequestSuccess)success
                   failure:(CCHttpRequestFailed)failure
{
    return [self POST:URL parameters:parameters responseCache:nil success:success failure:failure];
}

#pragma mark GET请求自动缓存
+ (NSURLSessionTask *)GET:(NSString *)URL
               parameters:(id)parameters
            responseCache:(CCHttpRequestCache)responseCache
                  success:(CCHttpRequestSuccess)success
                  failure:(CCHttpRequestFailed)failure
{
    if ([URL hasPrefix:@"http://"] || [URL hasPrefix:@"https://"]) {
    }
    else {
        URL = [NSString stringWithFormat:@"%@%@",CCAppBaseHostURL, URL];
    }
    
    // 读取缓存
    responseCache!=nil ? responseCache([CCNetworkCache httpCacheForURL:URL parameters:parameters]) : nil;
    
    // 加密 header body
    //[self encodeParameters:parameters];
    
    NSURLSessionTask *sessionTask = [_sessionManager GET:URL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
//        if (_isOpenAES) {
//            //解密
//            responseObject = aesDecryptWithData(responseObject);
//        }
        
//        // 压缩数据、解压
//        NSMutableDictionary *response = [LFCGzipUtillity uncompressZippedData:responseObject];
//
//        if (_isOpenLog) {CCLog(@"responseObject = %@",[self jsonToString:response]);}
        
        NSMutableDictionary *response = responseObject;
        [[self allSessionTask] removeObject:task];
        
        success ? success(response) : nil;
        
        // 对数据进行异步缓存
        responseCache != nil ? [CCNetworkCache setHttpCache:response URL:URL parameters:parameters] : nil;
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
//        if (_isOpenLog) {CCLog(@"error = %@",error);}
        
        [[self allSessionTask] removeObject:task];
        
        failure ? failure(error) : nil;
        
    }];
    
    // 添加sessionTask到数组
    sessionTask ? [[self allSessionTask] addObject:sessionTask] : nil ;
    
    return sessionTask;
}

#pragma mark POST请求自动缓存
+ (NSURLSessionTask *)POST:(NSString *)URL
                parameters:(id)parameters
             responseCache:(CCHttpRequestCache)responseCache
                   success:(CCHttpRequestSuccess)success
                   failure:(CCHttpRequestFailed)failure
{
    if ([URL hasPrefix:@"http://"] || [URL hasPrefix:@"https://"]) {
    }
    else {
        URL = [NSString stringWithFormat:@"%@%@",CCAppBaseHostURL, URL];
    }
    
    // 读取缓存
    responseCache != nil ? responseCache([CCNetworkCache httpCacheForURL:URL parameters:parameters]) : nil;
    
    // 加密 header body
//    [self encodeParameters:parameters];
    
    NSURLSessionTask *sessionTask = [_sessionManager POST:URL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
//        if (_isOpenAES) {
//            //解密
//            responseObject = aesDecryptWithData(responseObject);
//        }
        // 压缩数据、解压
        NSMutableDictionary *response = responseObject; //[LFCGzipUtillity uncompressZippedData:responseObject];
        
//        if (_isOpenLog) {CCLog(@"responseObject = %@",[self jsonToString:response]);}
        
        [[self allSessionTask] removeObject:task];
        success ? success(response) : nil;
        
        // 对数据进行异步缓存
        responseCache != nil ? [CCNetworkCache setHttpCache:response URL:URL parameters:parameters] : nil;
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
  //      if (_isOpenLog) {CCLog(@"error = %@",error);}
        
        [[self allSessionTask] removeObject:task];
        failure ? failure(error) : nil;
    }];
    
    // 添加最新的sessionTask到数组
    sessionTask ? [[self allSessionTask] addObject:sessionTask] : nil ;
    
    return sessionTask;
}

#pragma mark - 上传文件
+ (NSURLSessionTask *)uploadFileWithURL:(NSString *)URL
                             parameters:(id)parameters
                                   name:(NSString *)name
                               filePath:(NSString *)filePath
                               progress:(CCHttpProgress)progress
                                success:(CCHttpRequestSuccess)success
                                failure:(CCHttpRequestFailed)failure
{
    
    NSURLSessionTask *sessionTask = [_sessionManager POST:URL parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSError *error = nil;
        [formData appendPartWithFileURL:[NSURL URLWithString:filePath] name:name error:&error];
        (failure && error) ? failure(error) : nil;
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        // 上传进度
        dispatch_sync(dispatch_get_main_queue(), ^{
            progress ? progress(uploadProgress) : nil;
        });
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
//        if (_isOpenLog) {CCLog(@"responseObject = %@",[self jsonToString:responseObject]);}
        [[self allSessionTask] removeObject:task];
        
        success ? success(responseObject) : nil;
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
//        if (_isOpenLog) {CCLog(@"error = %@",error);}
        [[self allSessionTask] removeObject:task];
        failure ? failure(error) : nil;
    }];
    
    // 添加sessionTask到数组
    sessionTask ? [[self allSessionTask] addObject:sessionTask] : nil ;
    
    return sessionTask;
}

#pragma mark - 上传多张图片
+ (NSURLSessionTask *)uploadImagesWithURL:(NSString *)URL
                               parameters:(id)parameters
                                     name:(NSString *)name
                                   images:(NSArray<UIImage *> *)images
                                fileNames:(NSArray<NSString *> *)fileNames
                               imageScale:(CGFloat)imageScale
                                imageType:(NSString *)imageType
                                 progress:(CCHttpProgress)progress
                                  success:(CCHttpRequestSuccess)success
                                  failure:(CCHttpRequestFailed)failure
{
    NSURLSessionTask *sessionTask = [_sessionManager POST:URL parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        for (NSUInteger i = 0; i < images.count; i++) {
            // 图片经过等比压缩后得到的二进制文件
            NSData *imageData = UIImageJPEGRepresentation(images[i], imageScale ?: 1.f);
            // 默认图片的文件名, 若fileNames为nil就使用
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"yyyyMMddHHmmss";
            NSString *str = [formatter stringFromDate:[NSDate date]];
       
            NSString *imageFileName = [NSString stringWithFormat:@"%@%ld.%@", str, i, imageType?:@"jpg"];
            NSString *fileName = [NSString stringWithFormat:@"%@.%@", fileNames[i], imageType?:@"jpg"];
            NSString *mimeType = [NSString stringWithFormat:@"image/%@", imageType ?: @"jpg"];
            
            [formData appendPartWithFileData:imageData
                                        name:name
                                    fileName:fileNames ? fileName : imageFileName
                                    mimeType:mimeType];
        }
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        //上传进度
        dispatch_sync(dispatch_get_main_queue(), ^{
            progress ? progress(uploadProgress) : nil;
        });
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
//        if (_isOpenLog) {CCLog(@"responseObject = %@",[self jsonToString:responseObject]);}
        
        [[self allSessionTask] removeObject:task];
        success ? success(responseObject) : nil;
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
 //       if (_isOpenLog) {CCLog(@"error = %@",error);}
        [[self allSessionTask] removeObject:task];
        failure ? failure(error) : nil;
    }];
    
    // 添加sessionTask到数组
    sessionTask ? [[self allSessionTask] addObject:sessionTask] : nil ;
    
    return sessionTask;
}

#pragma mark - 下载文件
+ (NSURLSessionTask *)downloadWithURL:(NSString *)URL
                              fileDir:(NSString *)fileDir
                             progress:(CCHttpProgress)progress
                              success:(void(^)(NSString *))success
                              failure:(CCHttpRequestFailed)failure
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:URL]];
    
    __block NSURLSessionDownloadTask *downloadTask = [_sessionManager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        // 下载进度
        dispatch_sync(dispatch_get_main_queue(), ^{
            progress ? progress(downloadProgress) : nil;
        });
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        // 拼接缓存目录
        NSString *downloadDir = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:fileDir ? fileDir : @"CCFileDownload"];
        
        // 打开文件管理器
        NSFileManager *fileManager = [NSFileManager defaultManager];
        // 创建Download目录
        [fileManager createDirectoryAtPath:downloadDir withIntermediateDirectories:YES attributes:nil error:nil];
        // 拼接文件路径
        NSString *filePath = [downloadDir stringByAppendingPathComponent:response.suggestedFilename];
       
        // 返回文件位置的URL路径
        return [NSURL fileURLWithPath:filePath];
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        
        [[self allSessionTask] removeObject:downloadTask];
        if(failure && error) {failure(error) ; return ;};
        
        success ? success(filePath.absoluteString /** NSURL->NSString*/) : nil;
        
    }];
    
    // 开始下载
    [downloadTask resume];
    // 添加sessionTask到数组
    downloadTask ? [[self allSessionTask] addObject:downloadTask] : nil ;
    
    return downloadTask;
}


/**
 *  json转字符串
 */
+ (NSString *)jsonToString:(id)data
{
    if(data == nil) { return nil; }
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:data options:NSJSONWritingPrettyPrinted error:nil];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

/**
 存储着所有的请求task数组
 */
+ (NSMutableArray *)allSessionTask
{
    if (!_allSessionTasks) {
        _allSessionTasks = [NSMutableArray array];
    }
    
    return _allSessionTasks;
}


@end
