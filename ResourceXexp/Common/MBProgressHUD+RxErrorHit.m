//
//  MBProgressHUD+RxErrorHit.m
//  ResourceXExp
//
//  Created by dqdeng on 2020/4/5.
//  Copyright © 2020 Jaden. All rights reserved.
//

#import "MBProgressHUD+RxErrorHit.h"

@implementation MBProgressHUD (RxErrorHit)
#define NSStringValided(a) (((NSNull *)a == [NSNull null] || a == nil) ? @"" : a)

// 居中显示HUD视图到Window (自动消失)
+ (void)showAutoHudInWindow:(NSString *)hint {
    hint = NSStringValided(hint);
   
    dispatch_async(dispatch_get_main_queue(), ^{
        
        UIWindow *window =  [[[UIApplication sharedApplication] windows] firstObject];
        [MBProgressHUD hideHUDForView:window animated:NO];
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:window animated:YES];
        hud.translatesAutoresizingMaskIntoConstraints = NO;
        NSLayoutConstraint *hCenter = [hud.centerXAnchor constraintEqualToAnchor:window.centerXAnchor];
        NSLayoutConstraint *bottom = [hud.bottomAnchor constraintEqualToAnchor:window.safeAreaLayoutGuide.bottomAnchor constant: 10];
        [NSLayoutConstraint activateConstraints:@[hCenter,bottom]];
        
        hud.userInteractionEnabled = NO;
        hud.mode = MBProgressHUDModeText;
        hud.detailsLabel.text = hint;
        hud.detailsLabel.font = [UIFont systemFontOfSize:14.0];
        hud.detailsLabel.textColor = UIColor.labelColor;
        hud.removeFromSuperViewOnHide = YES;
        hud.margin = 10.0;
        hud.bezelView.layer.cornerRadius = 5;
        [hud hideAnimated:YES afterDelay:2.0];
    });
}

+ (void)showHUD_animated:(BOOL)animated {
    [MBProgressHUD showHUDAddedTo:[[[UIApplication sharedApplication] windows] firstObject] animated:animated];
}

+ (void)hideHUD_animated:(BOOL)animated {
    [MBProgressHUD hideHUDForView:[[[UIApplication sharedApplication] windows] firstObject] animated:animated];
}


@end
