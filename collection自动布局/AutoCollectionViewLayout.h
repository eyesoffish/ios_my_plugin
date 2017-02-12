//
//  AutoCollectionViewLayout.h
//  UBaby
//
//  Created by fengei on 16/11/11.
//  Copyright © 2016年 fengei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AutoCollectionViewLayout : UICollectionViewFlowLayout

// 一行中 cell的个数
@property (nonatomic) NSUInteger itemCountPerRow;
// 一页显示多少行
@property (nonatomic) NSUInteger rowCount;
@end
