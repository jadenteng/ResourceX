//
//  ResourceConfig.m
//  ResourceX
//
//  Created by dqdeng on 2020/4/3.
//  Copyright © 2020 Jaden. All rights reserved.
//

#import "ResourceConfig.h"
#import "ResourceX.h"
#import "ResourceX+AFNetworking.h"

NSString *JT_REDUXDATA_KEY = @"result";
NSString *JT_REDUXDAT_MSG = @"msg";
NSString *JT_REDUXDAT_CODE = @"code";
NSString *JT_REDUXDATCODE_SUCCES_STATE = @"0";
NSString *JT_BASEK_API_SERVER = @"";

//如果服务器有加密返回数据
//NSString *JT_EnryptedResponse_Key = @"en_data";

static ResourceConfig *shareinstance = nil;

@implementation ResourceConfig

+ (ResourceConfig *)share {
    
    if (!shareinstance) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            shareinstance = [[ResourceConfig alloc] init];
        });
    }
    return shareinstance;
}

+ (void)setReduxdata_Key:(NSString *)reduxdataKey {
    JT_REDUXDATA_KEY = reduxdataKey;
}

+ (void)setReduxdata_Msg:(NSString *)reduxdataMsg {
    JT_REDUXDAT_MSG = reduxdataMsg;
}

+ (void)setReduxdata_Code:(NSString *)reduxdataCode {
    JT_REDUXDAT_CODE = reduxdataCode;
}

+ (void)setReduxdatCode_succes_State:(NSString *)reduxdatCodesuccesState {
    JT_REDUXDATCODE_SUCCES_STATE = reduxdatCodesuccesState;
}

+ (void)setBasek_Api_Server:(NSString *)baseApiServer {
    
    JT_BASEK_API_SERVER = baseApiServer;
}
//+ (void)setReduxdat_EnryptedResponse_Key:(NSString *)enryptedResponse_Key {
//    JT_EnryptedResponse_Key = enryptedResponse_Key;
//}

+ (void)configer_showErrorHit:(NetWorkHitBlock)hit {
    [ResourceConfig share].netWorkErrorHit_block = hit;
}
+ (void)configer_showSuccessHit:(NetWorkHitBlock)hit {
    [ResourceConfig share].netWorkSuccessHit_block = hit;
}

+ (void)configer_hideHUD_Finish:(dispatch_block_t)block {
     [ResourceConfig share].finishedHidenHUD_block  = block;
}
+ (void)configer_showHUD_Begin:(dispatch_block_t)block {
     [ResourceConfig share].startShowHUD_block = block;
}

+ (void)configerAFHTTPSessionManager:(ConfigerAFSessionManager)httpSssionManager {
    [AFHTTPSessionTool sharedManager].AF_httpSessionManager = httpSssionManager;
}
+ (void)configerSessionHeader:(SessionHeader)headers {
    [AFHTTPSessionTool sharedManager].sessionHeaders = headers;
}

+ (void)configerRequestParametersAES:(SessionHeader)requestParametersAES_block {
    [ResourceConfig share].requestParametersAES_block = requestParametersAES_block;
}
///服务器加密数据 解密json
+ (void)configerResponseDecryptor:(ResponseDecryptor)responseDecryptor_block {
    [ResourceConfig share].responseDecryptor_block = responseDecryptor_block;
}

@end
