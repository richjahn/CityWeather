//
//  NHNetworkManager.m
//  CityWeather
//
//  Created by Rich Jahn on 12/22/13.
//  Copyright (c) 2013 Rich Jahn. All rights reserved.
//

#import "NHNetworkManager.h"

@implementation NHNetworkManager {
    NSMutableData *_data;
    NSURLSession *_session;
    NSURLSessionDataTask *_task;
}

+ (instancetype) sharedManager {
    static NHNetworkManager *sharedManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

- (void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"Request: %@ Failed: %@", connection.currentRequest.URL ,error);
}

- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    _data = [[NSMutableData alloc] init];
}

- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [_data appendData:data];
}

- (void) connectionDidFinishLoading:(NSURLConnection *)connection {
    NSString *html = [[NSString alloc] initWithData:_data encoding:NSUTF8StringEncoding];
    NSLog(@"%@", html);
}

- (void) downloadData {
    NSURL *url = [NSURL URLWithString:@"http://www.google.com"];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    _task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        //NSString *html = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        //NSLog(@"%@", html);
        
        [self performSelectorOnMainThread:@selector(fetchedData:)
                               withObject:data waitUntilDone:YES];
    }];
    [_task resume];
}

- (void)fetchedData:(NSData *)responseData
{
    NSError *error;
    NSDictionary *json = [NSJSONSerialization
                          JSONObjectWithData:responseData
                          options:0
                          error:&error];
    NSDictionary *current = json[@"currently"];
    
    //_currentTemp.text = [NSString stringWithFormat:@"%@", current[@"temperature"]];
}

@end
