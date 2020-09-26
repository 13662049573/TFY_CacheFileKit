//
//  TFY_CacheFileImage.h
//  TFY_CacheFileKit
//
//  Created by 田风有 on 2020/9/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TFY_CacheFileImage : UIView
/// 图片数组
@property (nonatomic, strong) NSArray <NSString *> *images;
/// 图片索引（默认0第一张）
@property (nonatomic, assign) NSInteger index;
/// 图片刷新
- (void)reloadImages;
@end

@interface TFY_CacheScaleImage : UIView

/// 图片点击回调
@property (nonatomic, copy) void (^imageTap)(void);

/// 图片显示（根据路径）
- (void)showImageWithFilePath:(NSString *)filePath;

@end

NS_ASSUME_NONNULL_END
