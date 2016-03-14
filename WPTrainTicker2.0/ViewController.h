//
//  ViewController.h
//  WPTrainTicker2.0
//
//  Created by 万敏 on 3/10/16.
//  Copyright © 2016 万敏. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UITableViewDataSource, UITableViewDelegate,UITextFieldDelegate>

@property (nonatomic, strong) NSString        *strTime;
@property (nonatomic, strong) NSMutableArray  *trainTypeArray;
@property (nonatomic, strong) NSString        *fromAddress;
@property (nonatomic, strong) NSString        *toAddress;
@property (nonatomic, strong) NSString        *dateString;

@end

