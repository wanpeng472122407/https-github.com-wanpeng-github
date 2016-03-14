//
//  WPRuqestData.m
//  WPTrainTicker2.0
//
//  Created by 万敏 on 3/11/16.
//  Copyright © 2016 万敏. All rights reserved.
//

#import "WPRuqestData.h"
#import <AFHTTPRequestOperation.h>
#import "XCHudHelper.h"
@implementation WPRuqestData

- (void)requestHttpDataURL:(NSString *)requestURLString complete:(void(^)(NSDictionary *dic)) complete{
    _requestDataArray = [[NSMutableArray alloc] init];
    NSURL *requestURL = [NSURL URLWithString:requestURLString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:requestURL];
    [request setHTTPMethod:@"GET"];
    [request addValue:@"73096f0a443891bd9af2b740c59f2af4" forHTTPHeaderField:@"apikey"];
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    op.responseSerializer = [AFJSONResponseSerializer serializer];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary* dict = (NSDictionary *)responseObject;
            complete(dict);
        }
        [[XCHudHelper sharedInstance] hideHud];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [[XCHudHelper sharedInstance] showHudOnWindow:@"查询中" image:nil acitivity:YES autoHideTime:2];
        [self performSelector:@selector(requst) withObject:self afterDelay:2];
    }];
    [[NSOperationQueue mainQueue] addOperation:op];
}

- (void)requst {

    [[XCHudHelper sharedInstance] showHudOnWindow:@"网路连接失败" image:nil acitivity:YES autoHideTime:2];
}
@end
