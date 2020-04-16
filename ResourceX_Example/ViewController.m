//
//  ViewController.m
//  ResourceXExp
//
//  Created by dqdeng on 2020/4/3.
//  Copyright © 2020 Jaden. All rights reserved.
//

#import "ViewController.h"

#import "ResourceX.h"
///model 相关类
#import "Episodes.h"
#import "LoginModel.h"
#import "PelistInfoModel.h"
#import <ResourceCryptor/ResourceCryptor.h>
@interface ViewController ()
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)initJsonUrl {
    
    ResourceX *netApi = [ResourceX jsonUrl:@"exmple/dict"];
    netApi.timeoutInterval = 15;
    
    [netApi GET_AF:nil];
    
    netApi.success = ^(id  _Nullable responseObject) {
        NSLog(@"转换数据:%@",responseObject);
    };
    netApi.failure = ^(id  _Nullable responseObject) {
        NSLog(@"数据错误:%@",responseObject);
    };
    netApi.finishedCallBack = ^(id  _Nullable responseObject) {
        NSLog(@"源数据:%@",responseObject);
    };
    
    /*
     [netApi callbackSuccess:^(id  _Nullable responseObject) {
     NSLog(@"%@",responseObject); ///数据获取成功走 callbackSuccess block
     } failure:^(id  _Nullable responseObject) {
     ///数据获取失败走 failure block
     } finished:^(id  _Nullable responseObject) {
     ///数据不论成功或者失败都会此block
     NSLog(@"finished%@",responseObject);
     }];
     */
}
- (void)initJsonUrlByKey {
    
    ResourceX *netApi = [ResourceX jsonUrl:@"exmple/dicByKey" by:@"rows"];
    
    [netApi GET_AF:nil];
    
    netApi.success = ^(id  _Nullable responseObject) {
        NSLog(@"转换数据:%@",responseObject);
    };
    
    netApi.finishedCallBack = ^(id  _Nullable responseObject) {
        NSLog(@"源数据:%@",responseObject);
    };
    
    /// success获取 json 数据源中listInfo 数据
    ResourceX *netApi2 = [[ResourceX alloc] initJsonUrl:@"exmple/dicByKey" by:@"banners.listInfo"];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"===================================================");
        [netApi2 GET_AF:nil];
    });
    
    netApi2.success = ^(id  _Nullable responseObject) {
        NSLog(@"转换数据:%@",responseObject);
    };
    
    netApi2.finishedCallBack = ^(id  _Nullable responseObject) {
        NSLog(@"源数据:%@",responseObject);
    };
}

- (void)initJsonModelUrl {
    
    ResourceX *netApi = [ResourceX yy_url:@"exmple/loginModel" decoder:LoginModel.class];
    
    [netApi GET_AF:@{}];
    
    [netApi callbackSuccess:^(id  _Nullable responseObject) {
        NSLog(@"转换数据:%@",responseObject);
    } failure:^(id  _Nullable responseObject) {
        
    } finished:^(id  _Nullable responseObject) {
        
    }];
}

- (void)initJsonModelUrlByKey {
    
    ResourceX *netApi = [ResourceX yy_url:@"exmple/dicByKey" decoder:PelistInfoModel.class by:@"banners.listInfo"];
    
    [netApi GET_AF:@{}];
    [netApi callbackSuccess:^(id  _Nullable responseObject) {
        NSLog(@"转换数据:%@",responseObject);
    } failure:^(id  _Nullable responseObject) {
    } finished:^(id  _Nullable responseObject) {
    }];
}

- (void)initJsonModelArrayUrl {
    
    ResourceX *netApi = [ResourceX yy_array_url:@"episodes" decoder:Episodes.class by:@"episodes"];
    
    [netApi GET_AF:@{}];
    [netApi callbackSuccess:^(id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
    } failure:^(id  _Nullable responseObject) {
    } finished:^(id  _Nullable responseObject) {
        NSLog(@"源数据:%@",responseObject);
    }];
}

- (void)eCachePolicy_ReadWrite {
    
    ResourceX *netApi = [ResourceX yy_array_url:@"episodes" decoder:Episodes.class by:@"episodes"];
    NSLog(@"eCachePolicy_ReadWrite状态,写入数据将会缓存到磁盘,如果缓存中有数据那么就会有两次回调 2次 2次 2次");
    netApi.cachePolicy = eCachePolicy_ReadWrite;
    [netApi GET_AF:@{}];
    [netApi callbackSuccess:^(id  _Nullable responseObject) {
        NSLog(@"转换数据%@",responseObject);
    } failure:^(id  _Nullable responseObject) {
    } finished:^(id  _Nullable responseObject) {
        NSLog(@"源数据:%@",responseObject);
    }];
}
- (void)eCachePolicy_WriteOnly {
    
    ResourceX *netApi = [ResourceX yy_array_url:@"episodes" decoder:Episodes.class by:@"episodes"];
    netApi.tag = 1;
    netApi.cachePolicy = eCachePolicy_WriteOnly;
    netApi.isShow_success_Hit = YES; //获取网络成功 显示HUD提示
    NSLog(@"写入数据将会缓存到磁盘");
    [netApi GET_AF:@{}];
    [netApi callbackSuccess:^(id  _Nullable responseObject) {
        NSLog(@"转换数据%@",responseObject);
    } failure:^(id  _Nullable responseObject) {
    } finished:^(id  _Nullable responseObject) {
        NSLog(@"源数据:%@",responseObject);
    }];
}

- (void)isHUD_animated {
    
    ResourceX *netApi = [ResourceX yy_array_url:@"episodes" decoder:Episodes.class by:@"episodes"];
    netApi.cachePolicy = eCachePolicy_NotHandle;
    netApi.isNone_HUD_animated = YES; ///设置不需要加载HUD
    netApi.isHidden_failure_errorHit = YES;// 设置当请求发送错误是不需要提示HUD
    
    [netApi GET_AF:@{}];
    [netApi callbackSuccess:^(id  _Nullable responseObject) {
        NSLog(@"转换数据%@",responseObject);
    } failure:^(id  _Nullable responseObject) {
    } finished:^(id  _Nullable responseObject) {
        NSLog(@"源数据:%@",responseObject);
    }];
}


/// 配置的加密 在AppDelegate+NetworkConfiguration.m 文件
- (void)isRSADES {
    
    ResourceX *netApi = [ResourceX yy_array_url:@"AES" decoder:Episodes.class by:@"episodes"];
    
    [netApi GET_AF:@{@"key":@"hello"}];
    
    [netApi callbackSuccess:^(id  _Nullable responseObject) {
        
    } failure:^(id  _Nullable responseObject) {
    } finished:^(id  _Nullable responseObject) {
        NSLog(@"源数据:%@",responseObject);
    }];
    
    [self isAES_NO];
}
/// 配置的加密 在AppDelegate+NetworkConfiguration.m 文件
- (void)isAES_NO {
    
    ResourceX *netApi = [ResourceX yy_array_url:@"episodes" decoder:Episodes.class by:@"episodes"];
    /// 注: 如果没有配置configer_RequestEncrypt方法 不需要设置isEncrypt_Param
    ///              configer_RequestEncrypt    不需要设置isDecode_Response
    netApi.isEncrypt_Param = NO; //设置参数不进行加密
    netApi.isDecode_Response = NO; //设置服务器返回数据不需要解密
    [netApi GET_AF:@{@"key":@"hello"}];
    
    [netApi callbackSuccess:^(id  _Nullable responseObject) {
        
    } failure:^(id  _Nullable responseObject) {
    } finished:^(id  _Nullable responseObject) {
        NSLog(@"源数据:%@",responseObject);
    }];
}

- (void)isfailure {
    
    ResourceX *netApi = [ResourceX yy_array_url:@"xxx" decoder:Episodes.class by:@"episodes"];
    netApi.isEncrypt_Param = NO;
    netApi.isDecode_Response = NO;
    [netApi GET_AF:@{@"key":@"hello"}];
    
    netApi.failure = ^(id  _Nullable responseObject) {
        NSLog(@"failure:%@",responseObject);
    };
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
       
        ResourceX *netApi2 = [ResourceX url:@"xx"];
        netApi2.basekApiServer = @"http://ssss";
        [netApi2 GET_AF:nil];
        netApi2.failure = ^(id  _Nullable responseObject) {
            NSLog(@"failure:%@",responseObject);
        };
    });
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0: //字典类型
            [self initJsonUrl];
            break;
        case 1: //字典带有key
            [self initJsonUrlByKey];
            break;
        case 2: //转换model
            [self initJsonModelUrl];
            break;
        case 3: ////转换model by key
            [self initJsonModelUrlByKey];
            break;
        case 4: /// 转换model数组类型
            [self initJsonModelArrayUrl];
            break;
        case 5: /// 读写
            [self eCachePolicy_ReadWrite];
            break;
        case 6: /// 写入
            [self eCachePolicy_WriteOnly];
            break;
        case 7: ///
            [self isHUD_animated];
            break;
        case 8: ///
            [self isRSADES];
            break;
            
        case 9: ///
            
            [self isfailure];
            break;
            
        default:
            break;
    }
}

@end
