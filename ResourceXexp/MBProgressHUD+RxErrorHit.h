//
//  MBProgressHUD+RxErrorHit.h
//  ResourceXExp
//
//  Created by dqdeng on 2020/4/5.
//  Copyright © 2020 Jaden. All rights reserved.
//

#import <MBProgressHUD/MBProgressHUD.h>

NS_ASSUME_NONNULL_BEGIN

@interface MBProgressHUD (RxErrorHit)
//服务器返回失败异常数据
+ (void)showAutoHudInWindow:(NSString *)hint;

+ (void)showHUD_animated:(BOOL)animated;
+ (void)hideHUD_animated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
