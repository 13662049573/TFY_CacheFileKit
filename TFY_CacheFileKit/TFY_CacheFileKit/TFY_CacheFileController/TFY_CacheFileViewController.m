//
//  TFY_CacheFileViewController.m
//  TFY_CacheFileKit
//
//  Created by 田风有 on 2020/9/25.
//

#import "TFY_CacheFileViewController.h"
#import "TFY_CacheFileTable.h"
#import "TFY_CacheFileCollection.h"
#import "TFY_CacheFileManager.h"
#import "TFY_CacheFileModel.h"
#import "TFY_CacheFileImage.h"
#import "TFY_CacheFileRead.h"

@interface TFY_CacheFileViewController ()
@property (nonatomic, strong) TFY_CacheFileTable *cacheTable;
@property (nonatomic, strong) TFY_CacheFileCollection *cacheCollection;

@property (nonatomic, strong) TFY_CacheFileRead *fileRead;
@end

@implementation TFY_CacheFileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    
    self.navigationItem.title = (_cacheTitle ? _cacheTitle : TFY_CacheFileTitle);
    
    [self setUI];
    [self loadData];
}

- (void)loadView
{
    [super loadView];
    self.view.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.1];
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
}

- (void)dealloc
{
    NSLog(@"<--- %@ 被释放了 --->", [self class]);
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[TFY_CacheFileAudio shareAudio] stopAudio];
    if (self.fileRead) {
        [self.fileRead releaseSYCacheFileRead];
    }
}

#pragma mark - 视图

- (void)setUI
{
    if (self.showType == 0) {
        self.cacheTable.hidden = NO;
        self.cacheCollection.hidden = YES;
    } else if (self.showType == 1) {
        self.cacheTable.hidden = YES;
        self.cacheCollection.hidden = NO;
    }
}

#pragma mark - 视频图片保存

- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    NSString *message = @"保存视频到相册成功";
    if (error) {
        message = @"保存视频到相册失败";
    }
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:NULL];
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    NSString *message = @"保存图片到相册成功";
    if (error) {
        message = @"保存图片到相册失败";
    }
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:NULL];
}

#pragma mark - 响应

#pragma mark - 数据

- (void)loadData
{
    if (self.cacheArray == nil) {
        // 初始化，首次显示总目录
        NSString *path = [TFY_CacheFileManager homeDirectoryPath];
        NSArray *array = [[TFY_CacheFileManager shareManager] fileModelsWithFilePath:path];
        self.cacheArray = [NSMutableArray arrayWithArray:array];
    }
    
    if (self.cacheArray && 0 < self.cacheArray.count) {
//        self.cacheTable.cacheDatas = self.cacheArray;
//        [self.cacheTable reloadData];
        if (self.showType == 0) {
            self.cacheTable.cacheDatas = self.cacheArray;
            [self.cacheTable reloadData];
        } else if (self.showType == 1) {
            self.cacheCollection.cacheDatas = self.cacheArray;
            [self.cacheCollection reloadData];
        }
    }
}

#pragma mark - getter

- (TFY_CacheFileTable *)cacheTable
{
    if (_cacheTable == nil) {
        _cacheTable = [[TFY_CacheFileTable alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _cacheTable.backgroundColor = [UIColor clearColor];
        _cacheTable.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        
        [self.view addSubview:_cacheTable];
        typeof(self) __weak weakSelf = self;
        // 点击
        _cacheTable.itemClick = ^(NSIndexPath *indexPath) {
            
            if (weakSelf.cacheTable.isEditing) {
                return ;
            }
            
            if (indexPath.row > weakSelf.cacheArray.count - 1) {
                return;
            }
            TFY_CacheFileModel *model = weakSelf.cacheArray[indexPath.row];
            NSString *path = model.filePath; // 路径
            TFY_CacheFileType type = model.fileType; // 类型
            if (TFY_CacheFileTypeUnknow == type) {
                // 标题
                NSString *title = model.fileName;
                // 子目录文件
                NSArray *files = [[TFY_CacheFileManager shareManager] fileModelsWithFilePath:path];
                TFY_CacheFileViewController *cacheVC = [TFY_CacheFileViewController new];
                cacheVC.cacheTitle = title;
                cacheVC.showType = weakSelf.showType;
                cacheVC.cacheArray = (NSMutableArray *)files;
                [weakSelf.navigationController pushViewController:cacheVC animated:YES];
            } else {
                if (type == TFY_CacheFileTypeImage) {
                    [TFY_CacheFileManager shareManager].nameImage = model.filePath;
                }
                [weakSelf.fileRead fileReadWithFilePath:path target:weakSelf];
            }
        };
        // 长按
        _cacheTable.longPress = ^(TFY_CacheFileTable *tableView, NSIndexPath *indexPath) {
            if (indexPath.row > weakSelf.cacheArray.count - 1) {
                return;
            }
            //
            TFY_CacheFileModel *model = weakSelf.cacheArray[indexPath.row];
            TFY_CacheFileType type = model.fileType;
            //
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:NULL];
            [alertController addAction:cancelAction];
            if (type == TFY_CacheFileTypeVideo || type == TFY_CacheFileTypeImage) {
                UIAlertAction *cacheAction = [UIAlertAction actionWithTitle:@"保存到相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    if (type == TFY_CacheFileTypeVideo) {
                        UISaveVideoAtPathToSavedPhotosAlbum(model.filePath, weakSelf, @selector(video:didFinishSavingWithError: contextInfo:), nil);
                    } else if (type == TFY_CacheFileTypeImage) {
                        UIImage *image = [UIImage imageWithContentsOfFile:model.filePath];
                        UIImageWriteToSavedPhotosAlbum(image, weakSelf, @selector(image:didFinishSavingWithError:contextInfo:), nil);
                    }
                }];
                [alertController addAction:cacheAction];
            }
            UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [tableView deleItemAtIndex:indexPath];
            }];
            [alertController addAction:deleteAction];
            [weakSelf presentViewController:alertController animated:YES completion:NULL];
        };
    }
    return _cacheTable;
}

- (TFY_CacheFileCollection *)cacheCollection
{
    if (_cacheCollection == nil) {
        UICollectionViewLayout *layout = TFY_CacheFileCollection.collectionlayout;
        _cacheCollection = [[TFY_CacheFileCollection alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
        _cacheCollection.backgroundColor = [UIColor clearColor];
        _cacheCollection.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        
        [self.view addSubview:_cacheCollection];
        typeof(self) __weak weakSelf = self;
        // 点击
        _cacheCollection.itemClick = ^(NSIndexPath *indexPath) {
            
            if (weakSelf.cacheTable.isEditing) {
                return ;
            }
            
            if (indexPath.row > weakSelf.cacheArray.count - 1) {
                return;
            }
            TFY_CacheFileModel *model = weakSelf.cacheArray[indexPath.row];
            NSString *path = model.filePath; // 路径
            TFY_CacheFileType type = model.fileType; // 类型
            if (TFY_CacheFileTypeUnknow == type) {
                // 标题
                NSString *title = model.fileName;
                // 子目录文件
                NSArray *files = [[TFY_CacheFileManager shareManager] fileModelsWithFilePath:path];
                TFY_CacheFileViewController *cacheVC = [TFY_CacheFileViewController new];
                cacheVC.cacheTitle = title;
                cacheVC.showType = weakSelf.showType;
                cacheVC.cacheArray = (NSMutableArray *)files;
                [weakSelf.navigationController pushViewController:cacheVC animated:YES];
            } else {
                if (type == TFY_CacheFileTypeImage) {
                    [TFY_CacheFileManager shareManager].nameImage = model.filePath;
                }
                [weakSelf.fileRead fileReadWithFilePath:path target:weakSelf];
            }
        };
        // 长按
        _cacheCollection.longPress = ^(TFY_CacheFileCollection *collection, NSIndexPath *indexPath) {
            if (indexPath.row > weakSelf.cacheArray.count - 1) {
                return;
            }
            //
            TFY_CacheFileModel *model = weakSelf.cacheArray[indexPath.row];
            TFY_CacheFileType type = model.fileType;
            //
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:NULL];
            [alertController addAction:cancelAction];
            if (type == TFY_CacheFileTypeVideo || type == TFY_CacheFileTypeImage) {
                UIAlertAction *cacheAction = [UIAlertAction actionWithTitle:@"保存到相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    if (type == TFY_CacheFileTypeVideo) {
                        UISaveVideoAtPathToSavedPhotosAlbum(model.filePath, weakSelf, @selector(video:didFinishSavingWithError: contextInfo:), nil);
                    } else if (type == TFY_CacheFileTypeImage) {
                        UIImage *image = [UIImage imageWithContentsOfFile:model.filePath];
                        UIImageWriteToSavedPhotosAlbum(image, weakSelf, @selector(image:didFinishSavingWithError:contextInfo:), nil);
                    }
                }];
                [alertController addAction:cacheAction];
            }
            UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [collection deleItemAtIndex:indexPath];
            }];
            [alertController addAction:deleteAction];
            [weakSelf presentViewController:alertController animated:YES completion:NULL];
        };
    }
    return _cacheCollection;
}

- (TFY_CacheFileRead *)fileRead
{
    if (_fileRead == nil) {
        _fileRead = [[TFY_CacheFileRead alloc] init];
    }
    return _fileRead;
}

@end
