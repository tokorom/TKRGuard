//
//  TKRGcovFlusher.m
//
//  Created by ToKoRo on 2013-12-05.
//

#import <XCTest/XCTestObserver.h>
#import "TKRGcovFlusher.h"

@implementation TKRGcovFlusher

//----------------------------------------------------------------------------//
#pragma mark - Lifecycle
//----------------------------------------------------------------------------//

+ (void)load
{
    [self.class updateTestObserverClassName:@"TKRGcovFluserTestObserver"];
}

//----------------------------------------------------------------------------//
#pragma mark - Private Methods
//----------------------------------------------------------------------------//

+ (void)updateTestObserverClassName:(NSString*)className
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *currentObserverString = [defaults stringForKey:XCTestObserverClassKey];
    NSArray *currentObservers = [currentObserverString componentsSeparatedByString:@","];

    NSArray *observerNames;
    if ([currentObservers containsObject:className]) {
        observerNames = currentObservers;
    } else {
        observerNames = [currentObservers arrayByAddingObject:className];
    }
    NSString *observerNamesString = [observerNames componentsJoinedByString:@","];
    [defaults setObject:observerNamesString forKey:XCTestObserverClassKey];
    [defaults setObject:@"XCTestLog,TKRGcovFluserTestObserver" forKey:XCTestObserverClassKey];
    [defaults synchronize];
}

@end
