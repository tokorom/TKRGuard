//
//  TKRGuardStatus.h
//
//  Created by ToKoRo on 2013-12-22.
//

typedef NS_ENUM(NSInteger, TKRGuardStatus) {
    kTKRGuardStatusAny = -1,
    kTKRGuardStatusSuccess = 1,
    kTKRGuardStatusFailure = 10,
    kTKRGuardStatusTimeouted = 100,

    kTKRGuardStatusNil = 0 //< Your application must not use
};

