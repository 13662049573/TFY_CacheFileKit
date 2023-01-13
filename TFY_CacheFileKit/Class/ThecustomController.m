//
//  ThecustomController.m
//  TFY_CacheFileKit
//
//  Created by 田风有 on 2020/9/28.
//

#import "ThecustomController.h"

@interface ThecustomController ()
@property (nonatomic, strong)UIButton *rightButton;
@property(nonatomic , strong)NSURL *url;
@end

@implementation ThecustomController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightButton];
    
    self.title = @"自定义";
    
    [self viewTemplate];
}

- (void)viewTemplate {
   
    TFY_FilePreviewController *preview = [[TFY_FilePreviewController alloc] init];//创建对象
    preview.fileUrl = self.url;
    [self addChildViewController:preview];
    preview.view.frame = CGRectMake(0, -TFY_kNavTimebarHeight(), TFY_Width_W(), TFY_Height_H() - TFY_kBottomBarHeight());
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //延迟一秒显示 文件貌似需要调整
        [self.view addSubview:preview.view];//视图抽离与添加
    });
}

- (void)setUrlPath:(NSURL *)urlPath {
    _urlPath = urlPath;
    self.url = _urlPath;
}

- (UIButton*)rightButton {
    if (!_rightButton) {
        _rightButton = [[UIButton alloc]initWithFrame:CGRectMake(TFY_Width_W()-20, 15, 37, 25)];
        [_rightButton setTitle:@"• • •" forState:UIControlStateNormal];
        [_rightButton setTitleColor:TFY_ColorHexString(@"#222222") forState:UIControlStateNormal];
        _rightButton.titleLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightBold];
        [_rightButton addTarget:self action:@selector(browseClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightButton;
}

- (void)browseClick {
    [[TFY_DocumentPicker sharedOpen] openFileWithFilePath:self.url andNavTitleName:@"文件名称" Document:TFY_DocumentOpenInMenu];
}
@end
