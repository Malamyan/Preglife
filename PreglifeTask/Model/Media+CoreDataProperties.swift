//
//  Media+CoreDataProperties.swift
//  PreglifeTask
//
//  Created by Ani Khechoyan on 4/20/21.
//  Copyright © 2021 Ani Khechoyan. All rights reserved.
//
//

import Foundation
import CoreData

extension Media {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Media> {
        return NSFetchRequest<Media>(entityName: "Media")
    }

    @NSManaged public var id: Int64
    @NSManaged public var text: String?
    @NSManaged public var thumb: String?
    @NSManaged public var title: String?
    @NSManaged public var type: String?
    @NSManaged public var url: String?
    @NSManaged public var isFavorite: Bool
    @NSManaged public var isWatched: Bool

}
