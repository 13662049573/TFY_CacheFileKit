//
//  TFY_CacheFileCollectionCell.h
//  TFY_CacheFileKit
//
//  Created by 田风有 on 2020/9/25.
//

#import <UIKit/UIKit.h>
#import "TFY_CacheFileModel.h"

static NSInteger const columnNumber = 2;

#define widthScreen ([[UIScreen mainScreen] bounds].size.width)

#define widthCollectionViewCell ((widthScreen - 10.0 * (columnNumber + 1)) / columnNumber)
static CGFloat const heightCollectionViewCell = 120.0;
static NSString * _Nonnull const identifierCollectionViewCell = @"CollectionViewCell";

NS_ASSUME_NONNULL_BEGIN

@interface TFY_CacheFileCollectionCell : UICollectionViewCell
/// 数据源
@property (nonatomic, strong) TFY_CacheFileModel *model;
/// 长按回调
@property (nonatomic, copy) void (^longPress)(void);
@end

NS_ASSUME_NONNULL_END
