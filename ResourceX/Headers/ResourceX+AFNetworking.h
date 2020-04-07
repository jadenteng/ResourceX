//
//  ResourceX+AFNetworking.h
//  ResourceX
//
//  Created by dqdeng on 2020/4/3.
//  Copyright © 2020 Jaden. All rights reserved.
//

#import "ResourceX.h"

//#import <AFNetworking/AFNetworking.h>


NS_ASSUME_NONNULL_BEGIN

@interface AFHTTPSessionTool : NSObject

/// 实现网络本地缓存策略
@property (nonatomic, strong) NSCache *cache;
/// 配置header 信息
@property (nonatomic,copy)SessionHeader _Nullable  sessionHeaders;

///配置AFHTTPSessionManager 相关header信息
@property (nonatomic,strong)ConfigerAFSessionManager AF_httpSessionManager; //

+ (AFHTTPSessionTool *)sharedManager;

@end

@interface ResourceX (AFNetworking)

// 常规发起需要POST请求
- (void)POST_AF:(NSDictionary * _Nullable )parameters;
// 发起GET 请求
- (void)GET_AF:(id _Nullable)parameters;
// 发起上传图片 请求
- (void)POST_AF:(id)parameters Images:(NSArray *)images;

@end



NS_ASSUME_NONNULL_END
