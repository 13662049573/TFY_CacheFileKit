//
//  TFY_CacheFileTable.m
//  TFY_CacheFileKit
//
//  Created by 田风有 on 2020/9/25.
//

#import "TFY_CacheFileTable.h"
#import "TFY_CacheFileCell.h"
#import "TFY_CacheFileManager.h"
#import "TFY_CacheFileModel.h"
#import "TFY_CacheFileUilt.h"

@interface TFY_CacheFileTable ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) NSIndexPath *previousIndex;
@end

@implementation TFY_CacheFileTable

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self registerClass:[TFY_CacheFileCell class] forCellReuseIdentifier:reuseCacheDirectoryCell];
        
        self.delegate = self;
        self.dataSource = self;
        
        self.tableFooterView = [UIView new];
    }
    return self;
}

#pragma mark - UITableViewDataSource, UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.cacheDatas.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return heightCacheDirectoryCell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TFY_CacheFileCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseCacheDirectoryCell];
    // 数据
    TFY_CacheFileModel *model = self.cacheDatas[indexPath.row];
    cell.model = model;
    // 长按
    TFY_CacheFileTable __weak *weakSelf = self;
    cell.longPress = ^{
        if (weakSelf.longPress) {
            weakSelf.longPress(weakSelf, indexPath);
        }
    };
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    TFY_CacheFileModel *model = self.cacheDatas[indexPath.row];
    
    // 音频播放
    TFY_CacheFileType type = [[TFY_CacheFileManager shareManager] fileTypeReadWithFilePath:model.filePath];
    if (TFY_CacheFileTypeAudio == type) {
        model.fileProgressShow = YES;
        NSString *currentPath = model.filePath;
        
        if (self.previousIndex) {
            TFY_CacheFileModel *previousModel = self.cacheDatas[self.previousIndex.row];
            NSString *previousPath = previousModel.filePath;
            if (![currentPath isEqualToString:previousPath]) {
                previousModel.fileProgress = 0.0;
                previousModel.fileProgressShow = NO;
                [tableView reloadRowsAtIndexPaths:@[self.previousIndex] withRowAnimation:UITableViewRowAnimationNone];
            }
        }
        self.previousIndex = indexPath;
    }

    // 回调响应
    if (self.itemClick) {
        self.itemClick(indexPath);
    }
}

#pragma mark 编辑

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self deleItemAtIndex:indexPath];
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

#pragma mark - 删除操作

- (void)deleItemAtIndex:(NSIndexPath *)indexPath
{
    if (indexPath.row > self.cacheDatas.count - 1) {
        return;
    }
    TFY_CacheFileModel *model = self.cacheDatas[indexPath.row];
    // 系统数据不可删除
    if ([[TFY_CacheFileManager shareManager] isFileSystemWithFilePath:model.filePath]) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"系统文件不能删除" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {}]];
        [[TFY_CacheFileUilt presentMenuView] presentViewController:alertController animated:YES completion:nil];
        return;
    }
    // 当前删除的是音频时，先停止播放
    if (model.fileType == TFY_CacheFileTypeAudio) {
        [[NSNotificationCenter defaultCenter] postNotificationName:TFY_CacheFileAudioDeleteNotificationName object:nil];
    }
    if (self.previousIndex) {
        self.previousIndex = nil;
    }
    // 删除数据：删除数组、删除本地文件/文件夹、刷新页面、发通知刷新文件大小统计
    // 删除数组
    [self.cacheDatas removeObjectAtIndex:indexPath.row];
    // 删除本地文件/文件夹
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        BOOL isDelete = [TFY_CacheFileManager deleteFileWithDirectory:model.filePath];
        NSLog(@"删除：%@", (isDelete ? @"成功" : @"失败"));
    });
    [self reloadData];
}


@end
