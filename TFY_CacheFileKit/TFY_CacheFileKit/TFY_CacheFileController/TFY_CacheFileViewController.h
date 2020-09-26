//
//  TFY_CacheFileViewController.h
//  TFY_CacheFileKit
//
//  Created by 田风有 on 2020/9/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TFY_CacheFileViewController : UIViewController
/**导航栏标题（默认缓存目录）*/
@property (nonatomic, strong) NSString *cacheTitle;
/**数据源（默认home目录）*/
@property (nonatomic, strong) NSMutableArray *cacheArray;

/**显示样式（默认0列表，1九宫格）*/
@property (nonatomic, assign) NSInteger showType;
@end

NS_ASSUME_NONNULL_END
