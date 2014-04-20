//
//  KiwiTests.m
//
//  Created by ToKoRo on 2014-04-19.
//

#import "Kiwi.h"
#define TKRGUARD_USE_KIWI
#import "TKRGuard.h"

@interface Sample : NSObject
+ (void)asyncronousProsess:(void (^)(id))completion;
@end

@implementation Sample

+ (void)asyncronousProsess:(void (^)(id))completion
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        completion(@"OK");
    });
}

@end

SPEC_BEGIN(KiwiTests)

describe(@"Sample", ^{
    it(@"can test asynchronous functions", ^{
        __block id result = nil;
        [Sample asyncronousProsess:^(id res) {
            result = res;
            RESUME;
        }];

        WAIT;
        [[result should] equal:@"OK"];
    });

    it(@"can handle timeout", ^{
        __block id result = nil;
        [Sample asyncronousProsess:^(id res) {
            result = res;
        }];

        TKRGuardStatus status = [TKRGuard waitWithTimeout:0.01 forKey:@"dummy"];
        [[theValue(status) should] equal:theValue(TKRGuardStatusTimeouted)];
    });
});

SPEC_END
