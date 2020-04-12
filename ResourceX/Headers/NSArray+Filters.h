//
//  NSArray+Filters.h
//  ResourceX
//
//  Created by dqdeng on 2020/4/12.
//  Copyright © 2020 Jaden. All rights reserved.
//

#import <Foundation/Foundation.h>

///oc版本 map filter forEach 根据swift版本实现
typedef id _Nonnull (^FiltersTransformMap)(id _Nonnull );
typedef BOOL (^FiltersTransformFilter)(id _Nonnull );
typedef void (^FiltersTransformEach)(id _Nonnull );
typedef void (^FiltersTransformEachIndex)(id _Nonnull ,NSUInteger idx);

NS_ASSUME_NONNULL_BEGIN

@interface NSArray (Filters)
- (NSMutableArray*)map:(FiltersTransformMap)transform;
- (NSMutableArray*)filter:(FiltersTransformFilter)predicate;
- (void)forEach:(FiltersTransformEach)element;
- (void)forEachIndex:(FiltersTransformEachIndex)element;

@end

NS_ASSUME_NONNULL_END
