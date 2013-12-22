//
//  TKRGuardTests.m
//  TKRGuardTests
//
//  Created by ytokoro on 12/21/13.
//  Copyright (c) 2013 tokoro. All rights reserved.
//

@interface TKRGuardTests : XCTestCase
@end

@implementation TKRGuardTests

- (void)testSimpleExample
{
    __block id result = nil;
    [self.class asyncronousProsess:^(id res) {
        result = res;
        RESUME;
    }];

    WAIT;

    XCTAssertNotNil(result);
    XCTAssertEqualObjects(result, @"OK");
}

- (void)testUnuseShorthand
{
    __block id result = nil;
    [self.class asyncronousProsess:^(id res) {
        result = res;
        [TKRGuard resumeForKey:@"xxx"];
    }];

    [TKRGuard waitForKey:@"xxx"];

    XCTAssertNotNil(result);
    XCTAssertEqualObjects(result, @"OK");
}

//----------------------------------------------------------------------------//
#pragma mark - Private Methods
//----------------------------------------------------------------------------//

+ (void)asyncronousProsess:(void (^)(id))completion
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        completion(@"OK");
    });
}

@end
