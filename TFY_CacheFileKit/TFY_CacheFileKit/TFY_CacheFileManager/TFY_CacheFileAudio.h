//
//  TFY_CacheFileAudio.h
//  TFY_CacheFileKit
//
//  Created by 田风有 on 2020/9/25.
//

#import <Foundation/Foundation.h>

static NSString * _Nonnull const TFY_CacheFileAudioDurationValueChangeNotificationName = @"AudioDurationValueChangeNotificationName";
static NSString * _Nonnull const TFY_CacheFileAudioStopNotificationName = @"AudioStopNotificationName";
static NSString * _Nonnull const TFY_CacheFileAudioDeleteNotificationName = @"AudioDeleteNotificationName";

NS_ASSUME_NONNULL_BEGIN

@interface TFY_CacheFileAudio : NSObject
+ (instancetype)shareAudio;

- (void)playAudioWithFilePath:(NSString *)filePath;

- (void)stopAudio;
@end

@interface TFY_CacheFileVideo : NSObject

/// 视频播放（根据路径）
- (void)playVideoWithFilePath:(NSString *)filePath target:(id)target;

@end


NS_ASSUME_NONNULL_END
