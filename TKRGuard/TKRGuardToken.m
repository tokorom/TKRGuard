//
//  TKRGuardToken.m
//
//  Created by ToKoRo on 2013-12-13.
//

#import "TKRGuardToken.h"

static const NSTimeInterval kTKRGuardTokenLoopInterval = 0.05;

@interface TKRGuardToken ()
@property (assign, getter=isWaiting) BOOL waiting;
@end 

@implementation TKRGuardToken

//----------------------------------------------------------------------------//
#pragma mark - Lifecycle
//----------------------------------------------------------------------------//

- (id)init
{
    if ((self = [super init])) {
        self.waiting = YES;
    }
    return self;
}

//----------------------------------------------------------------------------//
#pragma mark - Public Interface
//----------------------------------------------------------------------------//
    
- (BOOL)waitWithTimeout:(NSTimeInterval)timeout
{
    NSDate *expiryDate = [NSDate dateWithTimeIntervalSinceNow:timeout];
    while (self.isWaiting) {
        if (NSOrderedDescending == [[NSDate date] compare:expiryDate]) {
            return NO;
        }
        NSDate *untilDate = [NSDate dateWithTimeIntervalSinceNow:kTKRGuardTokenLoopInterval];
        [[NSRunLoop currentRunLoop] runUntilDate:untilDate];
    }
    return YES;
}

- (void)resume
{
    self.waiting = NO;
}

@end
