//
//  ViewController.m
//  UTMock
//
//  Created by Toru Furuya on 2017/07/13.
//  Copyright © 2017年 com.example. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<NSURLSessionDataDelegate>

@property (nonatomic) NSMutableData *data;
@property (weak, nonatomic) IBOutlet UILabel *result;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)request:(id)sender {
    NSURL *url = [NSURL URLWithString:@"https://hoge.jp/fuga/test"];
    NSURLRequest *req = [NSURLRequest requestWithURL:url];

    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:nil];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:req];
    [task resume];
}

#pragma mark - NSURLSessionDataDelegate

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler {
    NSLog(@"%s", __PRETTY_FUNCTION__);

    self.data = [NSMutableData data];
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    if (httpResponse.statusCode == 200) {
        completionHandler(NSURLSessionResponseAllow);
    } else {
        completionHandler(NSURLSessionResponseCancel);
    }
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    NSLog(@"%s", __PRETTY_FUNCTION__);

    [self.data appendData:data];
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(nullable NSError *)error {
    NSLog(@"%s", __PRETTY_FUNCTION__);

    if (error) {
        NSLog(@"%@", error.localizedDescription);
    } else {
        NSError *error = nil;
        id json = [NSJSONSerialization JSONObjectWithData:self.data options:NSJSONReadingAllowFragments error:&error];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.result.text = json[@"result"];
        });
    }
}

@end
