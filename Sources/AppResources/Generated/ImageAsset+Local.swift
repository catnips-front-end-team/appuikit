////
////  ImageAsset+Local.swift
////  AppUIKit
////
////  Created by xxf on 2025/9/3.
////
//import Foundation
//import AppKit
//extension ImageAsset{
//
//    func switchLocalizationBundleDuringRuntime(_ name:String,_ bundle:Bundle) -> NSImage?{
//        if(ImageAssetLoader.loaderInterceptor != nil){
//            return ImageAssetLoader.loaderInterceptor!(name,bundle)
//        }
//        let image = (bundle == .main) ? NSImage(named: name) : bundle.image(forResource: name)
//        return image
//    }
//}
/////取一个别名,其他库有冲突
//public typealias AppImageAsset = ImageAsset
//
//
///// 拦截加载
//public class ImageAssetLoader{
//    public typealias ImageAssetLoaderInterceptor = (_ name:String,_ bundle:Bundle) ->  NSImage?
//    
//    nonisolated(unsafe) public static var loaderInterceptor:ImageAssetLoaderInterceptor?
//}

#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif


/// spm xcassert文件会合并,所以不能是多个bundle
public extension ImageAsset{
    /// 对应的文件目录
     func localizedName(lang:String)->String{
        return lang+"/"+self.name
    }
    
    /// 少数场景才需要图片国际化,不破坏原来的性能
    /// 如果对应的语言没有放这个图片,会用默认的这个图片
    /// - Parameter lang: 语言
    /// - Returns: 图片
    @available(iOS 8.0, tvOS 9.0, watchOS 2.0, macOS 10.7, *)
    func localizedImage(lang:String) -> Image{
        let bundle = BundleToken.bundle
        #if os(iOS) || os(tvOS)
        var image = Image(named: localizedName(lang: lang), in: bundle, compatibleWith: nil)
        if image == nil {
            image = Image(named: name, in: bundle, compatibleWith: nil)
        }
        #elseif os(macOS)
        var nsName = NSImage.Name(localizedName(lang: lang))
        var image = (bundle == .main) ? NSImage(named: nsName) : bundle.image(forResource: nsName)
        if image == nil {
             nsName = NSImage.Name(name)
             image = (bundle == .main) ? NSImage(named: nsName) : bundle.image(forResource: nsName)
        }
        #elseif os(watchOS)
        var image = Image(named: localizedName(lang: lang))
        if image == nil {
            image = Image(named: name)
        }
        #endif
        guard let result = image else {
          fatalError("Unable to load image asset named \(name).")
        }
        return result
    }
}
