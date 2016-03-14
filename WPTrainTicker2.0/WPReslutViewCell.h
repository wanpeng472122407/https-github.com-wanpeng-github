//
//  WPReslutViewCell.h
//  WPTrainTicker
//
//  Created by 万敏 on 3/10/16.
//  Copyright © 2016 万敏. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WPReslutViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *trainNumber;
@property (weak, nonatomic) IBOutlet UILabel *trainType;
@property (weak, nonatomic) IBOutlet UILabel *formAddress;
@property (weak, nonatomic) IBOutlet UILabel *toAddress;
@property (weak, nonatomic) IBOutlet UILabel *totalTime;
@property (weak, nonatomic) IBOutlet UILabel *formTime;
@property (weak, nonatomic) IBOutlet UILabel *toTime;
@property (weak, nonatomic) IBOutlet UILabel *seat1;
@property (weak, nonatomic) IBOutlet UILabel *seat2;
@property (weak, nonatomic) IBOutlet UILabel *seat3;
@property (weak, nonatomic) IBOutlet UILabel *totalTicketNumber;
@property (weak, nonatomic) IBOutlet UILabel *seat1Price;
@property (weak, nonatomic) IBOutlet UILabel *seat2Price;
@property (weak, nonatomic) IBOutlet UILabel *seat3Price;

@property (nonatomic, strong) NSMutableArray *seatArr;
@end
