//
//  UserModCityHeaderView.h
//  UBaby
//
//  Created by fengei on 16/11/22.
//  Copyright © 2016年 fengei. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UserModCityHeaderViewDelegate <NSObject>

- (void) modCityHeaderView:(NSString *)city;

@end
@interface UserModCityHeaderView : UIView

@property (nonatomic,strong) NSArray *arrayHotCity;//热门城市
@property (nonatomic,strong) NSString *stringCity;
@property (nonatomic,assign) id<UserModCityHeaderViewDelegate> delegate;

- (void) writeToFile:(NSString *)title;

@end
