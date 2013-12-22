//
//  TKRGuardToken.h
//
//  Created by ToKoRo on 2013-12-13.
//

#import "TKRGuardStatus.h"

@interface TKRGuardToken : NSObject

- (TKRGuardStatus)waitWithTimeout:(NSTimeInterval)timeout;
- (void)resumeWithStatus:(TKRGuardStatus)status;

@end
