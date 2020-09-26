//
//  TFY_CacheFileTable.h
//  TFY_CacheFileKit
//
//  Created by 田风有 on 2020/9/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TFY_CacheFileTable : UITableView
/// 数据源
@property (nonatomic, strong) NSMutableArray *cacheDatas;

/// 响应回调
@property (nonatomic, copy) void (^itemClick)(NSIndexPath *indexPath);
/// 长按回调
@property (nonatomic, copy) void (^longPress)(TFY_CacheFileTable *table, NSIndexPath *indexPath);

- (void)deleItemAtIndex:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
