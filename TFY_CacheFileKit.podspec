
Pod::Spec.new do |spec|
  spec.name         = "TFY_CacheFileKit"

  spec.version      = "2.0.5"

  spec.summary      = "文件管理，分享，浏览"

  spec.description  = <<-DESC 
  文件管理，分享，浏览
                   DESC

  spec.homepage     = "https://github.com/13662049573/TFY_CacheFileKit"
  
  spec.license      = "MIT"
  
  spec.author             = { "田风有" => "420144542@qq.com" }
  
  spec.platform     = :ios, "10.0"

  spec.source       = { :git => "https://github.com/13662049573/TFY_CacheFileKit.git", :tag => spec.version }

  spec.source_files  = "TFY_CacheFileKit/TFY_CacheFileKit/TFY_CacheFileKit.h"

  spec.subspec 'TFY_CacheFileController' do |ss|
    ss.source_files  = "TFY_CacheFileKit/TFY_CacheFileKit/TFY_CacheFileController/**/*.{h,m}"
    ss.dependency "TFY_CacheFileKit/TFY_CacheFileManager"
 end

 spec.subspec 'TFY_CacheFileManager' do |ss|
  ss.source_files  = "TFY_CacheFileKit/TFY_CacheFileKit/TFY_CacheFileManager/**/*.{h,m}"
 end

 spec.subspec 'TFY_FilePreviewController' do |ss|
    ss.source_files  = "TFY_CacheFileKit/TFY_CacheFileKit/TFY_FilePreviewController/**/*.{h,m}"
 end

  spec.resources     = "TFY_CacheFileKit/TFY_CacheFileKit/TFY_CacheFileImages.bundle"

  spec.frameworks    = "Foundation","UIKit"

  spec.requires_arc = true

end
