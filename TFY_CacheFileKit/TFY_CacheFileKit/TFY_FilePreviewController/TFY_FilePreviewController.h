//
//  TFY_FilePreviewController.h
//  TFY_CacheFileKit
//
//  Created by 田风有 on 2020/9/25.
//

#import <QuickLook/QuickLook.h>

NS_ASSUME_NONNULL_BEGIN

@interface TFY_FilePreviewController : QLPreviewController
/**自定义文件名称*/
@property (nonatomic, strong) NSString *previewItemTitle;

/** 预览多个文件 单个文件时数组传一个 */
@property(nonatomic , copy)NSArray<NSURL *> *filePathArr;

//单文件预览
@property(nonatomic , strong)NSURL *fileUrl;

/** 将要退出 */
- (void)setWillDismissBlock:(void (^)(void))willDismissBlock;

/** 已经退出 */
- (void)setDidDismissBlock:(void (^)(void))didDismissBlock;

/** 将要访问文件中的Url回调  BOOL 是否允许访问*/
- (void)setShouldOpenUrlBlock:(BOOL (^)(NSURL *, id<QLPreviewItem>))shouldOpenUrlBlock;

#pragma mark ------- 自定义浏览器使用 --------

//加载数据 同时设置当前预览的文件  多文件
- (void)loadUrlPathList:(NSArray<NSURL *> *)urlPathList andCurrentPreVItemIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
