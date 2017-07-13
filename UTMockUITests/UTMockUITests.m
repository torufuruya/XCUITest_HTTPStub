//
//  UTMockUITests.m
//  UTMockUITests
//
//  Created by Toru Furuya on 2017/07/13.
//  Copyright © 2017年 com.example. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <SBTUITestTunnel/SBTUITunneledApplication.h>

@interface UTMockUITests : XCTestCase {
    SBTUITunneledApplication *app;
}

@end

@implementation UTMockUITests

- (void)setUp {
    [super setUp];
    
    self.continueAfterFailure = NO;
    app = [[SBTUITunneledApplication alloc] init];
    [app launchTunnel];
}

- (void)tearDown {
    [app stubRequestsRemoveAll];

    [super tearDown];
}

- (void)testExample {
    SBTRequestMatch *match = [[SBTRequestMatch alloc] initWithURL:@"hoge.jp"];
    SBTStubResponse *response = [[SBTStubResponse alloc] initWithResponse:@{@"result": @"OK"} returnCode:200 responseTime:3];
    [app stubRequestsMatching:match response:response];

    [XCUIDevice sharedDevice].orientation = UIDeviceOrientationPortrait;
    [app.buttons[@"Request!"] tap];

    XCUIElement *label = app.staticTexts[@"OK"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"exists == true"];
    [self expectationForPredicate:predicate evaluatedWithObject:label handler:nil];
    [self waitForExpectationsWithTimeout:3 handler:nil];
    //No need?
    XCTAssertEqualObjects(label.label, @"OK");
}

@end
