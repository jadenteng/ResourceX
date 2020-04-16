//
//  ResourceX+AFNetworking.h
//  ResourceX
//
//  Created by dqdeng on 2020/4/3.
//  Copyright © 2020 Jaden. All rights reserved.
//

#import "Resource.h"

NS_ASSUME_NONNULL_BEGIN

@interface AFHTTPSessionTool : NSObject

/// 实现网络本地缓存策略
@property (nonatomic, strong) NSCache *cache;
/// 配置header 信息
@property (nonatomic,copy)SessionHeader _Nullable  sessionHeaders;
///配置AFHTTPSessionManager 相关header信息
@property (nonatomic,strong)ConfigerAFSessionManager AF_httpSessionManager;
//压缩图片文件大小 默认压缩大小为120kb
@property (nonatomic,assign)NSInteger image_compression_kb;

+ (AFHTTPSessionTool *)sharedManager;

@end

@interface ResourceX (AFNetworking)

// 常规发起需要POST请求
- (void)POST_AF:(NSDictionary * _Nullable )parameters;
// 发起GET 请求
- (void)GET_AF:(id _Nullable)parameters;
// 发起上传图片 请求
- (void)POST_AF:(id)parameters Images:(NSArray *)images;
// 发起上传图片 请求 图片压缩大小
- (void)POST_AF:(id)parameters Images:(NSArray *)images toKb:(NSInteger)kb;

@end


NS_ASSUME_NONNULL_END
