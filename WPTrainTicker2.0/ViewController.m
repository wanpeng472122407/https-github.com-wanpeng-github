//
//  ViewController.m
//  WPTrainTicker2.0
//
//  Created by 万敏 on 3/10/16.
//  Copyright © 2016 万敏. All rights reserved.
//

#import "ViewController.h"
#import "WPReslutViewController.h"
#import "CalendarHomeViewController.h"
#import "WPHotCityView.h"
#import "WPHotCityViewController.h"

#define WIDTH    [UIScreen mainScreen].bounds.size.width
#define HEIGHT   [UIScreen mainScreen].bounds.size.height
@interface ViewController () <WPHotCityViewDelegate, WPHotCityViewControllerDelegate>

@property (nonatomic, strong) UITableView                *tabView;
@property (nonatomic, strong) WPHotCityView              *hotCityView;
@property (nonatomic, strong) NSString                   *selectTepy;
@end

@implementation ViewController

- (id)init {
    if (self = [super init]) {
        self.navigationItem.title     = @"列车票查询";
        self.view.backgroundColor     = [UIColor whiteColor];
        NSDate *date                  = [[NSDate alloc] init];
        NSDateFormatter *dateFormat   = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd"];
        _dateString = [dateFormat stringFromDate:date];
        _trainTypeArray = [[NSMutableArray alloc] init];
        _fromAddress = @"北京";
        _toAddress   = @"深圳";
        
        
    }
    return self;
}

- (void)cancel {
    [self hideHotCityView];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _tabView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT - 160) style:  UITableViewStylePlain];
    _tabView.delegate    = self;
    _tabView.dataSource  = self;
    [self.view addSubview:_tabView];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(90, HEIGHT - 120, 140, 30)];
    btn.backgroundColor = [UIColor blueColor];
    [btn setTitle:@"查询" forState:UIControlStateNormal];
    btn.clipsToBounds = YES;
    btn.layer.cornerRadius = 15;
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(seeInfobutton) forControlEvents:UIControlEventTouchUpInside];
    [self addHotCityView];

}
- (void)addHotCityView {
     _hotCityView = [[WPHotCityView alloc] initWithFrame:CGRectMake(0, HEIGHT, WIDTH, 300)];
    _hotCityView.delegate = self;
    [self.view addSubview:_hotCityView];
}

- (void) showHotCityView {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
    _hotCityView.typeStr = self.selectTepy;
    [UIView animateWithDuration:0.2 animations:^{
        _hotCityView.frame = CGRectMake(0, HEIGHT-300, WIDTH, 300);
    }];
}

- (void) hideHotCityView {
    
    self.navigationItem.rightBarButtonItem = nil;
    [UIView animateWithDuration:0.2 animations:^{
        _hotCityView.frame = CGRectMake(0, HEIGHT, WIDTH, 300);
    }];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.selectTepy = nil;
    [self.tabView reloadData];
}
- (void) seeInfobutton {
    
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    for (int i=1; i<7; i++) {
        UIButton *bt = [self.view viewWithTag:1000+i];
        if (bt.selected == YES) {
            [arr addObject:[NSString stringWithFormat:@"%d",(int)bt.tag]];
        }
    }
    WPReslutViewController *ReslutViewController = [[WPReslutViewController alloc] initWithForm:_fromAddress withTo:_toAddress withDate:_dateString];
    ReslutViewController.chooseTrainTypeArr = arr;
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = item;
    [self.navigationController pushViewController:ReslutViewController animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma UITableView delegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 || indexPath.section == 1) {
        return 50;
    }
    return 80;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 1) {
        return 2;
    }
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //这个方法是点击cell松开后颜色恢复
    if (indexPath.section == 0 &&indexPath.row == 0) {
        CalendarHomeViewController *dateView = [[CalendarHomeViewController alloc] init];
        dateView.calendartitle = @"选择出发日期";
        [dateView setAirPlaneToDay:60 ToDateforString:nil];
        __weak ViewController *weakSelf = self;
        dateView.calendarblock = ^(CalendarDayModel *model){
            weakSelf.dateString=[model toString];//返回选择的对象
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.tabView reloadData];
            });
        };

        [self.navigationController pushViewController:dateView animated:YES];
    } if (indexPath.section == 1 && indexPath.row == 0 ) {
        self.selectTepy = @"请选择出发城市";
        [self showHotCityView];
    } if (indexPath.section == 1 && indexPath.row == 1) {
        self.selectTepy = @"请选择到达城市";
        [self showHotCityView];
    }
}

- (UILabel *)addLabel:(CGRect)rect stringInfo:(NSString *)str fontInfo:(NSInteger)size{

    UILabel *label      = [[UILabel alloc] initWithFrame:rect];
    label.text          = str;
    label.textColor     = [UIColor grayColor];
    label.font          = [UIFont systemFontOfSize:size];
    return label;
}

- (UITextField *)addTextField:(CGRect)rect StringInfo:(NSString *)str fontInfo:(NSInteger)size tagInfo:(NSInteger)tag {
    UITextField *textFiled   = [[UITextField alloc] initWithFrame:rect];
    textFiled.textAlignment  = NSTextAlignmentCenter;
    textFiled.font           = [UIFont systemFontOfSize:size];
    textFiled.textColor      = [UIColor redColor];
    textFiled.delegate       = self;
    textFiled.tag            = tag;
    textFiled.borderStyle    = UITextBorderStyleRoundedRect;
    textFiled.text           = str;
    return textFiled;
}

- (UIButton *)addButton:(CGRect)rect stringInfo:(NSString *)str tagInfo:(NSInteger)tag {
    UIButton *but = [[UIButton alloc]initWithFrame:rect];
    [but addTarget:self action:@selector(selectTrain:) forControlEvents:UIControlEventTouchUpInside];
    [but setTitle:str forState:UIControlStateNormal];
    but.titleLabel.font = [UIFont systemFontOfSize:14];
    [but setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    but.tag = tag;
    return but;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    static NSString *cellstr = @"cell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellstr];
//    if (cell == nil) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellstr];
//    }
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    if ( indexPath.section == 0 && indexPath.row == 0) {
        UILabel *label = [self addLabel:CGRectMake(5, 5, 80, 40) stringInfo:@"出发时间" fontInfo:14];
        cell.accessoryType  = UITableViewCellAccessoryDisclosureIndicator;
        label.textAlignment = NSTextAlignmentRight;
        [cell.contentView addSubview:label];
        
        
        UILabel *labelDate = [self addLabel:CGRectMake(100, 5, 150, 40) stringInfo:_dateString fontInfo:18];
        labelDate.textAlignment = NSTextAlignmentCenter;
        [cell.contentView addSubview:labelDate];
        
    } else if (indexPath.section == 1 && indexPath.row == 0) {

        UILabel *label = [self addLabel:CGRectMake(5, 5, 80, 40) stringInfo:@"始发站:" fontInfo:14];
        label.textAlignment = NSTextAlignmentRight;
        cell.accessoryType  = UITableViewCellAccessoryDisclosureIndicator;
        [cell.contentView addSubview:label];
        
        
        UITextField *textFiled   = [self addTextField:CGRectMake(100, 5, 180, 40) StringInfo:_fromAddress fontInfo:(NSInteger)16 tagInfo:300];
        [cell.contentView addSubview:textFiled];
        
    } else if (indexPath.section == 1 && indexPath.row == 1) {

        UILabel *label = [self addLabel:CGRectMake(5, 5, 80, 40) stringInfo:@"终点站:" fontInfo:14];
        label.textAlignment = NSTextAlignmentRight;
        cell.accessoryType  = UITableViewCellAccessoryDisclosureIndicator;
        [cell.contentView addSubview:label];
        
        UITextField *textFiled   = [self addTextField:CGRectMake(100, 5, 180, 40) StringInfo:_toAddress fontInfo:(NSInteger)16 tagInfo:200];
        [cell.contentView addSubview:textFiled];
        
    } else if (indexPath.section == 2 && indexPath.row == 0){

        UILabel *label = [self addLabel:CGRectMake(5, 5, 80, 30) stringInfo:@"出发时间:" fontInfo:14];
        label.textAlignment = NSTextAlignmentRight;
        [cell.contentView addSubview:label];
        
        UIButton *but1 = [self addButton:CGRectMake(100, 5, 90, 30) stringInfo:@"全部车次" tagInfo:1001];
        [cell.contentView addSubview:but1];
        
        
        UIButton *but2 = [self addButton:CGRectMake(200, 5, 90, 30) stringInfo:@"GD-高铁/动车" tagInfo:1002];
        [cell.contentView addSubview:but2];
        
        UIButton *but3 = [self addButton:CGRectMake(80, 40, 50, 30) stringInfo:@"Z-直达" tagInfo:1003];
        [cell.contentView addSubview:but3];
        
        UIButton *but4 = [self addButton:CGRectMake(140, 40, 50, 30) stringInfo:@"T-特快" tagInfo:1004];
        [cell.contentView addSubview:but4];
        
        UIButton *but5 = [self addButton:CGRectMake(200, 40, 50, 30) stringInfo:@"K-普快" tagInfo:1005];
        [cell.contentView addSubview:but5];
        
        UIButton *but6 = [self addButton:CGRectMake(260, 40, 50, 30) stringInfo:@"其他" tagInfo:1006];
        [cell.contentView addSubview:but6];

        
    }
    
    return cell;
}

- (void)selectTrain:(UIButton *)sender {

    sender.clipsToBounds = YES;
    sender.layer.cornerRadius = 10.0f;
    if (sender.tag == 1001 && sender.selected == NO) {
        
        sender.selected = YES;
        sender.backgroundColor = [UIColor yellowColor];
        
        for (int i = 1; i<6; i++) {
            UIButton* btn = [self.view viewWithTag:1001+i];
            btn.selected = NO;
            btn.backgroundColor = [UIColor whiteColor];
        }
    } else if (sender.tag == 1001 && sender.selected == YES) {
        
        sender.backgroundColor = [UIColor whiteColor];
        sender.selected = NO;
        UIButton* bt = [self.view viewWithTag:1001];
        bt.backgroundColor = [UIColor whiteColor];
        bt.selected = NO;
    }
    
    if (sender.tag != 1001 && sender.selected == YES) {
        
        sender.selected = NO;
        sender.backgroundColor = [UIColor whiteColor];
        
    } else if (sender.tag != 1001 && sender.selected == NO) {
        
        sender.selected = YES;
        sender.backgroundColor = [UIColor yellowColor];
        UIButton *bt = [self.view viewWithTag:1001];
        bt.selected = NO;
        bt.backgroundColor = [UIColor whiteColor];
    }
}

- (void)hotCityView:(NSString *)cityString type:(BOOL)type {
    if (type) {
        _fromAddress = cityString;
    } else {
        _toAddress   = cityString;
    }
    [self hideHotCityView];
    [_tabView reloadData];
}

- (void)hotCityViewController:(NSString *)cityString type:(BOOL)type {
    if (type) {
        _fromAddress = cityString;
    } else {
        _toAddress   = cityString;
    }
    [_tabView reloadData];
}
- (void)hotCityViewPushViewController {
    [self hideHotCityView];
    WPHotCityViewController *hotViewController = [[WPHotCityViewController alloc] init];
    hotViewController.delegate = self;
    hotViewController.typeString = self.selectTepy;
    [self.navigationController pushViewController:hotViewController animated:YES];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    if (textField.tag == 200) {
        self.selectTepy = @"请选择到达城市";
    } else if (textField.tag == 300) {
        self.selectTepy = @"请选择出发城市";
    }
    [self showHotCityView];
    return NO;
}
@end

