//
//  TFY_CacheFileRead.m
//  TFY_CacheFileKit
//
//  Created by 田风有 on 2020/9/25.
//

#import "TFY_CacheFileRead.h"
// 文档
#import <QuickLook/QuickLook.h>

#import "TFY_CacheFileAudio.h"
#import "TFY_CacheFileManager.h"
#import "TFY_CacheFileUilt.h"
#import "TFY_CacheFileImage.h"

@interface TFY_CacheFileRead ()<UIDocumentInteractionControllerDelegate, UIScrollViewDelegate>
@property (nonatomic, weak) UIViewController *controller;

// 图片显示
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) TFY_CacheFileImage *fileImage;

// 文档查看（文档、图片、视频）
@property (nonatomic, strong) UIDocumentInteractionController *documentController;

@end

@implementation TFY_CacheFileRead
// 内存管理
- (void)dealloc
{
    NSLog(@"%@ 被释放了!", [self class]);
}

- (void)releaseSYCacheFileRead
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

/**
 *  文件阅读：图片浏览、文档查看、音视频播放
 *
 *   filePath 文件路径
 *   target   UIViewController
 */
- (void)fileReadWithFilePath:(NSString *)filePath target:(id)target
{
    if (filePath == nil || ![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"filePath指向文件不存在" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [[TFY_CacheFileUilt presentMenuView] presentViewController:alertController animated:YES completion:nil];
        return;
    }
    if (target == nil || ![target isKindOfClass:[UIViewController class]]) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"target类型不是UIViewController" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [[TFY_CacheFileUilt presentMenuView] presentViewController:alertController animated:YES completion:nil];
        return;
    }

    if ([TFY_CacheFileManager shareManager].showDoucumentUI) {
        if ([filePath hasSuffix:@"apk"]) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"无法打开apk文件" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [alertController addAction:cancelAction];
            [target presentViewController:alertController animated:YES completion:NULL];
        } else {
            [self fileDocumentReadWithFilePath:filePath target:target];
        }
    } else {
        TFY_CacheFileType type = [[TFY_CacheFileManager shareManager] fileTypeReadWithFilePath:filePath];
        if (TFY_CacheFileTypeAudio == type) {
            [self fileAudioReadWithFilePath:filePath target:target];
        } else if (TFY_CacheFileTypeVideo == type) {
            [self fileVidioReadWithFilePath:filePath target:target];
        } else if (TFY_CacheFileTypeImage == type) {
            if ([filePath hasSuffix:@"gif"]) {
                [self fileDocumentReadWithFilePath:filePath target:target];
            } else {
                [self fileImageReadWithFilePath:filePath target:target];
            }
        } else {
            if ([filePath hasSuffix:@"apk"]) {
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"无法打开apk文件" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    
                }];
                [alertController addAction:cancelAction];
                [target presentViewController:alertController animated:YES completion:NULL];
            } else {
                [self fileDocumentReadWithFilePath:filePath target:target];
            }
        }
    }
}

#pragma mark - 音频播放

- (void)fileAudioReadWithFilePath:(NSString *)filePath target:(id)target
{
    if (filePath && target) {
        [[TFY_CacheFileAudio shareAudio] playAudioWithFilePath:filePath];
    }
}

#pragma mark - 视频播放

/// 播放视频（网络地址，或本地路径，或本地文件名称）
- (void)fileVidioReadWithFilePath:(NSString *)filePath target:(id)target
{
    if (filePath && target) {
        [[TFY_CacheFileAudio shareAudio] stopAudio];
        TFY_CacheFileVideo *videoPlayer = [[TFY_CacheFileVideo alloc] init];
        [videoPlayer playVideoWithFilePath:filePath target:target];
    }
}

#pragma mark - 图片播放

CGFloat scaleMini = 1.0;
CGFloat scaleMax = 3.0;

- (void)fileImageReadWithFilePath:(NSString *)filePath target:(id)target
{
    if (filePath && target) {
        [[TFY_CacheFileAudio shareAudio] stopAudio];
        
        self.controller = target;
        
        NSArray *images = @[filePath];
        if ([TFY_CacheFileManager shareManager].showImageShuffling) {
            NSString *file = filePath.stringByDeletingLastPathComponent;
            images = [TFY_CacheFileManager imagefilesWithFilePath:file];
        }
        if (self.fileImage == nil) {
            self.fileImage = [[TFY_CacheFileImage alloc] init];
        }
        NSInteger index = 0;
        if ([TFY_CacheFileManager shareManager].nameImage) {
            index = [images indexOfObject:[TFY_CacheFileManager shareManager].nameImage];
        }
        self.fileImage.index = index;
        self.fileImage.images = images;
        [self.fileImage reloadImages];
    }
}

#pragma mark - 文件阅读

- (void)fileDocumentReadWithFilePath:(NSString *)filePath target:(id)target
{
    if (filePath && target) {
        [[TFY_CacheFileAudio shareAudio] stopAudio];
        
        NSURL *url = [NSURL fileURLWithPath:filePath];
        self.controller = target;
        if (self.documentController == nil) {
            self.documentController = [UIDocumentInteractionController interactionControllerWithURL:url];
            self.documentController.delegate = self;
            [self.documentController presentPreviewAnimated:YES];
        }
    }
}

#pragma mark UIDocumentInteractionController

- (UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)controller
{
    return self.controller;
}

- (UIView *)documentInteractionControllerViewForPreview:(UIDocumentInteractionController *)controller
{
    return self.controller.view;
}

- (CGRect)documentInteractionControllerRectForPreview:(UIDocumentInteractionController *)controller
{
    return self.controller.view.bounds;
}

// 点击预览窗口的“Done”(完成)按钮时调用
- (void)documentInteractionControllerDidEndPreview:(UIDocumentInteractionController *)controller
{
    self.documentController = nil;
}

@end
