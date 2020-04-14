//
//  AppDelegate+NetworkConfiguration.m
//  ResourceXExp
//
//  Created by dqdeng on 2020/4/5.
//  Copyright © 2020 Jaden. All rights reserved.
//

#import "AppDelegate+NetworkConfiguration.h"
//导入RX
#import "Resource.h"
//错误提示视图
#import "MBProgressHUD+RxErrorHit.h"
#import <AFNetworking/AFNetworking.h>

//如果有加密的需求r导入 pod 'ResourceCryptor' 或者 github "JadenTeng/ResourceCryptor"
#import <ResourceCryptor/ResourceCryptor.h>

@implementation AppDelegate (NetworkConfiguration)

- (void)networkConfiguration {
    /*
     {
     "code": "0",
     "result": {
     "name": 1,
     "email": "datas",
     "mobile": "datas"
     },
     "msg": "sucess!"
     }
     */
    
    /// 注:这里我把数据返回的格式暴露给用户自己设定
    ///    把数据返回的格式相关进行设置,因为不同公司服务器的返回数据格式不同
    
    //配置服务器返回字典的key
    [ResourceConfig setReduxdata_Code:@"code"];
    [ResourceConfig setReduxdata_Key:@"result"];
    [ResourceConfig setReduxdata_Msg:@"msg"];
    /// 或者直接设置
    //    JT_REDUXDATCODE = @"code";
    //    JT_REDUXDATAKEY = @"result";
    
    //配置 成功时 返回数据状态code
    [ResourceConfig setReduxdatCode_succes_State:@"0"];
    //配置主api
    [ResourceConfig setBasek_Api_Server:@"http://mock-api.com/bKkO5MKB.mock"];
    
    ///设置 AFHTTPSessionManager 需要导入AFNetworking 4.0以上版本
    [ResourceConfig configerAFHTTPSessionManager: ^AFHTTPSessionManager *{
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json",@"multipart/form-data", @"text/javascript",@"text/html",@"text/css",@"text/xml",@"text/plain", @"application/javascript", @"image/*", nil];
        [manager.requestSerializer setValue:@"application/json; charset=utf-8;" forHTTPHeaderField:@"Content-Type"];
        
        return manager;
    }];
    
    //配置AF sessionHeaders *一般服务器都会设置请求header参数 如果没有header参数设置可不实现此方法
    [ResourceConfig configerSessionHeader:^ NSDictionary * (NSString *url,id _Nullable parmas){
        
        NSDictionary *afHeaders = @{@"sign":@"xxxx",
                                    @"userToken":@"TokenXXX",
                                    @"appType":@"iOS",
        
        };
        // NSLog(@"%@\n%@",url,afHeaders);
        return afHeaders;
    }];
    
     #define key              @"iojyxgas+x*$a$*s"
     #define iv               @"bbc077ccff5c1ab8"
    ///-------------------------针对加密 请求参数 服务返回数据解密 ---------------------------
    /// 如果项目需要请求参数需要加密 实现此方法
    [ResourceConfig configer_RequestEncrypt:^NSDictionary *(NSString *url, NSDictionary   *parameters) {
    
        NSLog(@"===请求参数加密操作===");
        /// 将parameters转为utf8 data 或者 jsonstring
        NSData *data = parameters.json_Data_utf8;
        /// 将utf8 data 进行DES 加密z 转换为 base64字符串
        NSDictionary *en_data = @{@"en_data":data.EN_DES(key,iv).base64_encoded_string};
       /// NSLog(@"%@",en_data);
        return en_data;
    }];
    
    ///如果需要服务器返回数据解密 这里配置 如果服务器返回的数据需要解密在实现此方法
    [ResourceConfig configer_ResponseDecode:^id _Nullable(NSDictionary  *response) {
        NSLog(@"==解密服务器json数据===");
        //先获取服务器解密的数据文本
         NSString *de_data = response[@"en_data"];
         if (de_data) {
             /// 解密前的数据
             NSLog(@"解密前:%@",response);
    
             NSString *de_str = de_data.DE_AES(key, iv);
             NSLog(@"解密后:%@",de_str.JSON_Object);
             return de_str.JSON_Object;
        }

        return response;
    }];
    
    ///-------------------------可选---------------------------
    //配置获取网络失败 提示HUD 可自定义实现 HUD
    [ResourceConfig configer_showErrorHit:^(id  _Nonnull msg, NSInteger tag) {
        [MBProgressHUD showAutoHudInWindow:msg];
    }];
    //配置获取网络成功 提示HUD
    [ResourceConfig configer_showSuccessHit:^(id  _Nonnull msg, NSInteger tag) {
        if (tag == 1) {
            [MBProgressHUD showAutoHudInWindow:msg];
        }
    }];
    //设置 请求开始 加载HUD
    [ResourceConfig configer_showHUD_Begin:^{
        [MBProgressHUD showHUD_animated:YES];
    }];
    //设置请求结束 隐藏HUD
    [ResourceConfig configer_hideHUD_Finish:^{
        [MBProgressHUD hideHUD_animated:YES];
    }];
}



@end
