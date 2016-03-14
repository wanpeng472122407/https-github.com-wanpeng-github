//
//  WPDataModel.m
//  WPTrainTicker
//
//  Created by 万敏 on 3/10/16.
//  Copyright © 2016 万敏. All rights reserved.
//

#import "WPDataModel.h"
#import <Foundation/Foundation.h>
#import "XCHudHelper.h"
@implementation WPDataModel

- (void)chooseWithDictionary:(NSDictionary *)data withString:(NSString *)timeStr withChooseTrainTypeArr:(NSMutableArray *)typeArr complete:(void (^)(NSMutableArray *))complete {
    NSArray *otherSeatArr        =[[NSArray alloc]initWithObjects:@"硬卧上",@"硬卧中",@"软卧上", nil];
    NSMutableArray *jsonArr      = [[NSMutableArray alloc] init];
    NSMutableArray *startTimeArr = [[NSMutableArray alloc] init];
    NSDictionary   *dic          = [data objectForKey:@"data"];
    NSArray        *trainArr     = [dic objectForKey:@"trainList"];
    
    for (int i = 0; i < trainArr.count; i++) {
        WPDataModel   *jsonData = [[WPDataModel alloc] init];
        NSDictionary  *dic1     = [trainArr objectAtIndex:i];
        jsonData.trainType      = [dic1 objectForKey:@"trainType"];
        jsonData.trainNumber    = [dic1 objectForKey:@"trainNo"];
        NSArray *arr      = [jsonData.trainNumber componentsSeparatedByString:@"/"];
        if (arr.count == 2) {
            NSString *a = [[arr objectAtIndex:0] substringFromIndex:1];
            NSString *b = [[arr objectAtIndex:1] substringFromIndex:1];
            if ([a intValue] >[b intValue]) {
                jsonData.trainNumber = [arr objectAtIndex:0];
            } else {
                jsonData.trainNumber = [arr objectAtIndex:1];
            }
        }
        jsonData.formAddress    = [dic1 objectForKey:@"from"];
        jsonData.toAddress      = [dic1 objectForKey:@"to"];
        jsonData.formTime       = [dic1 objectForKey:@"startTime"];
        jsonData.toTime         = [dic1 objectForKey:@"endTime"];
        jsonData.totalTime      = [dic1 objectForKey:@"duration"];
        
        NSMutableArray *seatArr = [[NSMutableArray alloc] init];
        NSArray *seatInfoArr    = [dic1 objectForKey:@"seatInfos"];
        for (int i = 0; i < seatInfoArr.count; i++) {
            NSDictionary *dic   = [seatInfoArr objectAtIndex:i];
            WPDataModel  *jsonData1 = [[WPDataModel alloc] init];
            jsonData1.seat         = [dic objectForKey:@"seat"];
            jsonData1.remainNum    = [dic objectForKey:@"remainNum"];
            jsonData1.ticketPrice  = [dic objectForKey:@"seatPrice"];
            if ([jsonData1.seat isEqualToString:@"硬卧下"]) {
                jsonData1.seat = @"硬卧";
            }
            if ([jsonData1.seat isEqualToString:@"软卧下"]) {
                jsonData1.seat = @"软卧";
            }
            [seatArr addObject:jsonData1];
            if ([otherSeatArr containsObject:[dic objectForKey:@"seat"]]) {
                [seatArr  removeLastObject];
            }

        }
        jsonData.seatInfosArr = seatArr;
        [startTimeArr addObject:jsonData.formTime];//将火车的出发时间插入到数组

        [jsonArr addObject:jsonData];
    }
    [self SortArr:startTimeArr withJsonArr:jsonArr];
    jsonArr =[self constraintTrainTypeWithJsonArr:jsonArr  withConstrainArr:typeArr];
    complete(jsonArr);

}
-(NSMutableArray*)constraintTrainTypeWithJsonArr:(NSMutableArray*)jsonArr withConstrainArr:(NSMutableArray*)constrainArr
{
    //对约束车型的查询
    NSMutableArray *constrainArr2=[[NSMutableArray alloc]init];
    if (constrainArr.count==0) {
        return jsonArr;
    }
    if ([[constrainArr objectAtIndex:0] isEqualToString:@"1001"]) {
        return jsonArr;
    }
    for (int b=0; b<constrainArr.count; b++) {
        NSString *str=[constrainArr objectAtIndex:b];
        if ([str isEqualToString:@"1002"]) {
            [constrainArr2 addObject:@"G"];
            [constrainArr2 addObject:@"D"];
        }
        
        if ([str isEqualToString:@"1003"]) {
            [constrainArr2 addObject:@"Z"];
        }
        
        if ([str isEqualToString:@"1004"]) {
            [constrainArr2 addObject:@"T"];
        }
        
        if ([str isEqualToString:@"1005"]) {
            [constrainArr2 addObject:@"K"];
        }
        
        if ([str isEqualToString:@"1006"]) {
            [constrainArr2 addObject:@"其他"];
        }
    }
    
    NSMutableArray *arr=[[NSMutableArray alloc]init];
    for (int a=0; a<jsonArr.count; a++) {
        
        WPDataModel *jsonData=[[WPDataModel alloc]init];
        jsonData =[jsonArr objectAtIndex:a];
        NSString *trainNoFirstStr=[jsonData.trainNumber substringToIndex:1];
        
        for (int b=0; b<constrainArr2.count; b++) {
            
            
            if ([[constrainArr2 objectAtIndex:b] isEqualToString:@"其他"]) {
                
                if([@"0123456789" rangeOfString:trainNoFirstStr].location !=NSNotFound)
                {
                    [arr addObject:jsonData];
                }
            }
            
            if ([trainNoFirstStr isEqualToString:[constrainArr2 objectAtIndex:b]]) {
                
                [arr addObject:jsonData];
                break;
            }
        }
        
    }
    
    return arr;
}

- (void)SortArr:(NSMutableArray *)list withJsonArr:(NSMutableArray *)jsonArr {
    NSInteger a = [list count];
    for (int j = 0; j<= a -1; j++) {
        
        for(int i = 0 ;i < a - 1 - j ; i++){
            
            NSString * a1 = [list objectAtIndex:i];
            NSString * a2 = [list objectAtIndex:i+1];
            NSArray *arr1=[a1 componentsSeparatedByString:@":"];
            NSArray *arr2=[a2 componentsSeparatedByString:@":"];
            
            NSString *A1=[NSString stringWithFormat:@"%@%@",[arr1 objectAtIndex:0],[arr1 objectAtIndex:1]];
            NSString *A2=[NSString stringWithFormat:@"%@%@",[arr2 objectAtIndex:0],[arr2 objectAtIndex:1]];
            
            
            if([A1 intValue]>[A2 intValue]){
                
                [list exchangeObjectAtIndex:i withObjectAtIndex:i+1];
                [jsonArr exchangeObjectAtIndex:i withObjectAtIndex:i+1];
            }
            
        }
        
    }
   
}

@end
