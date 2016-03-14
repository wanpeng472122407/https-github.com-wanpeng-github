//
//  WPReslutViewController.m
//  WPTrainTicker
//
//  Created by 万敏 on 3/10/16.
//  Copyright © 2016 万敏. All rights reserved.
//

#import "WPReslutViewController.h"
#import "WPReslutViewCell.h"
#import "XCHudHelper.h"
#import "WPRuqestData.h"
#import "WPDataModel.h"
//#import <>
@implementation WPReslutViewController

- (id)initWithForm:(NSString *)formAddress withTo:(NSString *)toAddress withDate:(NSString *)date {
    if (self == [super init]) {
        _trainArray = [[NSMutableArray alloc] init];
        _timeStr    = @"00:00-24:00";
        NSString* urlStr    = @"http://apis.baidu.com/qunar/qunar_train_service/s2ssearch";
        NSString *urlString = [NSString stringWithFormat:@"%@?version=1.0&from=%@&to=%@&date=%@",urlStr,formAddress,toAddress,date];
        _requstURLString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        self.title = [NSString stringWithFormat:@"%@ - %@",formAddress,toAddress];
        self.view.backgroundColor = [UIColor whiteColor];
        
     }
    return self;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    _reslutTableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    _reslutTableView.delegate   = self;
    _reslutTableView.dataSource = self;
    [self.view addSubview:_reslutTableView];
    [self requestData:_requstURLString];
    
    [[XCHudHelper sharedInstance] showHudOnWindow:@"查询中" image:nil acitivity:YES autoHideTime:0];
}

- (void)requestData:(NSString *)requestURL {
    WPRuqestData *request = [[WPRuqestData alloc] init];
    [request requestHttpDataURL:_requstURLString complete:^(NSDictionary *dic) {
        
        NSDictionary   *data          = [dic objectForKey:@"data"];
        id objc = [data objectForKey:@"trainList"];
        if ( [objc isKindOfClass:[NSNull class]] ) {
            [[XCHudHelper sharedInstance] hideHud];
            [self addAlertView];
            return ;
        }
        
        WPDataModel *jsonData = [[WPDataModel alloc] init];
        [jsonData chooseWithDictionary:dic withString:_timeStr withChooseTrainTypeArr:_chooseTrainTypeArr complete:^(NSMutableArray *dataArr) {
            _trainArray = dataArr;
            if (_trainArray.count == 0) {
                
                [self addAlertView];
                return;
            }

            _retrunTrainNumber =[NSString  stringWithFormat:@"查询到%lu趟列车",(unsigned long)_trainArray.count];
            [_reslutTableView reloadData];
        }];
    }];
    
}

- (void)addAlertView {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"没有符合条件的车次" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * action = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController popViewControllerAnimated:YES];
        
    }];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_trainArray count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *str = @"cellStr";
    WPReslutViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (cell == nil) {
        NSArray* array = [[NSBundle mainBundle] loadNibNamed:@"WPReslutViewCell" owner:nil options:nil];
        for (WPReslutViewCell *arCel in array) {
            cell = arCel;
        }
    }
    WPDataModel *dataModel = [_trainArray objectAtIndex:indexPath.row];
    cell.trainNumber.text  = dataModel.trainNumber;
    cell.trainType.text    = dataModel.trainType;
    cell.formTime.text     = dataModel.formTime;
    cell.toTime.text       = dataModel.toTime;
    cell.formAddress.text  = dataModel.formAddress;
    cell.toAddress.text    = dataModel.toAddress;
    cell.totalTime.text    = dataModel.totalTime;
    cell.seatArr           = dataModel.seatInfosArr;
//    cell.ticketPrice.text;
    
    NSMutableArray *arr    = [[NSMutableArray alloc] init];
    NSMutableArray *arr2   = [[NSMutableArray alloc] init];
    NSMutableArray *arr3   = [[NSMutableArray alloc] init];

    for (int a = 0; a <cell.seatArr.count; a++) {
        WPDataModel *jsonData = [cell.seatArr objectAtIndex:a];
        [arr addObject:jsonData.seat];
        [arr2 addObject:jsonData.remainNum];
        [arr3 addObject:jsonData.ticketPrice];
    }
    for (int b=0; b<arr.count; b++) {
        cell.seat1.text=[NSString stringWithFormat:@"%@:%@",arr[0],arr2[0]];
        cell.seat1Price.text = [NSString stringWithFormat:@"价格:%@",arr3[0]];

        if (cell.seatArr.count==1) {
            cell.seat2.text=nil;
            cell.seat3.text=nil;
            cell.seat2Price.text = nil;
            cell.seat3Price.text = nil;
            cell.totalTicketNumber.text = [NSString stringWithFormat:@"余(%@张)",arr2[0]];
            break;
        }
        cell.seat2.text=[NSString stringWithFormat:@"%@:%@",arr[1],arr2[1]];
        cell.seat2Price.text = [NSString stringWithFormat:@"价格:%@",arr3[1]];

        if (cell.seatArr.count==2) {
            NSInteger i = [arr2[0] integerValue];
            NSInteger j = [arr2[1] integerValue];
            NSInteger m = i+j;
            cell.totalTicketNumber.text = [NSString stringWithFormat:@"余(%li 张)",m];
            cell.seat3.text=nil;
            cell.seat3Price.text = nil;
            break;
        }
        cell.seat3.text=[NSString stringWithFormat:@"%@:%@",arr[2],arr2[2]];
        cell.seat3Price.text = [NSString stringWithFormat:@"价格:%@",arr3[2]];

        NSInteger i = [arr2[0] integerValue];
        NSInteger j = [arr2[1] integerValue];
        NSInteger m = [arr2[2] integerValue];
        NSInteger n = i+j+m;
//        cell.totalTicketNumber.text = [NSString stringWithFormat:@"余(%li 张)",n];

    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
    view.backgroundColor = [UIColor yellowColor];
    UILabel* laber = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 320, 30)];
    laber.textAlignment = NSTextAlignmentCenter;
    laber.textColor = [UIColor redColor];
    NSString* str = [NSString stringWithFormat:@"为您查询到了%li趟列车信息",_trainArray.count];
    NSMutableAttributedString *attrString =
    [[NSMutableAttributedString alloc] initWithString:str];
    
    NSUInteger length = [str length];
    
    // 设置基本字体
    UIFont *baseFont = [UIFont systemFontOfSize:18];
    [attrString addAttribute:NSFontAttributeName value:baseFont
                       range:NSMakeRange(0, length)];
    laber.attributedText = attrString;
    [view addSubview:laber];
    if ([_trainArray count] == 0) {
        view.alpha = 0.0;
    }
    
    return view;
}
@end
