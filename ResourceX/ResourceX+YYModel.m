//
//  ResourceX+YYModel.m
//  ResourceX
//
//  Created by dqdeng on 2020/4/3.
//  Copyright © 2020 Jaden. All rights reserved.
//

#import "ResourceX+YYModel.h"

@protocol ClassTransformprotocol <NSObject>

+ (nullable instancetype)yy_modelWithJSON:(id)json;
+ (nullable NSArray *)yy_modelArrayWithClass:(Class)cls json:(id)json;

@end
@interface NSArray ()<ClassTransformprotocol>

@end

@implementation ResourceX (YYModel)

+ (ResourceX *)url:(NSString *)url {
    return [[self alloc] initJsonUrl:url];
}
+ (ResourceX *)url:(NSString *)url by:(NSString *)key {
    return [[self alloc] initJsonUrl:url by:key];
}
+ (ResourceX *)jsonUrl:(NSString *)url {
    return [[self alloc] initJsonUrl:url];
}
+ (ResourceX *)jsonUrl:(NSString *)url by:(NSString *)key {
    return [[self alloc] initJsonUrl:url by:key];
}
+ (ResourceX *)yy_url:(NSString *)url decoder:(Class _Nullable)decodercls {
    return [[self alloc] initJsonModel:url decoder:decodercls];
}
+ (ResourceX *)yy_url:(NSString *)url decoder:(Class _Nullable)decodercls by:(NSString *)key {
    return [[self alloc] initJsonModel:url decoder:decodercls by:key];
}
+ (ResourceX *)yy_array_url:(NSString *)url decoder:(Class _Nullable)decodercls {
    return [[self alloc] initArrayJsonModel:url decoder:decodercls];
}
+ (ResourceX *)yy_array_url:(NSString *)url decoder:(Class _Nullable)decodercls by:(NSString *)key {
    return [[self alloc] initArrayJsonModel:url decoder:decodercls by:key];
}
+ (ResourceX *)yy_mutableArray_url:(NSString *)url decoder:(Class _Nullable)decodercls {
    return [[self alloc] initMutableArrayJsonModel:url decoder:decodercls];
}
+ (ResourceX *)yy_mutableArray_url:(NSString *)url decoder:(Class _Nullable)decodercls by:(NSString *)key {
    return [[self alloc] initMutableArrayJsonModel:url decoder:decodercls by:key];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.isDecode_Response = YES;
        self.isEncrypt_Param = YES;
        self.parser = ^id _Nullable(id  _Nonnull data) {
            return  [ResourceX reduxData:data];
        };
    }
    return self;
}

- (instancetype)initJsonUrl:(NSString *)url
{
    self = [super init];
    if (self) {
        self.isDecode_Response = YES;
        self.isEncrypt_Param = YES;
        self.url = url;
        self.parser = ^id _Nullable(id  _Nonnull data) {
            return  [ResourceX reduxData:data];
        };
    }
    return self;
}

- (instancetype)initJsonUrl:(NSString *)url by:(NSString *)key {
    self = [super init];
    if (self) {
        self.isDecode_Response = YES;
        self.isEncrypt_Param = YES;
        self.url = url;
        self.parser = ^id _Nullable(id  _Nonnull data) {
            return  [[ResourceX reduxData:data] valueForKeyPath:key];
        };
    }
    return self;
}

- (instancetype)initJsonModel:(NSString *)url decoder:(Class)decoderClass
{
    self = [super init];
    if (self) {
        self.isDecode_Response = YES;
        self.isEncrypt_Param = YES;
        self.url = url;
        self.parser = ^id _Nullable(id  _Nonnull data) {
            return  [ResourceX reduxdeData:[ResourceX reduxData:data] coderClass:decoderClass];
        };
    }
    return self;
}

- (instancetype)initJsonModel:(NSString *)url decoder:(Class )decoderClass by:(NSString *)key
{
    self = [super init];
    if (self) {
        self.isDecode_Response = YES;
        self.isEncrypt_Param = YES;
        self.url = url;
        self.parser = ^id _Nullable(id  _Nonnull data) {
            
            return  [ResourceX reduxdeData:[[ResourceX reduxData:data] valueForKeyPath:key] coderClass:decoderClass];
        };
        
    }
    return self;
}

- (instancetype)initArrayJsonModel:(NSString *)url decoder:(Class )decoderClass{
    self = [super init];
    if (self) {
        self.isDecode_Response = YES;
        self.isEncrypt_Param = YES;
        self.url = url;
        self.parser = ^id _Nullable(id  _Nonnull data) {
            
            return  [ResourceX array_reduxdeData:[ResourceX reduxData:data] coderClass:decoderClass];
        };
        
    }
    return self;
}

- (instancetype)initArrayJsonModel:(NSString *)url decoder:(Class )decoderClass by:(NSString *)key
{
    self = [super init];
    if (self) {
        self.isDecode_Response = YES;
        self.isEncrypt_Param = YES;
        self.url = url;
        self.parser = ^id _Nullable(id  _Nonnull data) {
            
            return  [ResourceX array_reduxdeData:[[ResourceX reduxData:data] valueForKeyPath:key] coderClass:decoderClass];
        };
        
    }
    return self;
}
- (instancetype)initMutableArrayJsonModel:(NSString *)url decoder:(Class )decoderClass by:(NSString *)key {
    self = [super init];
    if (self) {
        self.isDecode_Response = YES;
        self.isEncrypt_Param = YES;
        self.url = url;
        self.parser = ^id _Nullable(id  _Nonnull data) {
            
            return  [ResourceX mutableArray_reduxdeData:[[ResourceX reduxData:data] valueForKeyPath:key] coderClass:decoderClass];
        };
        
    }
    return self;
}
- (instancetype)initMutableArrayJsonModel:(NSString *)url decoder:(Class )decoderClass {
    self = [super init];
    if (self) {
        self.isDecode_Response = YES;
        self.isEncrypt_Param = YES;
        self.url = url;
        self.parser = ^id _Nullable(id  _Nonnull data) {
            
            return  [ResourceX mutableArray_reduxdeData:[ResourceX reduxData:data]  coderClass:decoderClass];
        };
    }
    return self;
}


+ (id)reduxdeData:(id)data coderClass:(Class<ClassTransformprotocol>)decoderClass {
    if (!data) {
        return data;
    }
    if (decoderClass == nil) {
        return data;
    } else if (decoderClass == NSDictionary.class) {
        return data;
    } else if (decoderClass == NSMutableDictionary.class) {
        return [data mutableCopy];
    } else if (decoderClass == NSArray.class) {
        return data;
    } else if (decoderClass == NSMutableArray.class) {
        return [data mutableCopy];
    } else {
        @try {
            return [decoderClass yy_modelWithJSON:data];
        } @catch (NSException *exception) {
            NSLog(@"================转换model失败,请在工程添加 YYModel==================");
            return data;
        }
        // return [decoderClass yy_modelWithJSON:data];
    }
}

+ (id)array_reduxdeData:(id)data coderClass:(Class)decoderClass {
    @try {
        return [NSArray yy_modelArrayWithClass:decoderClass json:data];
    } @catch (NSException *exception) {
        NSLog(@"================转换model失败,请在工程添加 YYModel==================");
        return data;
    }
    
}
+ (id)mutableArray_reduxdeData:(id)data coderClass:(Class)decoderClass {
    @try {
        return [[NSArray yy_modelArrayWithClass:decoderClass json:data] mutableCopy];
    } @catch (NSException *exception) {
        NSLog(@"================转换model失败,请在工程添加 YYModel==================");
        return data;
    }
}
@end


