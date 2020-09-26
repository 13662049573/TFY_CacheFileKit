//
//  TFY_FilePreviewController.h
//  TFY_CacheFileKit
//
//  Created by 田风有 on 2020/9/25.
//

#import <QuickLook/QuickLook.h>

typedef enum : NSUInteger {
    TFY_JumpPush,//push 无动画
    TFY_JumpPushAnimat,//push 有动画
    TFY_JumpPresent,//Present 无动画
    TFY_JumpPresentAnimat,//Present 有动画
} TFY_JumpMode;

NS_ASSUME_NONNULL_BEGIN

@interface TFY_FilePreviewController : QLPreviewController
/** 预览多个文件 单个文件时数组传一个 */
- (void)previewFileWithPaths:(NSArray <NSURL *>*)filePathArr on:(UIViewController *)vc jump:(TFY_JumpMode)jump;

//单文件预览
- (void)previewFileloadUrlPath:(NSURL *)fileUrl on:(UIViewController *)vc jump:(TFY_JumpMode)jump;

/** 将要退出 */
- (void)setWillDismissBlock:(void (^)(void))willDismissBlock;

/** 已经退出 */
- (void)setDidDismissBlock:(void (^)(void))didDismissBlock;

/** 将要访问文件中的Url回调  BOOL 是否允许访问*/
- (void)setShouldOpenUrlBlock:(BOOL (^)(NSURL *, id<QLPreviewItem>))shouldOpenUrlBlock;

@end

NS_ASSUME_NONNULL_END
