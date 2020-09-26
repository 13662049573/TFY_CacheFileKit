//
//  TFY_CacheFileDefine.h
//  TFY_CacheFileKit
//
//  Created by 田风有 on 2020/9/25.
//

#ifndef TFY_CacheFileDefine_h
#define TFY_CacheFileDefine_h

#import <UIKit/UIKit.h>

static NSString *const TFY_CacheFileTitle = @"缓存文件";

/**
 *  默认显示文件
 *  视频：.avi、.dat、.mkv、.flv、.vob、.mp4、.m4v、.mpg、.mpeg、.mpe、.3pg、.mov、.swf、.wmv、.asf、.asx、.rm、.rmvb
 *  音频：.wav、.aif、.au、.mp3、.ram、.wma、.mmf、.amr、.aac、.flac、.midi、.mp3、.oog、.cd、.asf、.rm、.real、.ape、.vqf
 *  图片：.jpg、.png、.jpeg、.gif、.bmp
 *  文档：.txt、.sh、.doc、.docx、.xls、.xlsx、.pdf、.hlp、.wps、.rtf、.html、@".htm", .iso、.rar、.zip、.exe、.mdf、.ppt、.pptx、.apk
 */

/// 文件类型
typedef NS_ENUM(NSInteger, TFY_CacheFileType)
{
    /// 文件类型 0未知
    TFY_CacheFileTypeUnknow = 0,
    
    /// 文件类型 1视频
    TFY_CacheFileTypeVideo = 1,
    
    /// 文件类型 2音频
    TFY_CacheFileTypeAudio = 2,
    
    /// 文件类型 3图片
    TFY_CacheFileTypeImage = 3,
    
    /// 文件类型 4文档
    TFY_CacheFileTypeDocument = 4,
};

#endif /* TFY_CacheFileDefine_h */
