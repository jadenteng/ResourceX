//
//  AppDelegate+NetworkConfiguration.m
//  ResourceXExp
//
//  Created by dqdeng on 2020/4/5.
//  Copyright © 2020 Jaden. All rights reserved.
//

#import "AppDelegate+NetworkConfiguration.h"
//导入RX
#import "ResourceX+AFNetworking.h"

//错误提示视图
#import "MBProgressHUD+RxErrorHit.h"

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
    
    //配置服务器反正字典的key类型
    [ResourceConfig setReduxdata_Code:@"code"];
    [ResourceConfig setReduxdata_Key:@"result"];
    [ResourceConfig setReduxdata_Msg:@"msg"];
    /// 或者直接设置
    //    JT_REDUXDATCODE = @"code";
    //    JT_REDUXDATAKEY = @"result";
    
    //配置获取网络失败 提示视图
    [ResourceConfig showErrorHit:^(id  _Nonnull msg) {
        [MBProgressHUD showAutoHudInWindow:msg];
    }];
    //设置 请求开始 加载HUD
    [ResourceConfig showHUDbegin:^{
        [MBProgressHUD showHUD_animated:YES];
    }];
    //设置请求结束 隐藏HUD
    [ResourceConfig hideHUDFinish:^{
        [MBProgressHUD hideHUD_animated:YES];
    }];
    //配置 成功时 返回数据状态code
    [ResourceConfig setReduxdatCode_succes_State:@"0"];
    
    //配置主api
    [ResourceConfig setBasek_Api_Server:@"http://mock-api.com/bKkO5MKB.mock"];
    
    //配置AF sessionHeaders
    [AFHTTPSessionTool sharedManager].sessionHeaders  = ^ NSDictionary * (NSString *url,id _Nullable parmas){
        
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
    };
    
}
@end
