//
//  WPRuqestData.h
//  WPTrainTicker2.0
//
//  Created by 万敏 on 3/11/16.
//  Copyright © 2016 万敏. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface WPRuqestData : NSObject

@property (nonatomic, copy) void(^myBlock)(NSDictionary* dic);
@property (nonatomic, strong) NSMutableArray *requestDataArray;
- (void)requestHttpDataURL:(NSString *)requestURLString complete:(void(^)(NSDictionary *dic))complete;

@end
