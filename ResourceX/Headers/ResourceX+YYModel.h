//
//  ResourceX+YYModel.h
//  ResourceX
//
//  Created by dqdeng on 2020/4/3.
//  Copyright © 2020 Jaden. All rights reserved.
//

#import "Resource.h"

NS_ASSUME_NONNULL_BEGIN

@interface ResourceX (YYModel)

/// json对象
+ (ResourceX *)url:(NSString *)url;
+ (ResourceX *)url:(NSString *)url by:(NSString *)key;

+ (ResourceX *)jsonUrl:(NSString *)url;
+ (ResourceX *)jsonUrl:(NSString *)url by:(NSString *)key;

/// yymodel 对象
+ (ResourceX *)yy_url:(NSString *)url decoder:(Class _Nullable)decodercls;
+ (ResourceX *)yy_url:(NSString *)url decoder:(Class _Nullable)decodercls by:(NSString *)key;

/// yymodel 数组对象
+ (ResourceX *)yy_array_url:(NSString *)url decoder:(Class _Nullable)decodercls;
+ (ResourceX *)yy_array_url:(NSString *)url decoder:(Class _Nullable)decodercls by:(NSString *)key;
+ (ResourceX *)yy_mutableArray_url:(NSString *)url decoder:(Class _Nullable)decodercls;
+ (ResourceX *)yy_mutableArray_url:(NSString *)url decoder:(Class _Nullable)decodercls by:(NSString *)key;

- (instancetype)initJsonUrl:(NSString *)url;
- (instancetype)initJsonUrl:(NSString *)url by:(NSString *)key;

- (instancetype)initJsonModel:(NSString *)url decoder:(Class _Nullable)decoderClass;
- (instancetype)initJsonModel:(NSString *)url decoder:(Class _Nullable)decoderClass by:(NSString *)key;

- (instancetype)initArrayJsonModel:(NSString *)url decoder:(Class )decoderClass;
- (instancetype)initArrayJsonModel:(NSString *)url decoder:(Class )decoderClass by:(NSString *)key;
- (instancetype)initMutableArrayJsonModel:(NSString *)url decoder:(Class )decoderClass;
- (instancetype)initMutableArrayJsonModel:(NSString *)url decoder:(Class )decoderClass by:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
