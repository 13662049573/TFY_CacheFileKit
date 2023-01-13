//
//  TFY_DocumentPicker.h
//  TFY_CacheFileKit
//
//  Created by 田风有 on 2023/1/13.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, TFY_DocumentMode) {
    TFY_DocumentModeImport,
    TFY_DocumentModeOpen,
    TFY_DocumentModeExportToService,
    TFY_DocumentModeMoveToService
};

typedef enum : NSUInteger {
    TFY_Document,//直接预览  然后在预览中选择是否使用其他软件打开
    TFY_DocumentOpenInMenu,//显示提示框 但是第三行不能选择预览
    TFY_DocumentOptionsMenu,//显示提示框 再选择是否开启预览
} TFY_DocumentCustomizeMode;


@interface TFY_DocumentPicker : NSObject

+ (instancetype)sharedOpen;

/**
 通过自定义按钮点击 开启UIDocumentIntractionController选择打开文件
 */
- (void)openFileWithFilePath:(NSURL *)filePath andNavTitleName:(NSString *)name Document:(TFY_DocumentCustomizeMode)document;

/**
 通过导航栏BarButtonItem 开启UIDocumentIntractionController选择打开文件
 */
- (void)openFileWithFilePath:(NSURL *)filePath andItem:(UIBarButtonItem *)barButtonItem andNavTitleName:(NSString *)name Document:(TFY_DocumentCustomizeMode)document;

/**
 获取系统文件内容
 */
- (void)acquireDocument:(TFY_DocumentMode)document Block:(void(^)(NSString *fileName,NSString *filePath))block;

@end

NS_ASSUME_NONNULL_END
