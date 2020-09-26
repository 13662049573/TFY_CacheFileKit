//
//  TFY_CacheFileCell.h
//  TFY_CacheFileKit
//
//  Created by 田风有 on 2020/9/25.
//

#import <UIKit/UIKit.h>
#import "TFY_CacheFileModel.h"
NS_ASSUME_NONNULL_BEGIN

static NSString *const reuseCacheDirectoryCell = @"CacheDirectoryCell";
static CGFloat const heightCacheDirectoryCell = 60.0;

@interface TFY_CacheFileCell : UITableViewCell
/// 数据源
@property (nonatomic, strong) TFY_CacheFileModel *model;
/// 长按回调
@property (nonatomic, copy) void (^longPress)(void);
@end

NS_ASSUME_NONNULL_END
