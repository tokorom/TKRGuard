TKRGuard
========

The simple test helper for asynchronous processes

## Usage

All you need to use only `WAIT` and `RESUME`.

```
- (void)testExample
{
    __block NSString *response = nil;
    [self requestGetAsyncronous:^(id res, NSError *error) {
        response = res;
        RESUME;
    }];

    WAIT;
    XCTAssertEqualObjects(response, @“OK!”);
}
```

## Setup

### Using CocoaPods

```
// Podfile
target :YourTestsTarget do
  pod 'TKRGuard'
end
```

and

```
pod install
```

### Install manually

Add [TKRGuard](TKRGuard) subdirectory to your project.

and

```
#import "TKRGuard.h"
```
