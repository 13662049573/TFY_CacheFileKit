//
//  TFY_CacheFileRead.h
//  TFY_CacheFileKit
//
//  Created by 田风有 on 2020/9/25.
//  文件浏览

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TFY_CacheFileRead : NSObject
/**
 *  文件阅读：图片浏览、文档查看、音视频播放
 *
 *   filePath 文件路径
 *   target   UIViewController
 */
- (void)fileReadWithFilePath:(NSString *)filePath target:(id)target;

/**
 *  内存释放
 */
- (void)releaseSYCacheFileRead;
@end

NS_ASSUME_NONNULL_END
