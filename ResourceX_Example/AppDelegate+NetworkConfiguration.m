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

#define FormatTime(date) [NSString stringWithFormat:@"%.0lf",([date timeIntervalSince1970]*1000)]

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
    
    ///设置 AFHTTPSessionManager
    [ResourceConfig configerAFHTTPSessionManager: ^AFHTTPSessionManager *{
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json",@"multipart/form-data", @"text/javascript",@"text/html",@"text/css",@"text/xml",@"text/plain", @"application/javascript", @"image/*", nil];
        [manager.requestSerializer setValue:@"application/json; charset=utf-8;" forHTTPHeaderField:@"Content-Type"];
        
        return manager;
    }];
    
    //配置AF sessionHeaders *服务器header需要的参数设置
    [ResourceConfig configerSessionHeader:^ NSDictionary * (NSString *url,id _Nullable parmas){
        
        NSString *accountId = @"" ;
        NSString *userToken = @"" ;
        NSString *timestamp = FormatTime([NSDate date]);
        NSString *idfa = @"";
        NSDictionary *afHeaders = @{@"sign":@"xxxx",
                                    @"devicetoken":idfa,
                                    @"dataToken":idfa,
                                    @"accountId":accountId,
                                    @"userToken":userToken,
                                    @"timestamp":timestamp,
                                    @"ostype":@"iOS",
                                    @"appType":@"",
                                    @"packageCode":@"HQD"
        };
        // NSLog(@"%@\n%@",url,afHeaders);
        return afHeaders;
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
