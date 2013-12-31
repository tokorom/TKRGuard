//
//  TKRGuardToken.m
//
//  Created by ToKoRo on 2013-12-13.
//

#import "TKRGuardToken.h"

static const NSTimeInterval kTKRGuardTokenLoopInterval = 0.05;

@interface TKRGuardToken ()
@end 

@implementation TKRGuardToken

//----------------------------------------------------------------------------//
#pragma mark - Lifecycle
//----------------------------------------------------------------------------//

- (instancetype)init
{
    if ((self = [super init])) {
        self.waitCount = 1;
        self.resultStatus = kTKRGuardStatusNil;
    }
    return self;
}

//----------------------------------------------------------------------------//
#pragma mark - Public Interface
//----------------------------------------------------------------------------//
    
- (TKRGuardStatus)waitWithTimeout:(NSTimeInterval)timeout
{
    NSDate *expiryDate = [NSDate dateWithTimeIntervalSinceNow:timeout];
    while (self.isWaiting) {
        if (NSOrderedDescending == [[NSDate date] compare:expiryDate]) {
            return kTKRGuardStatusTimeouted;
        }
        NSDate *untilDate = [NSDate dateWithTimeIntervalSinceNow:kTKRGuardTokenLoopInterval];
        [[NSRunLoop currentRunLoop] runUntilDate:untilDate];
    }
    return self.resultStatus;
}

- (void)resumeWithStatus:(TKRGuardStatus)status
{
    --self.waitCount;
    self.resultStatus = status;
}

- (BOOL)isWaiting
{
    return (kTKRGuardStatusNil == self.resultStatus) || 0 < self.waitCount;
}

@end
