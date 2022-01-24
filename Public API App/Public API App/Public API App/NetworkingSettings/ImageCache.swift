//
//  ImageCache.swift
//  Public API App
//
//  Created by Дмитрий Чепанов on 23.01.2022.
//

import UIKit
//синглтон, который созраняет в определенном месте кеш
class ImageCache {
    static let shared = NSCache<NSString, UIImage>()
    
    private init() {}
}

