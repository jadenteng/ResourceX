//
//  LoginModel.m
//  ResourceXExp
//
//  Created by dqdeng on 2020/4/3.
//  Copyright © 2020 Jaden. All rights reserved.
//

#import "LoginModel.h"

@implementation LoginModel

- (NSString *)description {
 
    return  [NSString stringWithFormat:@"模型数据email=%@ name=%@ mobile=%@",self.email,self.name,self.mobile];
}

@end
