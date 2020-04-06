//
//  ResourceConfig.m
//  ResourceX
//
//  Created by dqdeng on 2020/4/3.
//  Copyright © 2020 Jaden. All rights reserved.
//

#import "ResourceConfig.h"
#import "ResourceX.h"

NSString *JT_REDUXDATA_KEY = @"result";
NSString *JT_REDUXDAT_MSG = @"msg";
NSString *JT_REDUXDAT_CODE = @"code";
NSString *JT_REDUXDATCODE_SUCCES_STATE = @"0";
NSString *JT_BASEK_API_SERVER = @"";

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

+ (void)showErrorHit:(NetWorkErrorHit)hit {
    [ResourceConfig share].netWorkErrorHit = hit;
}

+ (void)hideHUDFinish:(dispatch_block_t)block {
     [ResourceConfig share].finishedHidenHUD_block  = block;
}
+ (void)showHUDbegin:(dispatch_block_t)block {
     [ResourceConfig share].startShowHUD_block = block;
}

@end
