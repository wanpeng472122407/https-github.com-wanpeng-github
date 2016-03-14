//
//  WPHotCityView.h
//  WPTrainTicker2.0
//
//  Created by 万敏 on 3/11/16.
//  Copyright © 2016 万敏. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WPHotCityViewDelegate <NSObject>

- (void)hotCityView:(NSString *)cityString type:(BOOL)type;
- (void)hotCityViewPushViewController;

@end

@interface WPHotCityView : UIView

@property (nonatomic, strong) NSArray* hotCityArray;
@property (nonatomic,   weak) id<WPHotCityViewDelegate>delegate;
@property (nonatomic, strong) NSString* typeStr;
@end
