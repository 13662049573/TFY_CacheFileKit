//
//  UIView+document.m
//  TFY_CacheFileKit
//
//  Created by 田风有 on 2023/1/18.
//

#import "UIView+document.h"

@implementation UIView (document)

- (UIViewController*)document_viewController {
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UINavigationController class]] || [nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}

@end
