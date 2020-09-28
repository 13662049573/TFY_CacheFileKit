//
//  AppDelegate.m
//  TFY_CacheFileKit
//
//  Created by 田风有 on 2020/9/25.
//

#import "AppDelegate.h"
#import "ViewController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    if (![TFY_Scene defaultPackage].isSceneApp) {
        self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        self.window.backgroundColor = [UIColor whiteColor];
        [self.window makeKeyAndVisible];
    }
    [[TFY_Scene defaultPackage] addBeforeWindowEvent:^(TFY_Scene * _Nonnull application) {
        ViewController *vc = ViewController.new;
        vc.path = [launchOptions[UIApplicationLaunchOptionsURLKey] description];
        TFY_NavigationController *nav = [[TFY_NavigationController alloc] initWithRootViewController:vc];
        [UIApplication tfy_window].rootViewController = nav;
    }];
    NSString *str = [NSString stringWithFormat:@"\n发送请求的应用程序的 Bundle ID：%@\n\n文件的NSURL：%@\n\n文件相关的属性列表对象：%@",
                     launchOptions[UIApplicationLaunchOptionsSourceApplicationKey],
                     launchOptions[UIApplicationLaunchOptionsURLKey],
                     launchOptions[UIApplicationLaunchOptionsSourceApplicationKey]];
    
    NSLog(@"------------%@",str);
    return YES;
}



- (BOOL)application:(UIApplication *)application openURL:(nonnull NSURL *)url options:(nonnull NSDictionary<NSString *,id> *)options {
    if (options) {
        NSString *str = [NSString stringWithFormat:@"\n发送请求的应用程序的 Bundle ID：%@\n\n文件的NSURL：%@", options[UIApplicationOpenURLOptionsSourceApplicationKey], url];
        
        NSLog(@"------------%@",str);
    }
    return YES;
}


@end
