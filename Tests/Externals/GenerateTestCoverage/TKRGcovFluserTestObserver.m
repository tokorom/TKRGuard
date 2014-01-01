//
//  TKRGcovFluserTestObserver.m
//
//  Created by ToKoRo on 2013-12-05.
//

#import "TKRGcovFluserTestObserver.h"
#import "TKRGuard.h"
#import <objc/runtime.h>

@interface TKRGuard ()
- (void)gcovFlush;
@end

@implementation TKRGcovFluserTestObserver


+ (void)initialize
{
    [super initialize];
    [self.class addGcovFlushMethodToApplication];
}

//----------------------------------------------------------------------------//
#pragma mark - XCTestObserver
//----------------------------------------------------------------------------//
    
- (void)stopObserving
{
    [super stopObserving];
    TKRGuard *guard = [TKRGuard new];
    if ([guard respondsToSelector:@selector(gcovFlush)]) {
        [guard gcovFlush];
    }
}

//----------------------------------------------------------------------------//
#pragma mark - Private Methods
//----------------------------------------------------------------------------//

+ (void)addGcovFlushMethodToApplication
{
#if defined(USE_GCOV_FLUSH) || !defined(UNUSE_GCOV_FLUSH)
    IMP imp = imp_implementationWithBlock(^{
        extern void __gcov_flush(void);
        __gcov_flush();
    });
    class_addMethod([TKRGuard class], @selector(gcovFlush), imp, "v@:");
#endif
}

@end
