//
//  NAVViewController.m
//  TFY_CacheFileKit
//
//  Created by 田风有 on 2020/10/25.
//

#import "NAVViewController.h"

@interface NAVViewController ()
TFY_PROPERTY_OBJECT_STRONG(UIButton, btn);
TFY_PROPERTY_OBJECT_STRONG(UIButton, btn2);
@end

@implementation NAVViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = UIColor.purpleColor;
    
    self.btn.frame = CGRectMake(0, 100, TFY_Width_W(), 50);
    [self.view addSubview:self.btn];
    
    self.btn2.frame = CGRectMake(0, 200, TFY_Width_W(), 50);
    [self.view addSubview:self.btn2];
}

- (UIButton *)btn {
    if (!_btn) {
        _btn = UIButtonSet();
        _btn.makeChain
        .textColor(UIColor.whiteColor, UIControlStateNormal)
        .text(@"下一个界面", UIControlStateNormal)
        .font([UIFont systemFontOfSize:14 weight:UIFontWeightBold])
        .backgroundColor(UIColor.greenColor)
        .addTarget(self, @selector(buttonClick222), UIControlEventTouchUpInside);
    }
    return _btn;
}

- (UIButton *)btn2 {
    if (!_btn2) {
        _btn2 = UIButtonSet();
        _btn2.makeChain
        .textColor(UIColor.whiteColor, UIControlStateNormal)
        .text(@"回到首页", UIControlStateNormal)
        .font([UIFont systemFontOfSize:14 weight:UIFontWeightBold])
        .backgroundColor(UIColor.greenColor)
        .addTarget(self, @selector(buttonClick22233), UIControlEventTouchUpInside);
    }
    return _btn2;
}


- (void)buttonClick222 {
    [self.navigationController pushViewController:NAVViewController.new animated:YES];
}

- (void)buttonClick22233 {
    [self.navigationController popToViewController:self.navigationController.viewControllers[0] animated:YES];
}
@end
