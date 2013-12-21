//
//  TKRGuardToken.h
//
//  Created by ToKoRo on 2013-12-13.
//

@interface TKRGuardToken : NSObject

- (BOOL)waitWithTimeout:(NSTimeInterval)timeout;
- (void)resume;

@end
