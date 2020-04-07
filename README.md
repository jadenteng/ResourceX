# ResourceX
ResourceX 通过AFNetworking、YYModel 解析   网络类封装
致力于对网络请求的简化,实现灵活可变的网络请求类


## 提示：提issue前，请先对照Demo、常见问题自查！Demo 在ResourceX_Example目录。
使用此类需要自行添加 AFNetworking、YYModel
配置网络放在 AppDelegate+NetworkConfiguration.m具体可查看 demo


## 一. Installation 安装

#### CocoaPods
> pod 'ResourceX'   #iOS9 and later        
> pod 'ResourceX', '1.2.1'  

#### Carthage
> github "JadenTeng/ResourceX"

#### 手动安装
> 将ResourceX文件夹拽入项目中，导入头文件：#import "Resource.h"

## 二. Example 例子

#### 列:服务器返回格式
```
{
   "code": "0",
   "result": {
              "name": 1,
              "email": "datas",
              "mobile": "datas"
             },
    "msg": "sucess!"
}

```
#### 配置服务器相关key 返回成功状态值

```//配置服务器返回字典的key
[ResourceConfig setReduxdata_Code:@"code"];
[ResourceConfig setReduxdata_Key:@"result"];
[ResourceConfig setReduxdata_Msg:@"msg"];

//配置 成功时 返回数据状态code
[ResourceConfig setReduxdatCode_succes_State:@"0"];
//配置主api
[ResourceConfig setBasek_Api_Server:@"http://mock-api.com/bKkO5MKB.mock"];
///设置 AFHTTPSessionManager
[ResourceConfig configerAFHTTPSessionManager: ^AFHTTPSessionManager *{}];
//配置AF sessionHeaders *服务器header需要的参数设置
[ResourceConfig configerSessionHeader:^ NSDictionary * (NSString *url,id _Nullable parmas){}];
```
####  可选HUD配置
``` //配置获取网络失败 提示HUD 可自定义实现 HUD
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
```
##  Release Notes 最近更新     
1.2.1 新增上传图片根据压缩kb上传 Demo优化
1.2 
...
