//
//  WPDataModel.h
//  WPTrainTicker
//
//  Created by 万敏 on 3/10/16.
//  Copyright © 2016 万敏. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WPDataModel : NSObject

@property (strong, nonatomic) NSString *trainNumber;
@property (strong, nonatomic) NSString *trainType;
@property (strong, nonatomic) NSString *formAddress;
@property (strong, nonatomic) NSString *toAddress;
@property (strong, nonatomic) NSString *totalTime;
@property (strong, nonatomic) NSString *formTime;
@property (strong, nonatomic) NSString *toTime;
@property (strong, nonatomic) NSString *seat;
@property (strong, nonatomic) NSString *totalTicketNumber;
@property (strong, nonatomic) NSString *ticketPrice;
@property (strong, nonatomic) NSString *remainNum;

@property (nonatomic, strong) NSMutableArray *seatInfosArr;
@property (nonatomic, strong) NSMutableArray *remainNumArr;

- (void)chooseWithDictionary:(NSDictionary *)data withString:(NSString *)timeStr withChooseTrainTypeArr:(NSMutableArray *)typeArr complete:(void(^)(NSMutableArray* dataArr))complete;
@end
