//
//  TFY_CacheFileKit.h
//  TFY_CacheFileKit
//
//  Created by 田风有 on 2020/9/25.
//  最新版本:2.0.1

#import <Foundation/Foundation.h>

FOUNDATION_EXPORT double TFY_CacheFileKitVersionNumber;

FOUNDATION_EXPORT const unsigned char TFY_CacheFileKitVersionString[];

#define TFY_CacheFileKitRelease 0

#if TFY_CacheFileKitRelease

#import <TFY_CacheFileManager/TFY_CacheFileManager.h>
#import <TFY_CacheFileController/TFY_CacheFileViewController.h>
#import <TFY_FilePreviewController/TFY_FilePreviewController.h>
#import <TFY_FilePreviewController/TFY_OpenFileTool.h>

#else
//文件管理
#import "TFY_CacheFileManager.h"
//浏览
#import "TFY_CacheFileViewController.h"
//直接浏览文件
#import "TFY_FilePreviewController.h"
//分享
#import "TFY_OpenFileTool.h"

#endif
