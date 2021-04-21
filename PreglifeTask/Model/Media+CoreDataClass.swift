//
//  Media+CoreDataClass.swift
//  PreglifeTask
//
//  Created by Ani Khechoyan on 4/20/21.
//  Copyright © 2021 Ani Khechoyan. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Media)
public class Media: NSManagedObject, Decodable {
    
    enum CodingKeys: CodingKey {
      case type, thumb, title, text, url
    }
    
    required convenience public init(from decoder: Decoder) throws {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        guard let media = NSEntityDescription.entity(forEntityName: "Media", in: context) else { fatalError() }

        self.init(entity: media, insertInto: context)

        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.type = try container.decode(String.self, forKey: .type)
        self.thumb = try container.decode(String.self, forKey: .thumb)
        self.title = try container.decode(String.self, forKey: .title)
        self.text = try container.decode(String.self, forKey: .text)
        self.url = try container.decode(String.self, forKey: .url)
    }
    
}
