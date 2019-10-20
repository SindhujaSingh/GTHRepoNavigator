//
//  GTHRepositoryInfo_Tests.m
//  GTHRepoNavigatorTests
//
//  Created by SindhujaSingh on 10/19/19.
//  Copyright © 2019 SindhujaSingh. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "GTHRepositoryInfo.h"

@interface GTHRepositoryInfo_Tests : XCTestCase
@property (nonatomic, strong) NSArray *reposInfo;
@end

@implementation GTHRepositoryInfo_Tests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    NSString *path = [[NSBundle bundleForClass:[self class]] pathForResource:@"RepoInfo" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    self.reposInfo = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];

}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
    
    self.reposInfo = nil;
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testAllKeysInRepoInfo {
    
    for (NSDictionary *info in self.reposInfo) {
       // NSLog(@"%@", info.allKeys);
        XCTAssertNotNil(info.allKeys, @"Keys should not be nil");
    }
}

- (void)testRepoInfoObject {
    for (NSDictionary *info in self.reposInfo) {
        GTHRepositoryInfo *repositoryInfo = [GTHRepositoryInfo creatFromDictionary:info];
        XCTAssertNotNil(repositoryInfo, @"GTHRepositoryInfo object should not be nil");
    }
}
- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        NSLog(@"test");
        for (NSDictionary *info in self.reposInfo) {
            // Put the code you want to measure the time of here.
            GTHRepositoryInfo *object = [GTHRepositoryInfo creatFromDictionary:info];
        }
    }];
}

- (void)testAsynchronousURLConnection {
    NSURL *URL = [NSURL URLWithString:@"https://api.github.com/orgs/intuit/repos"];
    NSString *description = [NSString stringWithFormat:@"GET %@", URL];
    XCTestExpectation *expectation = [self expectationWithDescription:description];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithURL:URL
                                        completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
                                  {
                                      XCTAssertNotNil(data, "data should not be nil");
                                      XCTAssertNil(error, "error should be nil");
                                      
                                      if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
                                          NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                                          XCTAssertEqual(httpResponse.statusCode, 200, @"HTTP response status code should be 200");
                                          XCTAssertEqualObjects(httpResponse.URL.absoluteString, URL.absoluteString, @"HTTP response URL should be equal to original URL");
                                          XCTAssertEqualObjects(httpResponse.MIMEType, @"application/json", @"HTTP response content type should be json");
                                      } else {
                                          XCTFail(@"Response was not NSHTTPURLResponse");
                                      }
                                      
                                      [expectation fulfill];
                                  }];
    
    [task resume];
    
    [self waitForExpectationsWithTimeout:task.originalRequest.timeoutInterval handler:^(NSError *error) {
        if (error != nil) {
            NSLog(@"Error: %@", error.localizedDescription);
        }
        [task cancel];
    }];
}

@end
