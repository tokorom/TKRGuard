TKRGuard [![build](https://travis-ci.org/tokorom/TKRGuard.png?branch=master)](https://travis-ci.org/tokorom/TKRGuard)
========

The simple test helper for asynchronous processes.

## Usage

All you need to use only `WAIT` and `RESUME`.

```objective-c
- (void)testExample
{
    __block NSString *response = nil;
    [self requestGetAsyncronous:^(id res, NSError *error) {
        response = res;
        RESUME;
    }];

    WAIT;
    XCTAssertEqualObjects(response, @"OK!");
}
```

## Advanced Examples

When you want to notify a status (like a GHUnit).

```objective-c
- (void)testExample
{
    [self requestGetAsyncronous:^(id res, NSError *error) {
        if (error) {
            RESUME_WITH(kTKRGuardStatusFailure);
        } else {
            RESUME_WITH(kTKRGuardStatusSuccess);
        }
    }];

    WAIT_FOR(kTKRGuardStatusSuccess);
}
```

When you want to change the default timeout interval.

```objective-c
// default is 1.0
[TKRGuard setDefaultTimeoutInterval:2.0];
```

When you do not want to use the shorthand macro.

```objective-c
#define UNUSE_TKRGUARD_SHORTHAND

- (void)testExample
{
    __block id result = nil;
    [self requestGetAsyncronous:^(id res, NSError *error) {
        result = res;
        [TKRGuard resumeForKey:@"xxx"];
    }];

    [TKRGuard waitWithTimeout:1.0 forKey:@"xxx"];
    XCTAssertEqualObjects(response, @"OK!");
}
```

## Setup

### Using CocoaPods

```ruby
// Podfile
target :YourTestsTarget do
  pod 'TKRGuard'
end
```

and

```shell
pod install
```

### Install manually

Add [TKRGuard](TKRGuard) subdirectory to your project.

and

```objective-c
#import "TKRGuard.h"
```
