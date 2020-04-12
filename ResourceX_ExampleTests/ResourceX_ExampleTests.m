//
//  ResourceX_ExampleTests.m
//  ResourceX_ExampleTests
//
//  Created by dqdeng on 2020/4/12.
//  Copyright © 2020 Jaden. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <ResourceX/Resource.h>

@interface ResourceX_ExampleTests : XCTestCase

@end

@implementation ResourceX_ExampleTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}
- (void)testAraryFiletr {
   NSArray *list = @[@1,@2,@3];
    NSMutableArray *mapl = [list filter:^BOOL(id num) {
        return [num integerValue] > 2;
    }];
    XCTAssertNotNil(mapl);
    NSInteger num = [mapl.firstObject integerValue];
    XCTAssertEqual(num, 3);
}
- (void)testAraryforEach {
   NSArray *list = @[@1,@2,@3];
    [list forEach:^(id _Nonnull num) {
        
    }];
   
    [list forEachIndex:^(id _Nonnull num, NSUInteger idx) {
        
    }];
    XCTAssertNotNil(list);

}

- (void)testAraryMap {
   NSArray *list = @[@1,@2,@3];
   NSMutableArray *mapl = [list map:^id _Nonnull(id num) {
       return num;
    }];
    XCTAssertNotNil(mapl);
    XCTAssertEqual([list count], [mapl count]);
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
