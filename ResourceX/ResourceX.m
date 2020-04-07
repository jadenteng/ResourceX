//
//  ResourceX.m
//  ResourceX
//
//  Created by dqdeng on 2020/4/2.
//  Copyright © 2020 Jaden. All rights reserved.
//

#import "ResourceX.h"

@interface ResourceX ()
@end

@implementation ResourceX

- (NSString *)url {
    return [[NSString stringWithFormat:@"%@/%@",self.basekApiServer,_url] stringByRemovingPercentEncoding];
}

- (NSString *)basekApiServer {
    if (_basekApiServer == nil) {
        return JT_BASEK_API_SERVER;
    }
    if ([_basekApiServer isEqualToString:@""]) {
        return JT_BASEK_API_SERVER;
    }
    return _basekApiServer;
}
+ (id _Nullable)reduxData:(id)data {
    if ([JT_REDUXDATA_KEY isEqualToString:@""]) {
        return data;
    }
    return [data valueForKeyPath:JT_REDUXDATA_KEY];
}

- (NSInteger)timeoutInterval {
    if (!_timeoutInterval) {
        return 20.0f;
    }
    return _timeoutInterval;
}
/**
 获得一个网络请求对象
 
 网络请求对象
 */

- (void)callbackSuccess:(void (^)(id))success failure:(void (^)(id))failure finished:(void (^)(id))finished {
    
    if (success)
        self.success = success;
    if (failure)
        self.failure = failure;
    if (finished)
        self.finishedCallBack = finished;
}

// 设置上传进度的回调
- (void)callbackUploadProgress:(void (^)(double progress))progress {
    if (progress) {
        // self.uploadProgressCallBack = nil;
        self.uploadProgressCallBack = progress;
    }
}
// 取消请求操作
- (void)cancelOperation{
    
    self.failure = nil;
    self.finishedCallBack = nil;
    self.success = nil;
    
}
// 解析服务器的返回数据
- (void)parseResponse:(id)responseObject {
    
    if ([ResourceConfig share].finishedHidenHUD_block)
        [ResourceConfig share].finishedHidenHUD_block();
    
    if ([responseObject isKindOfClass:[NSError class]]) {
        
        NSError *error = responseObject;
        NSString  *code = [NSString stringWithFormat:@"%ld",(long)error.code];
        NSDictionary *result = error.userInfo;
        if (error.code == 404) {
            // 资源不存在
            responseObject = @{JT_REDUXDATA_KEY: result, JT_REDUXDAT_MSG: @"服务器异常", JT_REDUXDAT_CODE: code};
        } else if (error.code == -1001) {
            // 请求超时
            responseObject = @{JT_REDUXDATA_KEY: result, JT_REDUXDAT_MSG: @"请求超时", JT_REDUXDAT_CODE: code};
            
        } else {
            
            if (error.code == -1004) {
                responseObject = @{JT_REDUXDATA_KEY: result, JT_REDUXDAT_MSG: @"未能连接到服务器", JT_REDUXDAT_CODE: code};
            } else
                if (error.code == -1003 ||  error.code == -1200) {
                    
                    responseObject = @{JT_REDUXDATA_KEY: result, JT_REDUXDAT_MSG: @"当前网络不稳定,无法连接服务器", JT_REDUXDAT_CODE: code};
                    
                } else if (error.code == -1011  ) {
                    
                    responseObject = @{JT_REDUXDATA_KEY: result, JT_REDUXDAT_MSG: @"服务器连接无响应", JT_REDUXDAT_CODE: code};
                }
                else if ( error.code == -1009 ) {
                    
                    
                    responseObject = @{JT_REDUXDATA_KEY: result, JT_REDUXDAT_MSG: @"当前网络未连接", JT_REDUXDAT_CODE: code};
                } else {
                    
                    responseObject = @{JT_REDUXDATA_KEY: result, JT_REDUXDAT_MSG:[NSString stringWithFormat:@"未知异常错误无法访问数据,code=%@",code] , JT_REDUXDAT_CODE: code};
                }
        }
        
    }
    
    NSString *code = [NSString stringWithFormat:@"%@",responseObject[JT_REDUXDAT_CODE]];
    
    if ([code isEqualToString:JT_REDUXDATCODE_SUCCES_STATE]) {
        if (self.isShow_success_Hit) {
            if ([ResourceConfig share].netWorkErrorHit_block)
                [ResourceConfig share].netWorkSuccessHit_block(responseObject[JT_REDUXDAT_MSG], self.tag);
        }
        if (self.success) {
            self.success(self.parser(responseObject));
        }
    } else {
        
        if (!self.isHidden_failure_errorHit) {
            if ([ResourceConfig share].netWorkErrorHit_block)
                [ResourceConfig share].netWorkErrorHit_block(responseObject[JT_REDUXDAT_MSG],self.tag);
            
        }
        
        NSLog(@"%@",responseObject);
        if (self.failure) {
            self.failure(responseObject);
        }
        
        if (self.uploadProgressCallBack) {
            self.uploadProgressCallBack(0.0f);
            self.uploadProgressCallBack = nil;
        }
    }
    
    if (self.finishedCallBack)
        self.finishedCallBack(responseObject);
    
    //  [self cancelOperation];
    
}

@end

@implementation ResourceX (Common)
// 拼接URL
+ (NSString *)joinURL:(NSString *)url parameters:(NSDictionary *)parameters {
    if (parameters && [parameters.allKeys count] > 0) {
        NSMutableArray *parametersArray = [NSMutableArray arrayWithCapacity:0];
        for (NSString *key in parameters.allKeys) {
            [parametersArray addObject:[NSString stringWithFormat:@"%@=%@", key, [ResourceX urlEncodedString:[NSString stringWithFormat:@"%@", [parameters objectForKey:key]]]]];
        }
        if ([parametersArray count] > 0)
            return [NSString stringWithFormat:@"%@%@%@", url, [[url componentsSeparatedByString:@"?"] count] > 1 ? @"&" : @"?", [parametersArray componentsJoinedByString:@"&"]];
    }
    
    return url;
}
// url编码
+ (NSString *)urlEncodedString:(NSString *)string {
    NSCharacterSet *encodeUrlSet = [NSCharacterSet URLQueryAllowedCharacterSet];
    NSString *encodeUrl = [string stringByAddingPercentEncodingWithAllowedCharacters:encodeUrlSet];
    return encodeUrl;
}

- (void)GET {
    
    [[[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:self.url] completionHandler:^(NSData * _Nullable data, NSURLResponse *  response, NSError * _Nullable error) {
        
        ///   NSString *jsonStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSDictionary *json;
        if (error) {
            json = error.userInfo;
        } else {
            json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        }
        [self parseResponse:json];
        
    }] resume];
}
@end

#import <UIKit/UIKit.h>

@implementation ResourceX (ImageData)

+ (NSString *)base64:(NSData *)data {
    return [data base64EncodedStringWithOptions:0];
}

+ (NSString *)createUUID {
    CFUUIDRef udid = CFUUIDCreate(NULL);
    CFStringRef string = CFUUIDCreateString(NULL, udid);
    NSString *udidStr = (__bridge NSString *)string;
    udidStr = [udidStr stringByReplacingOccurrencesOfString:@"-" withString:@""];
    CFRelease(udid);
    CFRelease(string);
    
    return udidStr;
}


+ (NSData *)scaleDataImage:(UIImage *)image toKb:(NSInteger)kb{
    
    NSInteger toKb = kb;
    NSData *imageData = UIImageJPEGRepresentation(image, 1);
    
    if (imageData.length/1024.0f < kb) return imageData;
    if (imageData.length/1024.0f < 100) return imageData;
    if (kb < 1) {
        return imageData;
    }
    kb *= 1024;
    
    CGFloat compression = 0.9f;
    CGFloat maxCompression = 0.1f;
    NSData *imgData = UIImageJPEGRepresentation(image, compression);
    while ([imgData length] > kb && compression > maxCompression) {
        compression -= 0.1;
        imgData = UIImageJPEGRepresentation(image, compression);
    }
    
    if (imgData.length/1024.0f > 100.0f ) {
        
        UIImage *resultImage = [UIImage imageWithData:imgData];
        CGFloat ratio = 0.1;
        CGSize size = CGSizeMake((NSUInteger)(resultImage.size.width * sqrtf(ratio)),
                                 (NSUInteger)(resultImage.size.height * sqrtf(ratio))); // Use NSUInteger to prevent white blank
        UIGraphicsBeginImageContext(size);
        [resultImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
        resultImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        toKb*=1024;
        
        CGFloat compression = 0.9f;
        CGFloat maxCompression = 0.1f;
        
        NSData *saclData = UIImageJPEGRepresentation(resultImage, compression);
        while ([saclData length] > kb && compression > maxCompression) {
            compression -= 0.1;
            saclData = UIImageJPEGRepresentation(resultImage, compression);
        }
        saclData = UIImageJPEGRepresentation(resultImage, compression);
        
        return saclData;
    }
    
    return imgData;
}

@end
