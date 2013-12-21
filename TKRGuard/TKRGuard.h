//
//  TKRGuard.h
//
//  Created by ToKoRo on 2013-12-13.
//

#define TKRGUARD_KEY [TKRGuard adjustedKey:[NSString stringWithFormat:@"%s", __PRETTY_FUNCTION__]]

#if !defined(UNUSED_TKRGUARD_SHORTHAND)

#define WAIT ([TKRGuard waitForKey:TKRGUARD_KEY]) ? (void)nil : XCTFail(@"TKRGuard timeouted")
#define RESUME [TKRGuard resumeForKey:TKRGUARD_KEY]

#endif

@interface TKRGuard : NSObject

+ (BOOL)waitForKey:(id)key;
+ (BOOL)waitWithTimeout:(NSTimeInterval)timeout forKey:(id)key;
+ (void)resumeForKey:(id)key;

+ (id)adjustedKey:(id)key;

@end
