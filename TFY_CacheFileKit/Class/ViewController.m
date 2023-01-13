//
//  ViewController.m
//  TFY_CacheFileKit
//
//  Created by 田风有 on 2020/9/25.
//

#import "ViewController.h"
#import "TFY_CacheFileKit.h"
#import "ThecustomController.h"
#import "NAVViewController.h"
@interface ViewController ()<UIDocumentInteractionControllerDelegate>
@property(nonatomic , strong)UIDocumentInteractionController *documentController;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"缓存目录";
    
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithTitle:@"浏览" style:UIBarButtonItemStyleDone target:self action:@selector(preview)];
    
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithTitle:@"分享文件" style:UIBarButtonItemStyleDone target:self action:@selector(shareFile:)];
    
    self.navigationItem.leftBarButtonItems = @[item2,item1];
    
    
    UIBarButtonItem *item3 = [[UIBarButtonItem alloc] initWithTitle:@"自定义" style:UIBarButtonItemStyleDone target:self action:@selector(ThecustomClick)];
    
    UIBarButtonItem *item4 = [[UIBarButtonItem alloc] initWithTitle:@"缓存" style:UIBarButtonItemStyleDone target:self action:@selector(buttonClick)];
    
    UIBarButtonItem *item5 = [[UIBarButtonItem alloc] initWithTitle:@"获取" style:UIBarButtonItemStyleDone target:self action:@selector(acquirebuttonClick)];

    self.navigationItem.rightBarButtonItems = @[item3,item4,item5];
    
}

//预览文件(注册应用程序支持的文件类型)
- (void)preview {
    NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"4.xlsx" ofType:nil]];
    NSURL *url2 = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"说明书-青蛙头.pdf" ofType:nil]];
    NSURL *url3 = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"无我资料.zip" ofType:nil]];
    NSURL *url4 = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"女性备孕体温计协议调试命令.txt" ofType:nil]];
    NSURL *url5 = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"绿萌营业执照.PDF" ofType:nil]];
    TFY_FilePreviewController *pre = TFY_FilePreviewController.new;
    pre.filePathArr = @[url,url2,url3,url4,url5];
    [self.navigationController pushViewController:pre animated:YES];
}

//分享文件
- (void)shareFile:(UIBarButtonItem *)barBtn {
    NSURL *url4 = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"女性备孕体温计协议调试命令.txt" ofType:nil]];
    [[TFY_DocumentPicker sharedOpen] openFileWithFilePath:url4 andItem:barBtn andNavTitleName:@"浏览" Document:TFY_DocumentOptionsMenu];
}

- (void)acquirebuttonClick {
    [[TFY_DocumentPicker sharedOpen] acquireDocument:TFY_DocumentModeOpen Block:^(NSString * _Nonnull fileName, NSString * _Nonnull filePath) {
        NSLog(@"===========:%@========:%@",fileName,filePath);
    }];
}

//自定义界面
- (void)ThecustomClick {
    NSURL *url2 = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"说明书-青蛙头.pdf" ofType:nil]];
    ThecustomController *vc = ThecustomController.new;
    vc.urlPath = url2;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)buttonClick {
    // 默认
    TFY_CacheFileViewController *cacheVC = [[TFY_CacheFileViewController alloc] init];
    [TFY_CacheFileManager shareManager].showImageShuffling = YES;
    cacheVC.showType = 1;
    [self.navigationController pushViewController:cacheVC animated:YES];

    NSString *path = [TFY_CacheFileManager homeDirectoryPath];
    NSLog(@"path = %@", path);

//    // 自定义
//    TFY_CacheFileViewController *cacheVC = [[TFY_CacheFileViewController alloc] init];
//    // 指定文件格式
//    [TFY_CacheFileManager shareManager].cacheDocumentTypes = @[@".pages", @"wps", @".xls", @".pdf", @".rar"];
//    [TFY_CacheFileManager shareManager].showDoucumentUI = YES;
//    // 指定目录，或默认目录
//    NSString *pathDocument = [TFY_CacheFileManager documentDirectoryPath];
//    NSArray *arrayDocument = [[TFY_CacheFileManager shareManager] fileModelsWithFilePath:pathDocument];
//    NSString *pathCache = [TFY_CacheFileManager cacheDirectoryPath];
//    NSArray *arrayCache = [[TFY_CacheFileManager shareManager] fileModelsWithFilePath:pathCache];
//    NSMutableArray *array = [NSMutableArray arrayWithArray:arrayDocument];
//    [array addObjectsFromArray:arrayCache];
//    cacheVC.cacheArray = array;
//    // 其它属性设置
//    cacheVC.cacheTitle = @"我的缓存文件";
//    //
//    [self.navigationController pushViewController:cacheVC animated:YES];
//    NSString *path = [TFY_CacheFileManager homeDirectoryPath];
//    NSLog(@"path = %@", path);
//
//    path = [TFY_CacheFileManager documentDirectoryPath];
//    NSLog(@"path = %@", path);
//
//    path = [TFY_CacheFileManager cacheDirectoryPath];
//    NSLog(@"path = %@", path);
//
//    path = [TFY_CacheFileManager libraryDirectoryPath];
//    NSLog(@"path = %@", path);
//
//    path = [TFY_CacheFileManager tmpDirectoryPath];
//    NSLog(@"path = %@", path);
//
//    path = [TFY_CacheFileManager newFilePathWithPath:[TFY_CacheFileManager tmpDirectoryPath] name:@"Tmp001"];
//    NSLog(@"path = %@", path);
//
//    path = [TFY_CacheFileManager newFilePathCacheWithName:@"Tmp002"];
//    NSLog(@"path = %@", path);
//
//    path = [TFY_CacheFileManager newFilePathDocumentWithName:@"Document001"];
//    NSLog(@"path = %@", path);
//
//    path = [TFY_CacheFileManager newFilePathWithPath:[TFY_CacheFileManager tmpDirectoryPath] name:@"绿萌健康软著.jpeg"];
//    NSLog(@"path = %@", path);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    //本地沙盒文件路径
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"说明书-青蛙头.pdf" ofType:nil];
    //创建webView
    WKWebView *webV = [[WKWebView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:webV];
    
    //设置request
    NSURL *fileUrl = [NSURL fileURLWithPath:filePath];
    NSURLRequest *request = [NSURLRequest requestWithURL:fileUrl];
    
    //加载request
    [webV loadRequest:request];
}

- (void)buttonClick222 {
    [self.navigationController pushViewController:NAVViewController.new animated:YES];
}

@end
