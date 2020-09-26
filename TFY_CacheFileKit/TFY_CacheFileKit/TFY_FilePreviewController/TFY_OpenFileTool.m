//
//  TFY_OpenFileTool.m
//  TFY_CacheFileKit
//
//  Created by 田风有 on 2020/9/26.
//

#import "TFY_OpenFileTool.h"
#import <QuickLook/QuickLook.h>

@interface TFY_OpenFileTool ()<UIDocumentInteractionControllerDelegate>
@property (nonatomic, strong) UIDocumentInteractionController *documentIntController;
@property (nonatomic, weak) UIViewController *viewController;
@end

@implementation TFY_OpenFileTool
static TFY_OpenFileTool *_openFileTool;

+ (instancetype)sharedOpenfileTool {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _openFileTool = [[self alloc]init];
        [_openFileTool setNavgationBarAndTabBar];
    });
    return _openFileTool;
}

/*
 * parameter  本地文件路径
 * parameter  显示所在控制器
 * parameter  预览导航栏的标题
 */
- (void)openFileWithFilePath:(NSString *)filePath andVC:(UIViewController *)viewController andNavTitleName:(NSString *)name Document:(TFY_DocumentMode)document{
    self.viewController = viewController;
    self.documentIntController = [UIDocumentInteractionController interactionControllerWithURL:[NSURL fileURLWithPath:filePath]];
    self.documentIntController.name = name;
    self.documentIntController.delegate = self;
    switch (document) {
        case TFY_Document:{
            [self.documentIntController presentPreviewAnimated:YES];//直接预览  然后在预览中选择是否使用其他软件打开
        }break;
        case TFY_DocumentOpenInMenu:{
            [self.documentIntController presentOpenInMenuFromRect:viewController.view.bounds inView:viewController.view animated:YES];//显示提示框 但是第三行不能选择预览
        }break;
        case TFY_DocumentOptionsMenu:{
            [self.documentIntController presentOptionsMenuFromRect:viewController.view.bounds inView:viewController.view animated:YES];//显示提示框 再选择是否开启预览
        }break;
    }
}

/*
 * parameter  本地文件路径
 * parameter  点击的导航栏BarButtonItem
 * parameter  显示所在控制器
 * parameter  预览导航栏的标题
 */
- (void)openFileWithFilePath:(NSString *)filePath andItem:(UIBarButtonItem *)barButtonItem andNavTitleName:(NSString *)name andVC:(UIViewController *)viewController Document:(TFY_DocumentMode)document {
    self.viewController = viewController;
    self.documentIntController = [UIDocumentInteractionController interactionControllerWithURL:[NSURL fileURLWithPath:filePath]];
    self.documentIntController.name = name;
    self.documentIntController.delegate = self;
    switch (document) {
        case TFY_Document:{
            [self.documentIntController presentPreviewAnimated:YES];//直接预览  然后在预览中选择是否使用其他软件打开
        }break;
        case TFY_DocumentOpenInMenu:{
            [self.documentIntController presentOpenInMenuFromBarButtonItem:barButtonItem animated:YES];//显示提示框 但是第三行不能选择预览
        }break;
        case TFY_DocumentOptionsMenu:{
            [self.documentIntController presentOptionsMenuFromBarButtonItem:barButtonItem animated:YES];//显示提示框 再选择是否开启预览
        }break;
    }
}

#pragma mark -- 设置导航栏和底部标签栏
- (void)setNavgationBarAndTabBar {
    //获取导航栏
    UINavigationBar *navBar = [UINavigationBar appearanceWhenContainedInInstancesOfClasses:@[QLPreviewController.class]];//局部设置
    [navBar setBarTintColor:UIColor.whiteColor];//导航栏颜色
    [navBar setTintColor:UIColor.blackColor];//按钮颜色
    [navBar setTitleTextAttributes:@{NSForegroundColorAttributeName : UIColor.blackColor}];//标题颜色
    [navBar setBackgroundImage:[self imageWithColor:UIColor.whiteColor size:CGSizeMake(1, 1)] forBarMetrics:UIBarMetricsDefault];

    //获取标签栏
    UIToolbar *toolBar = [UIToolbar appearanceWhenContainedInInstancesOfClasses:@[QLPreviewController.class]];
    [toolBar setBackgroundImage:[self imageWithColor:UIColor.whiteColor size:CGSizeMake(1, 1)] forToolbarPosition:UIBarPositionBottom barMetrics:UIBarMetricsDefault];
    [toolBar setTintColor:UIColor.blackColor];
    
}

- (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size{
    if (!color || size.width <= 0 || size.height <= 0) return nil;
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

#pragma mark -- UIDocumentInteractionControllerDelegate
//返回的控制器  指明预览将在那个控制器上进行 不进行设置 无法进行预览
- (UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)controller {
    return self.viewController;
}

@end
