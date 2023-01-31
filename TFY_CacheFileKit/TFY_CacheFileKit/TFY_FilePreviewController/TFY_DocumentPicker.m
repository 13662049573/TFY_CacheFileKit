//
//  TFY_DocumentPicker.m
//  TFY_CacheFileKit
//
//  Created by 田风有 on 2023/1/13.
//

#import "TFY_DocumentPicker.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <QuickLook/QuickLook.h>
#import "TFY_CacheFileUilt.h"

@interface TFY_DocumentPicker ()<UIDocumentPickerDelegate,UIDocumentInteractionControllerDelegate>
@property(nonatomic , copy)NSArray *dataArr;
@property (nonatomic , copy, nullable) void (^document_Block)(NSString *fileName,NSString *filePath);
@end

@implementation TFY_DocumentPicker
static TFY_DocumentPicker *_openFileTool;

+ (instancetype)sharedOpen {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _openFileTool = [[self alloc]init];
        [_openFileTool setNavgationBarAndTabBar];
    });
    return _openFileTool;
}

- (instancetype)init {
    if (self =[super init]) {
        self.dataArr = @[@"public.text",
                         @"com.apple.iwork.pages.pages",
                         @"public.data",
                         @"kUTTypeItem",
                         @"kUTTypeContent",
                         @"kUTTypeCompositeContent",
                         @"kUTTypeData",
                         @"public.database",
                         @"public.calendar-event",
                         @"public.message",
                         @"public.presentation",
                         @"public.contact",
                         @"public.archive",
                         @"public.disk-image",
                         @"public.plain-text",
                         @"public.utf8-plain-text",
                         @"public.utf16-external-plain-​text",
                         @"public.utf16-plain-text",
                         @"com.apple.traditional-mac-​plain-text",
                         @"public.rtf",
                         @"com.apple.ink.inktext",
                         @"public.html",
                         @"public.xml",
                         @"public.source-code",
                         @"public.c-source",
                         @"public.objective-c-source",
                         @"public.c-plus-plus-source",
                         @"public.objective-c-plus-​plus-source",
                         @"public.c-header",
                         @"public.c-plus-plus-header",
                         @"com.sun.java-source",
                         @"public.script",
                         @"public.assembly-source",
                         @"com.apple.rez-source",
                         @"public.mig-source",
                         @"com.apple.symbol-export",
                         @"com.netscape.javascript-​source",
                         @"public.shell-script",
                         @"public.csh-script",
                         @"public.perl-script",
                         @"public.python-script",
                         @"public.ruby-script",
                         @"public.php-script",
                         @"com.sun.java-web-start",
                         @"com.apple.applescript.text",
                         @"com.apple.applescript.​script",
                         @"public.object-code",
                         @"com.apple.mach-o-binary",
                         @"com.apple.pef-binary",
                         @"com.microsoft.windows-​executable",
                         @"com.microsoft.windows-​dynamic-link-library",
                         @"com.sun.java-class",
                         @"com.sun.java-archive",
                         @"com.apple.quartz-​composer-composition",
                         @"org.gnu.gnu-tar-archive",
                         @"public.tar-archive",
                         @"org.gnu.gnu-zip-archive",
                         @"org.gnu.gnu-zip-tar-archive",
                         @"com.apple.binhex-archive",
                         @"com.apple.macbinary-​archive",
                         @"public.url",
                         @"public.file-url",
                         @"public.url-name",
                         @"public.vcard",
                         @"public.image",
                         @"public.fax",
                         @"public.jpeg",
                         @"public.jpeg-2000",
                         @"public.tiff",
                         @"public.camera-raw-image",
                         @"com.apple.pict",
                         @"com.apple.macpaint-image",
                         @"public.png",
                         @"public.xbitmap-image",
                         @"com.apple.quicktime-image",
                         @"com.apple.icns",
                         @"com.apple.txn.text-​multimedia-data",
                         @"public.audiovisual-​content",
                         @"public.movie",
                         @"public.video",
                         @"com.apple.quicktime-movie",
                         @"public.avi",
                         @"public.mpeg",
                         @"public.mpeg-4",
                         @"public.3gpp",
                         @"public.3gpp2",
                         @"public.audio",
                         @"public.mp3",
                         @"public.mpeg-4-audio",
                         @"com.apple.protected-​mpeg-4-audio",
                         @"public.ulaw-audio",
                         @"public.aifc-audio",
                         @"public.aiff-audio",
                         @"com.apple.coreaudio-​format",
                         @"public.directory",
                         @"public.folder",
                         @"public.volume",
                         @"com.apple.package",
                         @"com.apple.bundle",
                         @"public.executable",
                         @"com.apple.application",
                         @"com.apple.application-​bundle",
                         @"com.apple.application-file",
                         @"com.apple.deprecated-​application-file",
                         @"com.apple.plugin",
                         @"com.apple.metadata-​importer",
                         @"com.apple.dashboard-​widget",
                         @"public.cpio-archive",
                         @"com.pkware.zip-archive",
                         @"com.apple.webarchive",
                         @"com.apple.framework",
                         @"com.apple.rtfd",
                         @"com.apple.flat-rtfd",
                         @"com.apple.resolvable",
                         @"public.symlink",
                         @"com.apple.mount-point",
                         @"com.apple.alias-record",
                         @"com.apple.alias-file",
                         @"public.font",
                         @"public.truetype-font",
                         @"com.adobe.postscript-font",
                         @"com.apple.truetype-​datafork-suitcase-font",
                         @"public.opentype-font",
                         @"public.truetype-ttf-font",
                         @"public.truetype-collection-​font",
                         @"com.apple.font-suitcase",
                         @"com.adobe.postscript-lwfn​-font",
                         @"com.adobe.postscript-pfb-​font",
                         @"com.adobe.postscript.pfa-​font",
                         @"com.apple.colorsync-profile",
                         @"public.filename-extension",
                         @"public.mime-type",
                         @"com.apple.ostype",
                         @"com.apple.nspboard-type",
                         @"com.adobe.pdf",
                         @"com.adobe.postscript",
                         @"com.adobe.encapsulated-​postscript",
                         @"com.adobe.photoshop-​image",
                         @"com.adobe.illustrator.ai-​image",
                         @"com.compuserve.gif",
                         @"com.microsoft.bmp",
                         @"com.microsoft.ico",
                         @"com.microsoft.word.doc",
                         @"com.microsoft.excel.xls",
                         @"com.microsoft.powerpoint.​ppt",
                         @"com.microsoft.waveform-​audio",
                         @"com.microsoft.advanced-​systems-format",
                         @"com.microsoft.windows-​media-wm",
                         @"com.microsoft.windows-​media-wmv",
                         @"com.microsoft.windows-​media-wmp",
                         @"com.microsoft.windows-​media-wma",
                         @"com.microsoft.advanced-​stream-redirector",
                         @"com.microsoft.windows-​media-wmx",
                         @"com.microsoft.windows-​media-wvx",
                         @"com.microsoft.windows-​media-wax",
                         @"com.apple.keynote.key",
                         @"com.apple.keynote.kth",
                         @"com.truevision.tga-image",
                         @"com.sgi.sgi-image",
                         @"com.ilm.openexr-image",
                         @"com.kodak.flashpix.image",
                         @"com.j2.jfx-fax",
                         @"com.js.efx-fax",
                         @"com.digidesign.sd2-audio",
                         @"com.real.realmedia",
                         @"com.real.realaudio",
                         @"com.real.smil",
                         @"com.allume.stuffit-archive",
                         @"org.openxmlformats.wordprocessingml.document",
                         @"com.microsoft.powerpoint.​ppt",
                         @"org.openxmlformats.presentationml.presentation",
                         @"com.microsoft.excel.xls",
                         @"org.openxmlformats.spreadsheetml.sheet"];
    }
    return self;
}

/**
 获取系统文件内容
 */
- (void)acquireDocumentTypes:(NSArray <NSString *>*)allowedUTIs Block:(void(^)(NSString *fileName,NSString *filePath))block{
    self.document_Block = block;
    if (allowedUTIs.count == 0) {
        allowedUTIs = self.dataArr;
    }
    UIDocumentPickerViewController *docPicker = [[UIDocumentPickerViewController alloc] initWithDocumentTypes:allowedUTIs inMode:UIDocumentPickerModeOpen];
    docPicker.delegate = self;
    [[TFY_CacheFileUilt presentMenuView] presentViewController:docPicker animated:YES completion:^{}];
}

/*
 * parameter  本地文件路径
 * parameter  显示所在控制器
 * parameter  预览导航栏的标题
 */
- (void)openFileWithFilePath:(NSURL *)filePath andNavTitleName:(NSString *)name Document:(TFY_DocumentCustomizeMode)document{
    UIDocumentInteractionController *documentIntController = [UIDocumentInteractionController interactionControllerWithURL:filePath];
    documentIntController.name = name;
    documentIntController.delegate = self;
    switch (document) {
        case TFY_Document:{
            [documentIntController presentPreviewAnimated:YES];//直接预览  然后在预览中选择是否使用其他软件打开
        }break;
        case TFY_DocumentOpenInMenu:{
            [documentIntController presentOpenInMenuFromRect:[TFY_CacheFileUilt presentMenuView].view.bounds inView:[TFY_CacheFileUilt presentMenuView].view animated:YES];//显示提示框 但是第三行不能选择预览
        }break;
        case TFY_DocumentOptionsMenu:{
            [documentIntController presentOptionsMenuFromRect:[TFY_CacheFileUilt presentMenuView].view.bounds inView:[TFY_CacheFileUilt presentMenuView].view animated:YES];//显示提示框 再选择是否开启预览
        }break;
    }
}

/*
 * parameter  本地文件路径
 * parameter  点击的导航栏BarButtonItem
 * parameter  显示所在控制器
 * parameter  预览导航栏的标题
 */
- (void)openFileWithFilePath:(NSURL *)filePath andItem:(UIBarButtonItem *)barButtonItem andNavTitleName:(NSString *)name Document:(TFY_DocumentCustomizeMode)document {
    UIDocumentInteractionController *documentIntController = [UIDocumentInteractionController interactionControllerWithURL:filePath];
    documentIntController.name = name;
    documentIntController.delegate = self;
    switch (document) {
        case TFY_Document:{
            [documentIntController presentPreviewAnimated:YES];//直接预览  然后在预览中选择是否使用其他软件打开
        }break;
        case TFY_DocumentOpenInMenu:{
            [documentIntController presentOpenInMenuFromBarButtonItem:barButtonItem animated:YES];//显示提示框 但是第三行不能选择预览
        }break;
        case TFY_DocumentOptionsMenu:{
            [documentIntController presentOptionsMenuFromBarButtonItem:barButtonItem animated:YES];//显示提示框 再选择是否开启预览
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
    return [TFY_CacheFileUilt presentMenuView];
}

#pragma mark - UIDocumentPickerDelegate
- (void)documentPicker:(UIDocumentPickerViewController *)controller didPickDocumentsAtURLs:(NSArray <NSURL *>*)urls
{
    BOOL fileAuthorized = [urls.firstObject startAccessingSecurityScopedResource];
    if (fileAuthorized) {
        [self selectedDocumentAtURLs:urls reName:nil];
        [urls.firstObject stopAccessingSecurityScopedResource];
        [controller dismissViewControllerAnimated:YES completion:nil];
        return;
    }
}

- (void)documentPickerWasCancelled:(UIDocumentPickerViewController *)controller
{
    [controller dismissViewControllerAnimated:YES completion:nil];
}

//icloud
- (void)selectedDocumentAtURLs:(NSArray <NSURL *>*)urls reName:(NSString *)rename
{
    NSFileCoordinator *fileCoordinator = [[NSFileCoordinator alloc]init];
    for (NSURL *url in urls) {
        NSError *error;
        [fileCoordinator coordinateReadingItemAtURL:url options:0 error:&error byAccessor:^(NSURL * _Nonnull newURL) {
            //读取文件
            NSError *error;
            NSData *fileData = [NSData dataWithContentsOfURL:newURL options:NSDataReadingMappedIfSafe error:&error];
            NSString *fileName = [newURL lastPathComponent];
            NSString *filePath = [self createFilePath:fileName];
            BOOL isExistence = [[NSFileManager defaultManager] fileExistsAtPath:filePath];
            if (isExistence) {
                /**
                 * 存在同名文件，对文件名进行递增
                 */
                int i = 0;
                NSArray *arrayM = [NSFileManager.defaultManager subpathsAtPath:[self createFilePath:fileName]];
                for (NSString *sub in arrayM) {
                    if ([sub.pathExtension isEqualToString:fileName.pathExtension] &&
                        [sub.stringByDeletingPathExtension containsString:fileName.stringByDeletingPathExtension]) {
                        i++;
                    }
                }
                if (i) {
                    fileName = [fileName stringByReplacingOccurrencesOfString:fileName.stringByDeletingPathExtension withString:[NSString stringWithFormat:@"%@(%d)", fileName.stringByDeletingPathExtension, i]];
                    filePath = [self createFilePath:fileName];
                }
            }
            BOOL isFile = [[NSFileManager defaultManager] createFileAtPath:filePath contents:fileData attributes:nil];
            if (!isFile) {
                NSLog(@"创建失败");
                return;
            }
            isExistence = [[NSFileManager defaultManager] fileExistsAtPath:filePath];
            if(isExistence){
                if (self.document_Block) {
                    self.document_Block(fileName, filePath);
                }
            }
        }];
    }
}

-(NSString*)createFilePath:(NSString*)fileName{
    NSString * filePathString = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    return [NSString stringWithFormat:@"%@/%@",filePathString,fileName];
}

@end
