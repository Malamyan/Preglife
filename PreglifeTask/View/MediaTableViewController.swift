//
//  ViewController.swift
//  PreglifeTask
//
//  Created by Ani Khechoyan on 4/19/21.
//  Copyright © 2021 Ani Khechoyan. All rights reserved.
//

import UIKit
import AVKit
import SDWebImage

class MediaTableViewController: UITableViewController {
    
    let mediaListViewModel = MediaListViewModel()
    let mediaCellIdentifier = "MediaTableViewCell"
    let detailSegueIdentifier = "MediaDetailSegue"
    
    var player: AVPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.navigationItem.title = mediaListViewModel.title
        
        self.fetchData()
        self.addRefreshControl()
    }
    
    // MARK: Private
    
    private func fetchData() {
        self.mediaListViewModel.fetchMediaList()
        self.mediaListViewModel.bindMediaList = {
            self.tableView.reloadData()
        }
        self.mediaListViewModel.bindMediaListFailure = { (error) in
            self.showAlert(error.localizedDescription)
        }
    }
    
    @objc private func clearAndFetchData() {
        self.mediaListViewModel.fetchMediaListFromServer()
        self.mediaListViewModel.bindMediaList = {
            self.tableView.reloadData()
            self.refreshControl?.endRefreshing()
        }
    }
    
    private func addRefreshControl() {
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.addTarget(self, action: #selector(self.clearAndFetchData), for: .valueChanged)
    }
    
    private func showAlert(_ message: String) {
        let alert = UIAlertController(title: "Oops...", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

// MARK: UITableViewDataSource

extension MediaTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.mediaListViewModel.mediaViewModels.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: mediaCellIdentifier, for: indexPath) as! MediaTableViewCell
        let mediaViewModel = self.mediaListViewModel.mediaViewModels[indexPath.row]
        cell.mediaViewModel = mediaViewModel
        return cell
    }
}

// MARK: UITableViewDelegate

extension MediaTableViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedMediaViewModel = self.mediaListViewModel.mediaViewModels[indexPath.row]
        
        guard let url = selectedMediaViewModel.url else {
            return
        }
        
        if Reachability.isConnectedToNetwork() {
            Service.shared.pingGithub()
            
            self.player = AVPlayer(url: url)
            let vc = AVPlayerViewController()
            vc.player = self.player
            
            // Lock screen artwork
            let itemArtwork = AVMutableMetadataItem()
            itemArtwork.value = try? Data(contentsOf: selectedMediaViewModel.thumb!) as NSData
            itemArtwork.dataType = kCMMetadataBaseDataType_PNG as String
            itemArtwork.identifier = AVMetadataIdentifier.commonIdentifierArtwork;
            vc.player?.currentItem?.externalMetadata.append(itemArtwork)
            
            // In case of audio show a thumbnail
            if selectedMediaViewModel.type == .audio {
                let thumbnailImageView = UIImageView()
                thumbnailImageView.sd_setImage(with: selectedMediaViewModel.thumb)
                thumbnailImageView.layer.cornerRadius = 10
                thumbnailImageView.clipsToBounds = true
                vc.contentOverlayView?.addSubview(thumbnailImageView)
                
                thumbnailImageView.translatesAutoresizingMaskIntoConstraints = false
                vc.contentOverlayView?.addConstraints([NSLayoutConstraint(item: thumbnailImageView , attribute: .centerX, relatedBy: .equal, toItem: vc.contentOverlayView, attribute: .centerX, multiplier: 1, constant: 0)])
                vc.contentOverlayView?.addConstraints([NSLayoutConstraint(item: thumbnailImageView, attribute: .centerY, relatedBy: .equal, toItem: vc.contentOverlayView, attribute: .centerY, multiplier: 1, constant: 0)])
            }
            
            present(vc, animated: true) {
                vc.player?.play()
            }
        } else {
            self.showAlert("The internet connection seems to be off.")
            self.tableView.deselectRow(at: indexPath, animated: false)
            (self.tableView.cellForRow(at: indexPath) as? MediaTableViewCell)?.deselect()
        }
    }
}

