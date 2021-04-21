//
//  Service.swift
//  PreglifeTask
//
//  Created by Ani Khechoyan on 4/19/21.
//  Copyright © 2021 Ani Khechoyan. All rights reserved.
//

import UIKit

class Service: NSObject {
    static let shared = Service()
    
    let fetchMediaURL = "https://api.onlinebaby.se/v1/content/play/gravidyoga/gb"
    let pingGithubURL = "https://github.com"
    
    func fetchMedia(completion: @escaping ([Media]?, Error?) -> ()) {
        guard let url = URL(string: fetchMediaURL) else { return }
        URLSession.shared.dataTask(with: url) { (data, resp, err) in
            if let err = err {
                DispatchQueue.main.async {
                    completion(nil, err)
                }
                print("Failed to fetch media:", err)
                return
            }
            
            // check response
            guard let data = data else { return }
            do {
                let media = try JSONDecoder().decode([Media].self, from: data)
                DispatchQueue.main.async {
                    completion(media, nil)
                }
            } catch let jsonError {
                print("Failed to decode:", jsonError)
            }
        }.resume()
    }
    
    func pingGithub() {
        guard let url = URL(string: pingGithubURL) else { return }
        URLSession.shared.dataTask(with: url) { (data, resp, err) in
            if let err = err {
                print("Failed to ping github:", err)
                return
            }
            
            // check response
            guard let _ = data else { return }
            print("Successful ping to github!")
        }.resume()
    }
}
