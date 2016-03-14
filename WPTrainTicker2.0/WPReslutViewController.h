//
//  WPReslutViewController.h
//  WPTrainTicker
//
//  Created by 万敏 on 3/10/16.
//  Copyright © 2016 万敏. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WPReslutViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) NSString         *requstURLString;
@property (nonatomic, strong) NSMutableArray   *trainArray;
@property (nonatomic, strong) UITableView      *reslutTableView;
@property (nonatomic, strong) NSString         *timeStr;
@property (nonatomic, strong) NSMutableArray   *chooseTrainTypeArr;
@property (nonatomic, strong) NSString         *retrunTrainNumber;
- (id)initWithForm:(NSString *)formAddress withTo:(NSString *)toAddress withDate:(NSString *)date;

@end
