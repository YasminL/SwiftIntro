//
//  ImagePrefetcher.swift
//  SwiftIntro
//
//  Created by Alexander Georgii-Hemming Cyon on 02/06/16.
//  Copyright © 2016 SwiftIntro. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireImage

protocol ImagePrefetcherProtocol {
    func prefetchImages(urls: [URLRequestConvertible], done: Closure)
    func imageFromCache(url: NSURL) -> UIImage?
}

class ImagePrefetcher {

    static let sharedInstance: ImagePrefetcherProtocol = ImagePrefetcher()
    private let imageDownloader: ImageDownloader

    init() {
        self.imageDownloader = ImageDownloader(
            configuration: ImageDownloader.defaultURLSessionConfiguration(),
            downloadPrioritization: .FIFO
        )
    }

    var imageCache: ImageRequestCache? {
        return imageDownloader.imageCache
    }
}

extension ImagePrefetcher: ImagePrefetcherProtocol {


    func imageFromCache(url: NSURL) -> UIImage? {
        guard let cache = imageCache else { return nil }
        let imageFromCache = cache.imageForRequest(NSURLRequest(URL: url), withAdditionalIdentifier: nil)
        return imageFromCache
    }

    func prefetchImages(urls: [URLRequestConvertible], done: Closure) {

        imageDownloader.downloadImages(URLRequests: urls) {
            response in
            done()
        }
    }
}

struct URL: URLRequestConvertible {
    let url: NSURL
    //swiftlint:disable variable_name
    var URLRequest: NSMutableURLRequest {
        return NSMutableURLRequest(URL: url)
    }
}