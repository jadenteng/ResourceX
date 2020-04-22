
<p align="center">
<img src="https://github.com/JadenTeng/ResourceX/blob/master/resourceX.png" width="168" height="52"/>
</p>

<p align="center">

<a href="https://github.com/JadenTeng/ResourceX">
<img src="https://travis-ci.com/JadenTeng/ResourceX.svg?branch=master">
</a>


<a href="https://github.com/Carthage/Carthage/">
<img src="https://img.shields.io/badge/Carthage-Compatible-4BC51D">
</a>

<a href="https://github.com/CocoaPods/CocoaPods">
<img src="https://img.shields.io/badge/CocoaPods-Compatible-orange">
</a>

</P>


## `ResourceX` 通过`AFNetworking、YYModel` 解析网络泛型编程简化网络请求 

现如今，网络通信几乎涉及每一个app程序。对于绝大多数请求HTTP API的方法,它们的执行流程都可以分成三个不同的阶段。
这种代码通常有三个特点：
1. 网络通信代码绝大部分的逻辑相同；
2. JSON序列化成Model会包含大量的类型转换；
3. 为了处理各个环节可能发生的错误，会引入大量的optional操作；

这样的流程不仅每次获取到服务器数据后都会有大量的逻辑去处理服务器返回的JSON
于是，这部分功能很容易写出复杂臃肿的函数或者逻辑，但仔细看看却又觉得没什么更好的办法。这种函数不仅看上去不美观，也难以进行单元测试

## Features
- [x] Fully build.
- [x] Simple interface.
- [x] Support access group and accessibility.

# 一. **通过泛型编程简化网络请求**

- 通过泛型编程，把请求中的这三个过程真正抽象出来，以达到进一步解耦网络请求和业务逻辑代码的目的。

#### *创建ResourceX 设置转换Model 去掉了获取复杂的获取json中逻辑,也去掉了json转为对应的model时处理逻辑*
```
导入ResourceX
#import <ResourceX/ResourceX.h>

//1. 创建ResourceX by通过key获取 数组ExpModel对象
ResourceX *netApi = [ResourceX yy_array_url:@"episodes" decoder:ExpModel.class by:@"episodes"];

//2. 发起请求
[netApi POST_AF:@{}];

//3. 获取responseObject对象  responseObject为 [ExpModel]的数组对象类型
netApi.success = ^(id  _Nullable responseObject) {
NSLog(@"转换数据:%@",responseObject);
};

// 将发生错误的逻辑剥离出来, failure block只会在请求失败调用
netApi.failure = ^(id  _Nullable responseObject) {
NSLog(@"错误原因:%@",responseObject);
};
```
提issue前，请先对照Demo、常见问题自查！Demo 在`ResourceX_Example`目录 打开ResourceX.xcodeproj 选择`ResourceX_Example`工程

使用此ResourceX需要自行添加 `AFNetworking`、`YYModel`

配置相关放在 `AppDelegate+NetworkConfiguration.m`具体可查看 demo

###  Example 例子
#### 上手指南
>注:使用sdk时需要先进行配置服务器返回的数据相关key 返回成功状态值,HUD是否需要加密等。配置相关放在 `AppDelegate+NetworkConfiguration.m`具体可查看 demo

1. 发起请求 返回Model对象
```objective-c
// 1. 配置接口url decoder解码对象:ExpModel对象
ResourceX *netApi = [ResourceX jsonUrl:@"exmple/loginModel" decoder:ExpModel.class];
// 2. 发送请求方式GET POST 
[netApi GET_AF:nil];
// 3. 这里可以返回的是ExpModel对象
netApi.success = ^(id  _Nullable responseObject) {
     NSLog(@"转换数据:%@",responseObject);
};
```
####  可选HUD配置
```objective-c
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
```
### 请求加密RSA DES 加解密 
- 传送门[ResourceCryptor](https://github.com/JadenTeng/ResourceCryptor)
```objective-c

//1. 如果项目需要请求参数需要加密 实现此方法  加密服务器参数
[ResourceConfig configer_RequestEncrypt:^NSDictionary *(NSString *url, NSDictionary   *parameters) {
    /// 将parameters转为utf8 data 或者 jsonstring
    NSData *data = parameters.json_Data_utf8;
    /// 将utf8 data 进行DES 加密z 转换为 base64字符串
    NSDictionary *en_data = @{@"en_data":data.EN_DES(key,iv).base64_encoded_string};
   /// NSLog(@"%@",en_data);
    return en_data;
 }];
 
//2. 解密服务器数据
[ResourceConfig configer_ResponseDecode:^id _Nullable(NSDictionary  *response) {
    NSLog(@"==解密服务器json数据===");
    //1. 先获取服务器解密的数据文本
     NSString *de_data = response[@"en_data"];
     if (de_data) { 
         NSString *de_str = de_data.DE_AES(key, iv);
         return de_str.JSON_Object;//将解密的json对象返回给RX
    }
    return response;
 }];
```
### Installation 安装
#### CocoaPods
```ruby
pod 'ResourceX'  
```
```ruby
pod 'ResourceX', '1.2.7'
```  
#### Carthage
```objective-c
github "JadenTeng/ResourceX"
```
#### 手动安装
> 将ResourceX文件夹拽入项目中，导入头文件：#import "Resource.h"

# 二. RSA DES 加解密 
>如果项目需要服务起请求RSA DES等加密获取数据或者项目需要用到常规加密的一些方法
不防试试我的另一个`ResourceCryptor`轻量级加解密framework 传送门:[ResourceCryptor](https://github.com/JadenTeng/ResourceCryptor)
- CocoaPods:  `pod 'ResourceCryptor'`
- Carthage: `github "JadenTeng/ResourceCryptor"`

# 三. ***简单实现OC版 map filter forEach*** (仅提供思路) 
提供工具类NSArray+Filters.m文件

在学习Swift中，函数式编程中集合类都有一个重要的思想：通过closure来参数化对序列的操作行为 如:map filter forEach reduce
当你要对Array做一些处理的时候，像C语言中类似的循环和下标，都不是理想的选择 Swift有一套自己的“现代化”手段:通过closure来参数化对数组的操作行为

### 从循环到map
一个OC中常用的遍历方法
```objective-c
/// 将一个数组中的数字 转换为一个 NSString 的数组
// 1 创建一个数组
NSMutableArray *strsList = [NSMutableArray array];
NSArray *list = @[@1,@2,@3,@4];
// 2 遍历需要转换的数组
for (NSNumber *num in list) {
//3 添加到转换NSString的数组
[strsList addObject:[NSString stringWithFormat:@"%@",num]];
}
```
虽然这个遍历不难理解，但是，想象一下这段代码在几十行代码中间的时候，或者当这样类似的逻辑反复出现的时候，整体代码的可读性就不那么强了。

#### 使用map
```objective-c
NSMutableArray *strsList_map = [@[@1,@2,@3,@4] map:^id (id num) {
return [NSString stringWithFormat:@"%@",num];}];
```
上面这行代码，和之前那段for循环执行的结果是相同的。显然，它比for循环更具表现力，并且也能把我们期望的结果定义成对象。当然，map并不是什么魔法，无非就是把for循环执行的逻辑，封装在了函数里，这样我们就可以把函数的返回值赋值给常量了

###  Release Notes 最近更新     
- 1.2.7 carthage错误
- 1.2.4 优化数据返回格式错误,demo添加请求错误
- 1.2.2 添加服务加密解密方式 demo
- 1.2.1 新增上传图片根据压缩kb上传 Demo优化
- 1.2 
- ...
