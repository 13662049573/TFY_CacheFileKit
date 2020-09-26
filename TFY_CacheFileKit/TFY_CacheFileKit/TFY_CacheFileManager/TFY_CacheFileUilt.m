//
//  TFY_CacheFileUilt.m
//  TFY_CacheFileKit
//
//  Created by 田风有 on 2020/9/25.
//

#import "TFY_CacheFileUilt.h"

@implementation TFY_CacheFileUilt

+ (UIViewController *)presentMenuView {
    // 获取根式控制器rootViewController，并将rootViewController设置为当前主控制器（防止菜单弹出时，部分被导航栏或标签栏遮盖）
    UIWindow *window = [self lastWindow];
    UIViewController *rootVC = [self getTheLatestViewController:window.rootViewController];
    rootVC.definesPresentationContext = YES;
    // 当前主控制器推出菜单栏
    return rootVC;
}
//递归返回最上面的presentedViewController
+ (UIViewController *)getTheLatestViewController:(UIViewController *)vc {
    if (vc.presentedViewController == nil) {
        return vc;
    }
    return [self getTheLatestViewController:vc.presentedViewController];
}

+ (UIWindow*)lastWindow {
    NSEnumerator  *frontToBackWindows = [UIApplication.sharedApplication.windows reverseObjectEnumerator];
    for (UIWindow *window in frontToBackWindows) {
        BOOL windowOnMainScreen = window.screen == UIScreen.mainScreen;

        BOOL windowIsVisible = !window.hidden&& window.alpha>0;

        BOOL windowLevelSupported = (window.windowLevel >= UIWindowLevelNormal && window.windowLevel <= UIWindowLevelNormal);

        BOOL windowKeyWindow = window.isKeyWindow;
        
        if (windowOnMainScreen && windowIsVisible && windowLevelSupported && windowKeyWindow) {
            return window;
        }
    }
    return [UIApplication sharedApplication].keyWindow;
}
@end
