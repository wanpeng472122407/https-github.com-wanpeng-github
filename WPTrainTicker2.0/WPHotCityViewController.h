//
//  WPHotCityViewController.h
//  WPTrainTicker2.0
//
//  Created by 万敏 on 3/11/16.
//  Copyright © 2016 万敏. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WPHotCityViewControllerDelegate <NSObject>

- (void)hotCityViewController:(NSString *)cityString type:(BOOL)type;

@end

@interface WPHotCityViewController : UIViewController<UITableViewDataSource, UITableViewDelegate,UITextFieldDelegate>
@property (nonatomic, weak)id<WPHotCityViewControllerDelegate>delegate;
@property (nonatomic, strong) NSString *typeString;
@end
