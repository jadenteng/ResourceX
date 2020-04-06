//
//  ResourceConfig.h
//  ResourceX
//
//  Created by dqdeng on 2020/4/3.
//  Copyright © 2020 Jaden. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
///服务器返回数据格式
//   {
//     "code": "0",
//     "result": {
//                "xx": 1,
//                "xx": "xx",
//                "xx": "xx"
//                },
//      "msg": "sucess!"
//    }
/// JT_REDUXDATCODE_SUCCES_STATE  -> "0"        对应返回success block 数据状态
/// JT_REDUXDAT_CODE              -> "code"
/// JT_REDUXDAT_MSG               -> "msg"
/// JT_REDUXDATA_KEY              -> "result"

extern NSString *JT_REDUXDATA_KEY; //The key of the data dictionary returned by the network request
extern NSString *JT_REDUXDAT_MSG; //The key of the request msg
extern NSString *JT_REDUXDAT_CODE; //The key of the request code
extern NSString *JT_REDUXDATCODE_SUCCES_STATE; //The key of the request code state
extern NSString *JT_BASEK_API_SERVER; // The key of the request baseApi

typedef void(^NetWorkErrorHit)(id msg);

@interface ResourceConfig : NSObject

@property (nonatomic,copy)NetWorkErrorHit netWorkErrorHit; //net return failure hit Block
@property (nonatomic,copy)dispatch_block_t finishedHidenHUD_block; //
@property (nonatomic,copy)dispatch_block_t startShowHUD_block; //

+ (instancetype)share;

+ (void)setReduxdata_Key:(NSString *)reduxdataKey;   /// key
+ (void)setReduxdata_Msg:(NSString *)reduxdataMsg;   /// msg
+ (void)setReduxdata_Code:(NSString *)reduxdataCode; /// code
+ (void)setBasek_Api_Server:(NSString *)baseApiServer;/// Api
+ (void)setReduxdatCode_succes_State:(NSString *)reduxdatCodesuccesState; /// State

+ (void)showErrorHit:(NetWorkErrorHit)hit;//错误提示HUD

+ (void)hideHUDFinish:(dispatch_block_t)block;
+ (void)showHUDbegin:(dispatch_block_t)block;

@end

NS_ASSUME_NONNULL_END
