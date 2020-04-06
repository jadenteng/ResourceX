//
//  ResourceX.h
//  ResourceX
//
//  Created by dqdeng on 2020/4/3.
//  Copyright © 2020 Jaden. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ResourceConfig.h"
#import "NSMutableArray+Filters.h"

@class UIImage;
typedef void(^RequestCallBack)(id _Nullable responseObject);
typedef void(^UploadProgressCallBack)(double progress);
typedef id _Nullable (^Parser)(id _Nullable data);
typedef NSDictionary* _Nullable (^SessionHeader)(NSString * _Nullable  url,id _Nullable param);

/*!
 @enum
 @brief 缓存策略
 @constant eCachePolicy_NotHandle 不作处理
 @constant eCachePolicy_ReadWrite 可读可写
 @constant eCachePolicy_WriteOnly 只写
 */
typedef NS_ENUM(NSInteger, JTCachePolicy) {
    
    eCachePolicy_NotHandle = 0,
    eCachePolicy_ReadWrite = 1,
    eCachePolicy_WriteOnly = 2,
};

@interface  ResourceX: NSObject

@property (nonatomic,strong)NSString * _Nullable basekApiServer; //
@property (nonatomic,strong)NSString * _Nullable url; //
@property (nonatomic,assign)NSInteger timeoutInterval; //

@property (nonatomic,assign)BOOL isHiddenErrorHit; //
@property (nonatomic,assign)BOOL isNone_HUD_animated; //


@property (nonatomic,copy)Parser _Nullable parser; //
@property (nonatomic,copy)RequestCallBack _Nullable success; //
@property (nonatomic,copy)RequestCallBack _Nullable failure; //
@property (nonatomic,copy)RequestCallBack _Nullable finishedCallBack; //
///上传进度回调
@property (nonatomic) UploadProgressCallBack _Nullable uploadProgressCallBack;

/**
 *  缓存策略(默认不作任何处理) 开启读写操作 有缓存block会调用两次
 */
@property (nonatomic, assign) JTCachePolicy cachePolicy;
//设置缓存key
@property (nonatomic,strong) NSString * _Nullable urlCacheKey;


- (void)callbackSuccess:(RequestCallBack _Nullable )success failure:(RequestCallBack _Nullable )failure finished:(RequestCallBack _Nullable )finished;
/// 设置上传进度的回调
- (void)callbackUploadProgress:(UploadProgressCallBack _Nullable )progress;
/// 取消请求操作
- (void)cancelOperation;
/// 解析服务器的返回数据
- (void)parseResponse:(id _Nullable )responseObject;
+ (id _Nullable )reduxData:(id _Nullable )data;


@end

@interface ResourceX (Common)
// 拼接URL
+ (NSString *_Nullable)joinURL:(NSString *_Nullable)url parameters:(NSDictionary *_Nullable)parameters;

- (void)GET;

@end


@interface ResourceX (ImageData)

+ (NSString *_Nullable)base64:(NSData *_Nullable)data;
+ (NSString *_Nullable)createUUID;

/// 图片压缩
/// @param image UIImage
/// @param kb 压缩kb
+ (NSData *_Nullable)scaleDataImage:(UIImage *_Nullable)image toKb:(NSInteger)kb;

@end
