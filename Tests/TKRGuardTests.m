//
//  TKRGuardTests.m
//  TKRGuardTests
//
//  Created by ytokoro on 12/21/13.
//  Copyright (c) 2013 tokoro. All rights reserved.
//

#import "TKRGuard.h"

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

    XCTAssertEqualObjects(result, @"OK");
}

- (void)testWithoutShortHand
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

- (void)testWaitWithTimeout
{
    __block id result = nil;
    [self.class asyncronousProsess:^(id res) {
        result = res;
        RESUME;
    }];

    WAIT_MAX(1.0);

    XCTAssertNotNil(result);
    XCTAssertEqualObjects(result, @"OK");
}

- (void)testWaitWithTimeoutWithoutShortHand
{
    __block id result = nil;
    [self.class asyncronousProsess:^(id res) {
        result = res;
        [TKRGuard resumeForKey:@"xxx"];
    }];

    [TKRGuard waitWithTimeout:1.0 forKey:@"xxx"];

    XCTAssertNotNil(result);
    XCTAssertEqualObjects(result, @"OK");
}

- (void)testWaitForSuccess
{
    __block NSError *error = nil;
    [self.class asyncronousSuccess:^(NSError *err) {
        error = err;
        if (err) {
            RESUME_WITH(kTKRGuardStatusFailure);
        } else {
            RESUME_WITH(kTKRGuardStatusSuccess);
        }
    }];

    WAIT_FOR(kTKRGuardStatusSuccess);
}

- (void)testWaitForSuccessWithoutShortHand
{
    __block NSError *error = nil;
    [self.class asyncronousSuccess:^(NSError *err) {
        error = err;
        if (err) {
            [TKRGuard resumeWithStatus:kTKRGuardStatusFailure forKey:TKRGUARD_KEY];
        } else {
            [TKRGuard resumeWithStatus:kTKRGuardStatusSuccess forKey:TKRGUARD_KEY];
        }
    }];

    TKRAssertEqualStatus([TKRGuard waitForKey:TKRGUARD_KEY], kTKRGuardStatusSuccess);
}

- (void)testWaitForFailure
{
    __block NSError *error = nil;
    [self.class asyncronousError:^(NSError *err) {
        error = err;
        if (err) {
            RESUME_WITH(kTKRGuardStatusFailure);
        } else {
            RESUME_WITH(kTKRGuardStatusSuccess);
        }
    }];

    WAIT_FOR(kTKRGuardStatusFailure);
}

- (void)testTimeout
{
    [TKRGuard setDefaultTimeoutInterval:0.01];

    [self.class asyncronousProsess:^(id res) {
        RESUME_WITH(kTKRGuardStatusSuccess);
    }];

    WAIT_FOR(kTKRGuardStatusTimeouted);

    [TKRGuard resetDefaultTimeoutInterval];
}

- (void)testDelayWait
{
    __block id result = nil;
    [self.class syncronousProsess:^(id res) {
        result = res;
        RESUME;
    }];

    WAIT;

    XCTAssertEqualObjects(result, @"OK");
}

- (void)test2times
{
    __block id result1 = nil;
    __block id result2 = nil;

    [self.class asyncronousProsess:^(id res) {
        result1 = res;
        RESUME;
    }];
    [self.class asyncronousProsess:^(id res) {
        result2 = res;
        RESUME;
    }];

    WAIT_TIMES(2);

    XCTAssertEqualObjects(result1, @"OK");
    XCTAssertEqualObjects(result2, @"OK");
}

- (void)testDelayWait2times
{
    __block id result1 = nil;
    __block id result2 = nil;

    [self.class syncronousProsess:^(id res) {
        result1 = res;
        RESUME;
    }];
    [self.class syncronousProsess:^(id res) {
        result2 = res;
        RESUME;
    }];

    WAIT_TIMES(2);

    XCTAssertEqualObjects(result1, @"OK");
    XCTAssertEqualObjects(result2, @"OK");
}

- (void)testDelayWaitAndAsynchronous
{
    __block id result1 = nil;
    __block id result2 = nil;

    [self.class syncronousProsess:^(id res) {
        result1 = res;
        RESUME;
    }];
    [self.class asyncronousProsess:^(id res) {
        result2 = res;
        RESUME;
    }];

    WAIT_TIMES(2);

    XCTAssertEqualObjects(result1, @"OK");
    XCTAssertEqualObjects(result2, @"OK");
}

- (void)testGuideMessage
{
    NSString *guide;
    
    guide = [TKRGuard guideMessageWithExpected:kTKRGuardStatusSuccess got:kTKRGuardStatusTimeouted];
    XCTAssertEqualObjects(guide, @"expected: kTKRGuardStatusSuccess, got: kTKRGuardStatusTimeouted");

    guide = [TKRGuard guideMessageWithExpected:kTKRGuardStatusFailure got:kTKRGuardStatusAny];
    XCTAssertEqualObjects(guide, @"expected: kTKRGuardStatusFailure, got: kTKRGuardStatusAny");

    guide = [TKRGuard guideMessageWithExpected:kTKRGuardStatusNil got:255];
    XCTAssertEqualObjects(guide, @"expected: kTKRGuardStatusNil, got: Undefined");
}

- (void)testAdjustedKey
{
    NSString *key;

    key = [TKRGuard adjustedKey:@"-[ViewController viewDidLoad]"];
    XCTAssertEqualObjects(key, @"viewDidLoad");

    key = [TKRGuard adjustedKey:@"-[ViewController viewDidLoad]_block_invoke_1"];
    XCTAssertEqualObjects(key, @"viewDidLoad");
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

+ (void)syncronousProsess:(void (^)(id))completion
{
    completion(@"OK");
}

+ (void)asyncronousSuccess:(void (^)(NSError *))completion
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        completion(nil);
    });
}

+ (void)asyncronousError:(void (^)(NSError *))completion
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        NSError * error = [NSError errorWithDomain:@"xxx" code:1 userInfo:nil];
        completion(error);
    });
}

@end
