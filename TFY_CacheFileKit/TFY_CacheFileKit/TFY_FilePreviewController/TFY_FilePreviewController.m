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

- (void)setFilePathArr:(NSArray<NSURL *> *)filePathArr {
    _filePathArr = filePathArr;
    for (NSURL *urlPath in filePathArr) {
        if ([TFY_FilePreviewController canPreviewItem:urlPath]) {
            [self.fileUrlList addObject:urlPath];
        }
    }
    [self reloadData];
}

- (void)setFileUrl:(NSURL *)fileUrl {
    _fileUrl = fileUrl;
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
