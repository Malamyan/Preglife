//
//  MediaTableViewCell.swift
//  PreglifeTask
//
//  Created by Ani Khechoyan on 4/19/21.
//  Copyright © 2021 Ani Khechoyan. All rights reserved.
//

import UIKit
import SDWebImage

class MediaTableViewCell: UITableViewCell {

    @IBOutlet weak var thumbImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var starButton: UIButton!
    @IBOutlet weak var watchedImageView: UIImageView!
    
    var mediaViewModel: MediaViewModel! {
        didSet {
            self.titleLabel.text = self.mediaViewModel.title
            self.updateThumbImage()
            self.updateStarState()
            self.updateWatchStatus()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.thumbImageView.layer.cornerRadius = 10
        self.thumbImageView.layer.borderWidth = 1
        self.thumbImageView.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            self.mediaViewModel.changeWatched(true)
            self.updateWatchStatus()
        }
    }
    
    func deselect() {
        self.mediaViewModel.changeWatched(false)
        self.updateWatchStatus()
    }

    // MARK: Actions
    
    @IBAction func starButtonPressed(_ sender: Any) {
        self.mediaViewModel.changeFavorite()
        self.updateStarState()
    }
    
    // MARK: Private
    
    private func updateWatchStatus() {
        self.watchedImageView.alpha = self.mediaViewModel.isWatched ? 1 : 0
        self.titleLabel.font = UIFont.systemFont(ofSize: self.titleLabel.font.pointSize, weight: self.mediaViewModel.isWatched ? .regular : .bold)
    }
    
    private func updateStarState() {
        self.starButton.setImage(UIImage(systemName: self.mediaViewModel.isFavorite ? "star.fill" : "star"), for: .normal)
    }
    
    private func updateThumbImage() {
        if let thumb = self.mediaViewModel.thumb {
            self.thumbImageView.sd_setImage(with: thumb)
        }
    }
}
