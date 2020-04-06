//
//  ResourceX+AFNetworking.m
//  ResourceX
//
//  Created by dqdeng on 2020/4/3.
//  Copyright © 2020 Jaden. All rights reserved.
//

#import "ResourceX+AFNetworking.h"

static AFHTTPSessionTool *shareManager = nil;

@interface AFHTTPSessionTool () <NSCacheDelegate>
@end

@implementation AFHTTPSessionTool

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

- (void)cache:(NSCache *)cache willEvictObject:(id)obj {
}

+ (AFHTTPSessionTool *)sharedManager {
    
    if (!shareManager) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            shareManager = [AFHTTPSessionTool manager];
            [AFHTTPSessionTool configerManger:shareManager];
            [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
          
        });
    }
    return shareManager;
}

+ (void)af_configerAFHTTPSessionManager:(ConfigerManager)configerManger {
    configerManger([AFHTTPSessionTool sharedManager]);
}

+ (void)configerManger:(AFHTTPSessionManager *)manager {
    
    manager.requestSerializer.timeoutInterval = 20.0f;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json",@"multipart/form-data", @"text/javascript",@"text/html",@"text/css",@"text/xml",@"text/plain", @"application/javascript", @"image/*", nil];
    [manager.requestSerializer setValue:@"application/json; charset=utf-8;" forHTTPHeaderField:@"Content-Type"];
}

@end

@implementation ResourceX (AFNetworking)

- (void)POST_AF:(NSDictionary * _Nullable )parameters {
    [self availStartLoadHUD_ainmated];
    [self availCachePolicy:parameters];
    
    AFHTTPSessionTool *manager = [AFHTTPSessionTool sharedManager];
    manager.requestSerializer.timeoutInterval = self.timeoutInterval;
    
    [manager POST:self.url parameters:parameters headers:[self configerHeaders:parameters] progress:^(NSProgress * _Nonnull uploadProgress) {
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
    manager.requestSerializer.timeoutInterval = self.timeoutInterval;
    [manager GET:self.url parameters:parameters headers:[self configerHeaders:parameters] progress:^(NSProgress * _Nonnull downloadProgress) {
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
    manager.requestSerializer.timeoutInterval = self.timeoutInterval;
    
    NSMutableArray *scaleImageDatas = [images map:^NSData * _Nonnull(UIImage * _Nonnull image) {
        return [ResourceX scaleDataImage:image toKb:60];
    }];
    
    [manager POST:self.url parameters:parameters headers:[self configerHeaders:parameters] constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        
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



