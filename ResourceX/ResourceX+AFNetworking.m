//
//  ResourceX+AFNetworking.m
//  ResourceX
//
//  Created by dqdeng on 2020/4/3.
//  Copyright © 2020 Jaden. All rights reserved.
//

#import "ResourceX+AFNetworking.h"

@protocol AFMultipartFormDataMethodProtocol <NSObject>
- (void)appendPartWithFileData:(NSData *)data
                          name:(NSString *)name
                      fileName:(NSString *)fileName
                      mimeType:(NSString *)mimeType;
@end
@protocol AFrequestSerializerProtocol <NSObject>
- (void)setTimeoutInterval:(NSInteger)timeoutInterval;
@end
@protocol AFNetworkingMethodProtool <NSObject>

- (id<AFrequestSerializerProtocol>)requestSerializer;

- (nullable NSURLSessionDataTask *)POST:(NSString *)URLString
                             parameters:(nullable id)parameters
                                headers:(nullable NSDictionary <NSString *, NSString *> *)headers
                               progress:(nullable void (^)(NSProgress *uploadProgress))uploadProgress
                                success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
                                failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure;
- (nullable NSURLSessionDataTask *)POST:(NSString *)URLString
                             parameters:(nullable id)parameters
                                headers:(nullable NSDictionary <NSString *, NSString *> *)headers
              constructingBodyWithBlock:(nullable void (^)(id <AFMultipartFormDataMethodProtocol> formData))block
                               progress:(nullable void (^)(NSProgress *uploadProgress))uploadProgress
                                success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
                                failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure;
- (nullable NSURLSessionDataTask *)GET:(NSString *)URLString
                            parameters:(nullable id)parameters
                               headers:(nullable NSDictionary <NSString *, NSString *> *)headers
                              progress:(nullable void (^)(NSProgress *downloadProgress))downloadProgress
                               success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
                               failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure;

@end

static AFHTTPSessionTool *shareManager = nil;

@interface AFHTTPSessionTool () <NSCacheDelegate>

@property (nonatomic,strong)id<AFNetworkingMethodProtool> AF_sessionManager;

@end

@implementation AFHTTPSessionTool

+ (AFHTTPSessionTool *)sharedManager {
    
    if (!shareManager) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            shareManager = [[AFHTTPSessionTool alloc] init];
        });
    }
    return shareManager;
}


///.如果发现当前计算得到的成本超过总成本,那么会自动开启一个回收过程,把之前的数据删除
- (NSCache *)cache {
    if (_cache == nil) {
        _cache = [[NSCache alloc] init];
        //移除不再被使用的对象
        _cache.evictsObjectsWithDiscardedContent = YES;
        _cache.delegate = self;
    }
    return _cache;
}

- (id<AFNetworkingMethodProtool>)AF_sessionManager {
    if (!_AF_sessionManager) {
        @throw [NSException exceptionWithName:@"没有配置AFHTTPSessionManager 对象" reason:@"请使用 [AFHTTPSessionTool sharedManager].AF_httpSessionManager 进行设置" userInfo:nil];
    }
    return _AF_sessionManager;
}
- (void)setAF_httpSessionManager:(ConfigerAFSessionManager)AF_httpSessionManager{
    _AF_httpSessionManager = AF_httpSessionManager;
    self.AF_sessionManager = AF_httpSessionManager();
}

- (void)cache:(NSCache *)cache willEvictObject:(id)obj {
}

@end

@implementation ResourceX (AFNetworking)

- (void)POST_AF:(NSDictionary * _Nullable )parameters {
    [self availStartLoadHUD_ainmated];
    [self availCachePolicy:parameters];
    
    AFHTTPSessionTool *manager = [AFHTTPSessionTool sharedManager];
    [[manager.AF_sessionManager requestSerializer] setTimeoutInterval:self.timeoutInterval];
    [manager.AF_sessionManager POST:self.url parameters:parameters headers:[self configerHeaders:parameters] progress:^(NSProgress * _Nonnull uploadProgress) {
        double progress = (double)uploadProgress.completedUnitCount / (double)uploadProgress.totalUnitCount;
        if(self.uploadProgressCallBack)
            self.uploadProgressCallBack(progress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self saveCache:responseObject];
        [self parseResponse:responseObject];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self parseResponse:error];
    }];
}


- (void)GET_AF:(id _Nullable)parameters {
    [self availStartLoadHUD_ainmated];
    [self availCachePolicy:parameters];
    AFHTTPSessionTool *manager = [AFHTTPSessionTool sharedManager];
    [[manager.AF_sessionManager requestSerializer] setTimeoutInterval:self.timeoutInterval];
    [manager.AF_sessionManager GET:self.url parameters:parameters headers:[self configerHeaders:parameters] progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self saveCache:responseObject];
        [self parseResponse:responseObject];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self parseResponse:error];
    }];
}


//带有图片的请求
- (void)POST_AF:(id)parameters Images:(NSArray *)images {
    
    [self availStartLoadHUD_ainmated];
    if (!parameters) {
        parameters = @{};
    }
    // 缓存数据可读
    AFHTTPSessionTool *manager = [AFHTTPSessionTool sharedManager];
    [[manager.AF_sessionManager requestSerializer] setTimeoutInterval:self.timeoutInterval];
    
    NSMutableArray *scaleImageDatas = [images map:^NSData * _Nonnull(UIImage * _Nonnull image) {
        return [ResourceX scaleDataImage:image toKb:60];
    }];
    
    [manager.AF_sessionManager POST:self.url parameters:parameters headers:[self configerHeaders:parameters] constructingBodyWithBlock:^(id<AFMultipartFormDataMethodProtocol>  _Nonnull formData) {
        
        
        [scaleImageDatas forEachIndex:^(NSData *imageData, NSUInteger index) {
            NSString *fileName = [NSString stringWithFormat:@"%@%ld.jpg",[ResourceX createUUID],(long)index];
            [formData appendPartWithFileData:imageData name:@"file" fileName:fileName mimeType:@"image/jpeg"];
        }];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        double progress = (double)uploadProgress.completedUnitCount / (double)uploadProgress.totalUnitCount;
        if(self.uploadProgressCallBack)
            self.uploadProgressCallBack(progress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self parseResponse:responseObject];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self parseResponse:error];
    }];
}

- (void)saveCache:(id)responseObject {
    // 根据缓存策略判断是否写入缓存
    if ((self.cachePolicy == eCachePolicy_ReadWrite || self.cachePolicy == eCachePolicy_WriteOnly)) {
        
        NSCache *cache =  [AFHTTPSessionTool sharedManager].cache;
        if (responseObject) {
            [cache setObject:responseObject forKey:self.urlCacheKey];
        }
        
    }
}
- (NSDictionary *)configerHeaders:(NSDictionary *)parameters {
    
    NSDictionary *headers;
    if ([AFHTTPSessionTool sharedManager].sessionHeaders) {
        headers = [AFHTTPSessionTool sharedManager].sessionHeaders(self.url,parameters);
    }
    return headers;
}
- (void)availStartLoadHUD_ainmated {
    if (!self.isNone_HUD_animated) {
        if ([ResourceConfig share].startShowHUD_block)
            [ResourceConfig share].startShowHUD_block();
    }
}
- (void)availCachePolicy:(NSDictionary *)parameters {
    
    self.urlCacheKey = [ResourceX joinURL:self.url parameters:parameters];
    if (self.cachePolicy == eCachePolicy_ReadWrite) {
        NSDictionary *response = [[AFHTTPSessionTool sharedManager].cache objectForKey:self.urlCacheKey];
        
        if (response) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self parseResponse:response];
            });
        }
    }
    
}

@end



