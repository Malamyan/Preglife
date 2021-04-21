//
//  MediaListViewModel.swift
//  PreglifeTask
//
//  Created by Ani Khechoyan on 4/20/21.
//  Copyright © 2021 Ani Khechoyan. All rights reserved.
//

import Foundation
import CoreData

class MediaListViewModel {
    
    let title = "Media Resources"
    var mediaViewModels = [MediaViewModel]()
    
    var bindMediaList : (() -> ()) = {}
    var bindMediaListFailure : ((Error) -> ())?
    
    func fetchMediaList() {
        // Try to fetch from store
        if let media = self.fecthMediaListFromStore() {
            if media.isEmpty {
                // If not yet in store
                self.fetchMediaListFromServer()
            } else {
                // Already in store
                self.mapMediaToMediaViewModelAndBind(media: media)
            }
        }
    }
    
    func fetchMediaListFromServer() {
        self.clearMediaListFromStore()
        Service.shared.fetchMedia(completion: { (media, error) in
            if let err = error {
                self.bindMediaListFailure?(err)
            }
            if let media = media {
                for i in media.indices {
                    media[i].id = Int64(i)
                }
                CoreDataManager.shared.saveContext()
            }
            self.mapMediaToMediaViewModelAndBind(media: media)
        })
    }
    
    // MARK: Private
    
    private func fecthMediaListFromStore() -> [Media]? {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        do {
            let fetchRequest:NSFetchRequest<Media> = Media.fetchRequest()
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]

            return try context.fetch(fetchRequest)
        } catch {
            print("Couldn't fetch from the store!")
            return nil
        }
    }
    
    private func clearMediaListFromStore() {
        if let media = self.fecthMediaListFromStore() {
            for m in media {
                let context = CoreDataManager.shared.persistentContainer.viewContext
                context.delete(m)
            }
            CoreDataManager.shared.saveContext()
        }
    }
    
    private func mapMediaToMediaViewModelAndBind(media: [Media]?) {
        self.mediaViewModels = media?.map { MediaViewModel(media: $0) } ?? []
        DispatchQueue.main.async {
            self.bindMediaList()
        }
    }
}
