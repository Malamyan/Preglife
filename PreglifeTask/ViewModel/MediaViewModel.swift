//
//  MediaViewModel.swift
//  PreglifeTask
//
//  Created by Ani Khechoyan on 4/19/21.
//  Copyright © 2021 Ani Khechoyan. All rights reserved.
//

import Foundation

enum MediaType: String {
    case video = "video"
    case audio = "audio"
}

class MediaViewModel {
    
    var type: MediaType?
    var thumb: URL?
    var title: String? { media.title }
    var text: String? { media.text }
    var url: URL?
    var isFavorite: Bool { media.isFavorite }
    var isWatched: Bool { media.isWatched }
    
    private var media: Media
    
    // Dependency Injection
    init(media: Media) {
        if let type = media.type {
            self.type = MediaType(rawValue: type)
        }
        if let thumb = media.thumb,
            let thumbUrl = URL(string: thumb) {
            self.thumb = thumbUrl
        }
        if let url = media.url, let mediaUrl = URL(string: url) {
            self.url = mediaUrl
        }
        
        self.media = media
    }
    
    public func changeFavorite() {
        media.isFavorite = !media.isFavorite
        CoreDataManager.shared.saveContext()
    }
    
    public func changeWatched(_ watched: Bool) {
        media.isWatched = watched
        CoreDataManager.shared.saveContext()
    }
}
