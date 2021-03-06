//
//  TFY_FilePreviewController.m
//  TFY_CacheFileKit
//
//  Created by 田风有 on 2020/9/25.
//

#import "TFY_FilePreviewController.h"
#import "TFY_PreviewCustomItem.h"

@interface TFY_FilePreviewController ()<QLPreviewControllerDataSource, QLPreviewControllerDelegate>
@property (nonatomic, copy) void(^willDismissBlock)(void);
@property (nonatomic, copy) void(^didDismissBlock)(void);
@property (nonatomic, copy) BOOL(^shouldOpenUrlBlock)(NSURL *url, id <QLPreviewItem>item);
@property (nonatomic, strong) NSMutableArray *fileUrlList;
@end

@implementation TFY_FilePreviewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
    self.dataSource = self;
    [self setNavgationBarAndTabBar];//设置导航栏
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

#pragma mark - private methods
- (void)jumpWith:(TFY_JumpMode)jump on:(UIViewController *)vc{
    switch (jump) {
        case TFY_JumpPush:
        case TFY_JumpPushAnimat:
            [vc.navigationController pushViewController:self animated:(jump == TFY_JumpPushAnimat)];
            break;
        case TFY_JumpPresent:
        case TFY_JumpPresentAnimat:
            [vc presentViewController:self animated:(jump == TFY_JumpPresentAnimat) completion:nil];
            break;
    }
    [self reloadData];
}

#pragma mark - public methods
- (void)previewFileWithPaths:(NSArray <NSURL *>*)filePathArr  on:(UIViewController *)vc jump:(TFY_JumpMode)jump{
    [self jumpWith:jump on:vc];
    for (NSURL *urlPath in filePathArr) {
        if ([TFY_FilePreviewController canPreviewItem:urlPath]) {
            [self.fileUrlList addObject:urlPath];
        }
    }
    [self reloadData];
}

//单文件预览
- (void)previewFileloadUrlPath:(NSURL *)fileUrl on:(UIViewController *)vc jump:(TFY_JumpMode)jump {
    [self jumpWith:jump on:vc];
    if ([TFY_FilePreviewController canPreviewItem:fileUrl]) {
        [self.fileUrlList addObject:fileUrl];
    }
    [self reloadData];
}

//加载数据 同时设置当前预览的文件  多文件
- (void)loadUrlPathList:(NSArray<NSURL *> *)urlPathList andCurrentPreVItemIndex:(NSInteger)index {
    for (NSURL *urlPath in urlPathList) {
        if ([TFY_FilePreviewController canPreviewItem:urlPath]) {
            [self.fileUrlList addObject:urlPath];
        }
    }
    self.currentPreviewItemIndex = index;
    [self reloadData];
}
//单文件
- (void)loadUrlPath:(NSURL *)fileUrl {
    if ([TFY_FilePreviewController canPreviewItem:fileUrl]) {
        [self.fileUrlList addObject:fileUrl];
    }
    [self reloadData];
}

#pragma mark - QLPreviewControllerDataSource

- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)controller{
    return self.fileUrlList.count;
}

- (id <QLPreviewItem>)previewController:(QLPreviewController *)controller previewItemAtIndex:(NSInteger)index{
    if (self.previewItemTitle != nil) {
        TFY_PreviewCustomItem *item = TFY_PreviewCustomItem.new;
        item.previewItemTitle = self.previewItemTitle;
        item.previewItemURL = self.fileUrlList[index];
        return item;
    } else {
        return  self.fileUrlList[index];
    }
}

#pragma mark - QLPreviewControllerDelegate
- (void)previewControllerWillDismiss:(QLPreviewController *)controller{
    !self.willDismissBlock?:self.willDismissBlock();
}

- (void)previewControllerDidDismiss:(QLPreviewController *)controller{
    !self.didDismissBlock?:self.didDismissBlock();
}

- (BOOL)previewController:(QLPreviewController *)controller shouldOpenURL:(NSURL *)url forPreviewItem:(id <QLPreviewItem>)item{
    return !self.shouldOpenUrlBlock?YES:self.shouldOpenUrlBlock(url, item);
}

#pragma mark - getters and setters
- (void)setWillDismissBlock:(void (^)(void))willDismissBlock{
    if(!willDismissBlock) return;
    _willDismissBlock = [willDismissBlock copy];
}

- (void)setDidDismissBlock:(void (^)(void))didDismissBlock{
    if(!didDismissBlock) return;
    _didDismissBlock = [didDismissBlock copy];
}

- (void)setShouldOpenUrlBlock:(BOOL (^)(NSURL *, id<QLPreviewItem>))shouldOpenUrlBlock{
    if(!shouldOpenUrlBlock) return;
    _shouldOpenUrlBlock = [shouldOpenUrlBlock copy];
}

- (NSMutableArray *)fileUrlList {
    if (!_fileUrlList) {
        _fileUrlList = [NSMutableArray array];
    }
    return _fileUrlList;
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
@end
