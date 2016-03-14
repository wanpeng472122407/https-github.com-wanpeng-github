//
//  WPHotCityViewController.m
//  WPTrainTicker2.0
//
//  Created by 万敏 on 3/11/16.
//  Copyright © 2016 万敏. All rights reserved.
//

#import "WPHotCityViewController.h"
#import "ZYPinYinSearch.h"
#import "PinYinForObjc.h"
@interface WPHotCityViewController () <UISearchBarDelegate>
@property (nonatomic, strong) UITableView      *tabView;
@property (nonatomic, strong) NSMutableArray   *arrayCitys;
@property (nonatomic, strong) NSMutableDictionary *citys;
@property (nonatomic, strong) NSMutableArray *keys;
@property (nonatomic, strong) UITextField *searchText;
@property (nonatomic, strong) NSMutableDictionary *searchResultDic;
@property (nonatomic, strong) UIView *tableHeaderView;

@end

@implementation WPHotCityViewController

- (id)init {
    if (self = [super init]) {
        self.view.backgroundColor = [UIColor whiteColor];
    }
    return self;
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.searchText resignFirstResponder];
    self.searchText.text = nil;
}
- (void)viewDidAppear:(BOOL)animated {
    self.navigationItem.title = self.typeString;

}
- (void)viewDidLoad {
    [super viewDidLoad];
    _keys       = [NSMutableArray array];
    _arrayCitys = [NSMutableArray array];

    // Do any additional setup after loading the view.
    
    //3自定义背景
    UIView *searchView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 40*(self.view.frame.size.height/568))];
    searchView.backgroundColor = [UIColor clearColor];
    
    UIImageView *searchBg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bg"]];
    searchBg.frame = CGRectMake(0, 0, searchView.frame.size.width, searchView.frame.size.height);
    [searchView addSubview:searchBg];
    
    //搜索框
    _searchText = [[UITextField alloc]initWithFrame:CGRectMake(30*(self.view.frame.size.width/320), 0, self.view.frame.size.width-30, searchView.frame.size.height)];
    _searchText.backgroundColor = [UIColor clearColor];
    _searchText.font = [UIFont systemFontOfSize:13];
    _searchText.placeholder  = @"请输入城市名称或首字母查询";
    _searchText.returnKeyType = UIReturnKeySearch;
    _searchText.textColor    = [UIColor colorWithRed:58/255.0 green:58/255.0 blue:58/255.0 alpha:1];
    _searchText.delegate     = self;
    [_searchText addTarget:self action:@selector(textchange:) forControlEvents:UIControlEventEditingChanged];
    [searchView addSubview:_searchText];
    [self.view addSubview:searchView];
    
    _tabView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tabView.frame           = CGRectMake(0,searchView.frame.origin.y+searchView.frame.size.height, self.view.frame.size.width, self.view.frame.size.height-64);
    _tabView.backgroundColor = [UIColor whiteColor];
    _tabView.delegate        = self;
    _tabView.dataSource      = self;
    [self.view addSubview:_tabView];
    [self getCityDatas];
}

- (void)textchange:(UITextField *)textField
{
    [self filterContentForSearchText:textField.text];
}
//通过搜索条件过滤得到搜索结果
- (void)filterContentForSearchText:(NSString*)searchText {
    
    if (searchText.length > 0) {
        _searchResultDic = nil;
        _searchResultDic = [[NSMutableDictionary alloc]init];
        if ([searchText isEqualToString:@"Changs"]) {
            searchText = @"Zhangs";
        }
        //搜索数组中是否含有关键字
        NSArray *resultAry  = [ZYPinYinSearch searchWithOriginalArray:_arrayCitys andSearchText:searchText andSearchByPropertyName:@""];
        //     NSLog(@"搜索结果:%@",resultAry) ;
        
        for (NSString*city in resultAry) {
            //获取字符串拼音首字母并转为大写
            NSString *pinYinHead = [PinYinForObjc chineseConvertToPinYinHead:city].uppercaseString;
            NSString *firstHeadPinYin = [pinYinHead substringToIndex:1]; //拿到字符串第一个字的首字母
            //        NSLog(@"pinYin = %@",firstHeadPinYin);
            
            
            NSMutableArray *cityAry = [NSMutableArray arrayWithArray:[_searchResultDic objectForKey:firstHeadPinYin]]; //取出首字母数组
            
            if (cityAry != nil) {
                
                [cityAry addObject:city];
                
                NSArray *sortCityArr = [cityAry sortedArrayUsingFunction:cityNameSort context:NULL];
                [_searchResultDic setObject:sortCityArr forKey:firstHeadPinYin];
                
            }else
            {
                cityAry= [[NSMutableArray alloc]init];
                [cityAry addObject:city];
                NSArray *sortCityArr = [cityAry sortedArrayUsingFunction:cityNameSort context:NULL];
                [_searchResultDic setObject:sortCityArr forKey:firstHeadPinYin];
            }
            
            
            
        }
        //    NSLog(@"dic = %@",dic);
        
        if (resultAry.count>0) {
            _citys = nil;
            _citys = _searchResultDic;
            [_keys removeAllObjects];
            //按字母升序排列
            [_keys addObjectsFromArray:[[_citys allKeys] sortedArrayUsingSelector:@selector(compare:)]] ;
            _tabView.tableHeaderView = nil;
            [_tabView reloadData];
        }
        
    }else
    {
        //当字符串清空时 回到初始状态
        _citys = nil;
        [_keys removeAllObjects];
        [_arrayCitys removeAllObjects];
        [self getCityDatas];
        _tabView.tableHeaderView = _tableHeaderView;
        [_tabView reloadData];
    }
    
    
}
NSInteger cityNameSort(id str1, id str2, void *context)
{
    NSString *string1 = (NSString*)str1;
    NSString *string2 = (NSString*)str2;
    
    return  [string1 localizedCompare:string2];
}
- (void) getCityDatas {
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"citydict" ofType:@"plist"];
    _citys = [NSMutableDictionary dictionaryWithContentsOfFile:path];
    [_keys addObjectsFromArray:[[self.citys allKeys] sortedArrayUsingSelector:@selector(compare:)]];//对城市的首字母进行排序
    NSArray *all = [self.citys allValues];
    for (NSArray *ary in all) {
        for (NSString *cityName in ary) {
            [_arrayCitys addObject:cityName];//获取所有城市
        }
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 20)];
    bgView.backgroundColor = [UIColor redColor];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(13, 0, 250, 20)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.font = [UIFont systemFontOfSize:15];
    
    UIImageView *line = [[UIImageView alloc]initWithFrame:CGRectMake(0, 19, bgView.frame.size.width, 1)];
    line.backgroundColor = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1];
    
    
    NSString *key = [_keys objectAtIndex:section];
    
    titleLabel.text = key;
    [bgView addSubview:line];
    
    [bgView addSubview:titleLabel];
    
    return bgView;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [_keys count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSString *key = [_keys objectAtIndex:section];
    NSArray *citySection = [_citys objectForKey:key];
    return [citySection count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    NSString *key = [_keys objectAtIndex:indexPath.section];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.textLabel setTextColor:[UIColor blackColor]];
        cell.textLabel.font = [UIFont systemFontOfSize:18];
    }
    cell.textLabel.text = [[_citys objectForKey:key] objectAtIndex:indexPath.row];
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSString * cellString = cell.textLabel.text;
    
    if ([self.delegate respondsToSelector:@selector(hotCityViewController:type:)]) {
        if ([self.typeString isEqualToString:@"请选择出发城市"]) {
            
            [self.delegate hotCityViewController:cellString type:YES];
            
        } else if ([self.typeString isEqualToString:@"请选择到达城市"]) {
            
            [self.delegate hotCityViewController:cellString type:NO];

        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}
@end
