//
//  NSMutableArray+Filters.m
//  ResourceX
//
//  Created by dqdeng on 2020/4/5.
//  Copyright © 2020 Jaden. All rights reserved.
//

#import "NSMutableArray+Filters.h"

@implementation NSMutableArray (Filters)

- (NSMutableArray*)map:(FiltersTransformMap)transform {
    NSMutableArray *list = [NSMutableArray arrayWithCapacity:self.count];
    [self enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [list addObject:transform(obj)];
    }];
    return list;
}
- (NSMutableArray*)filter:(FiltersTransformFilter)predicate {
    NSMutableArray *list = [NSMutableArray arrayWithCapacity:self.count];
    [self enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (predicate(obj)) {
            [list addObject:obj];
        }
    }];
    return list;
}
- (void)forEach:(FiltersTransformEach)element {
    [self enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        element(obj);
    }];
}
- (void)forEachIndex:(FiltersTransformEachIndex)element {
    [self enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
           element(obj,idx);
       }];
}

@end

@implementation NSArray (Filters)

- (NSMutableArray*)map:(FiltersTransformMap)transform {
    NSMutableArray *list = [NSMutableArray arrayWithCapacity:self.count];
    [self enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [list addObject:transform(obj)];
    }];
    return list;
}
- (NSMutableArray*)filter:(FiltersTransformFilter)predicate {
    NSMutableArray *list = [NSMutableArray arrayWithCapacity:self.count];
    [self enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (predicate(obj)) {
            [list addObject:obj];
        }
    }];
    return list;
}
- (void)forEach:(FiltersTransformEach)element {
    [self enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        element(obj);
    }];
}
- (void)forEachIndex:(FiltersTransformEachIndex)element {
    [self enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
           element(obj,idx);
       }];
}

@end
