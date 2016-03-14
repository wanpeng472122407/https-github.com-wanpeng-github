//
//  WPHotCityView.m
//  WPTrainTicker2.0
//
//  Created by 万敏 on 3/11/16.
//  Copyright © 2016 万敏. All rights reserved.
//

#import "WPHotCityView.h"
#define WIDTH        [UIScreen mainScreen].bounds.size.width
#define HEIGHT       [UIScreen mainScreen].bounds.size.height
@implementation WPHotCityView

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self insetHearView];
        [self insetButton];
        [self insetBottom];
        
    }
    return self;
}

- (void)insetHearView {
    UIView *hearView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 30)];
    
    hearView.backgroundColor = [UIColor yellowColor];
    UILabel *hearLabel = [[UILabel alloc] initWithFrame:hearView.frame];
    hearLabel.font = [UIFont systemFontOfSize:14];
    hearLabel.textAlignment = NSTextAlignmentCenter;
    hearLabel.text = @"热门城市";
    hearLabel.textColor = [UIColor redColor];
    [hearView addSubview:hearLabel];
    [self addSubview:hearView];
}

- (void)insetBottom {
    UIButton *pushButton = [[UIButton alloc] initWithFrame:CGRectMake(200, 240, 100, 30)];
    [pushButton setTitle:@"更多选择 >>>" forState:UIControlStateNormal];
    pushButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [pushButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [pushButton addTarget:self action:@selector(pushOthers) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:pushButton];
}
- (void)insetButton {
        _hotCityArray = @[@"北京",@"上海",@"广州",@"深圳",@"天津",@"南京",@"武汉",@"长沙",@"杭州",@"苏州",@"成都",@"沈阳",@"重庆",@"西安",@"合肥",@"厦门",@"哈尔滨",@"太原"];
        NSInteger btnNO = 0;
        for (int m = 0; m<5; m++) {
            for (int n = 0; n<4; n++) {
                if (btnNO>17) {
                    break;
                }
                UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(16+60*n+16*n, 40+40*m+10*m, 60, 30)];
                btn.tag = btnNO;
                [btn setTitle:[_hotCityArray objectAtIndex:btnNO] forState:UIControlStateNormal];
                btn.titleLabel.font = [UIFont systemFontOfSize:14];
                [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [btn addTarget:self action:@selector(selectHotCity:) forControlEvents:UIControlEventTouchUpInside];
                [self addSubview:btn];
                btnNO = btnNO + 1;
                
            }
        }
}
- (void)pushOthers {
    if ([self.delegate respondsToSelector:@selector(hotCityViewPushViewController)]) {
        [self.delegate hotCityViewPushViewController];
    }
}

- (void)selectHotCity:(UIButton *)sender {
    NSString *btString = sender.titleLabel.text;
    if ([self.delegate respondsToSelector:@selector(hotCityView:type:)]) {
        if ([_typeStr isEqualToString:@"请选择出发城市"]) {
            [self.delegate hotCityView:btString type:YES];

        } else if ([_typeStr isEqualToString:@"请选择到达城市"]) {
            [self.delegate hotCityView:btString type:NO];

        }
    }
}
@end
