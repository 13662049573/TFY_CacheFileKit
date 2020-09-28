//
//  TFY_OpenFileTool.h
//  TFY_CacheFileKit
//
//  Created by 田风有 on 2020/9/26.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    TFY_Document,//直接预览  然后在预览中选择是否使用其他软件打开
    TFY_DocumentOpenInMenu,//显示提示框 但是第三行不能选择预览
    TFY_DocumentOptionsMenu,//显示提示框 再选择是否开启预览
} TFY_DocumentMode;


NS_ASSUME_NONNULL_BEGIN

@interface TFY_OpenFileTool : NSObject

+ (instancetype)sharedOpenfileTool;

/**
 通过自定义按钮点击 开启UIDocumentIntractionController选择打开文件
 */
- (void)openFileWithFilePath:(NSURL *)filePath andVC:(UIViewController *)viewController andNavTitleName:(NSString *)name Document:(TFY_DocumentMode)document;

/**
 通过导航栏BarButtonItem 开启UIDocumentIntractionController选择打开文件
 */
- (void)openFileWithFilePath:(NSURL *)filePath andItem:(UIBarButtonItem *)barButtonItem andNavTitleName:(NSString *)name andVC:(UIViewController *)viewController Document:(TFY_DocumentMode)document;

@end

NS_ASSUME_NONNULL_END
