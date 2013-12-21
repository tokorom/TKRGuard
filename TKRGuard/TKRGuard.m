//
//  TKRGuard.m
//
//  Created by ToKoRo on 2013-12-13.
//

#import "TKRGuard.h"
#import "TKRGuardToken.h"

static NSTimeInterval kTKRGuardDefaultTimeout = 1.0;

static TKRGuard *_sharedInstance = nil;

@interface TKRGuard ()
@property (strong) NSMutableDictionary *tokens;
@end 

@implementation TKRGuard

//----------------------------------------------------------------------------//
#pragma mark - Lifecycle
//----------------------------------------------------------------------------//

+ (void)initialize
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [self.class new];
    });
}

- (id)init
{
    if ((self = [super init])) {
        self.tokens = [NSMutableDictionary dictionary];
    }
    return self;
}

//----------------------------------------------------------------------------//
#pragma mark - Public Interface
//----------------------------------------------------------------------------//
    
+ (BOOL)waitForKey:(id)key
{
    return [self.class waitWithTimeout:kTKRGuardDefaultTimeout forKey:key];
}

+ (BOOL)waitWithTimeout:(NSTimeInterval)timeout forKey:(id)key
{
    return [_sharedInstance waitAndAddTokenWithTimeout:timeout forKey:key];
}

+ (void)resumeForKey:(id)key
{
    [_sharedInstance removeTokenForKey:key];
}

+ (id)adjustedKey:(id)key
{
    if ([key respondsToSelector:@selector(componentsSeparatedByString:)]) {
        NSArray *components = [key componentsSeparatedByString:@" "];
        if (2 > components.count) {
            key = components[0];
        } else {
            components = [components[1] componentsSeparatedByString:@"]"];
            key = components[0];
        }
    }
    return key;
}

//----------------------------------------------------------------------------//
#pragma mark - Private Methods
//----------------------------------------------------------------------------//

- (BOOL)waitAndAddTokenWithTimeout:(NSTimeInterval)timeout forKey:(id)key
{
    @synchronized (self) {
        TKRGuardToken *token = [TKRGuardToken new];
        [self.tokens setObject:token forKey:key];
        return [token waitWithTimeout:timeout];
    }
}

- (void)removeTokenForKey:(id)key
{
    @synchronized (self) {
        TKRGuardToken *token = [self.tokens objectForKey:key];
        [token resume];
        [self.tokens removeObjectForKey:key];
    }
}

@end
