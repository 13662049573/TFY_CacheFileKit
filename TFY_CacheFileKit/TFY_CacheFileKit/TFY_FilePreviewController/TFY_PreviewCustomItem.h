//
//  TFY_PreviewCustomItem.h
//  TFY_CacheFileKit
//
//  Created by 田风有 on 2020/9/27.
//

#import <Foundation/Foundation.h>
#import <QuickLook/QuickLook.h>
NS_ASSUME_NONNULL_BEGIN

@interface TFY_PreviewCustomItem : NSObject<QLPreviewItem>
@property (nonatomic, strong) NSString *previewItemTitle;
@property (nonatomic, strong) NSURL *previewItemURL;
@end

NS_ASSUME_NONNULL_END
