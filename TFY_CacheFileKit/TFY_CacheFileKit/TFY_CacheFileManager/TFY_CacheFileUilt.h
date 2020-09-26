//
//  TFY_CacheFileUilt.h
//  TFY_CacheFileKit
//
//  Created by 田风有 on 2020/9/25.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface TFY_CacheFileUilt : NSObject
//获取根式控制器rootViewController，并将rootViewController设置为当前主控制器（防止菜单弹出时，部分被导航栏或标签栏遮盖）
+ (UIViewController *)presentMenuView;
@end

NS_ASSUME_NONNULL_END
