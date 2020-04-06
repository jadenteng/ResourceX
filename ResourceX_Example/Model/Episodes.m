//
//  Episodes.m
//  ResourceXExp
//
//  Created by dqdeng on 2020/4/3.
//  Copyright © 2020 Jaden. All rights reserved.
//

#import "Episodes.h"

@implementation Episodes

- (NSString *)description {
   
    return [NSString stringWithFormat:@"模型数据level=%@ title=%@ urls=%@",self.level,self.title,self.urls];
}

@end
