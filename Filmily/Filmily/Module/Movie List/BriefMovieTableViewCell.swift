//
//  BriefMovieTableViewCell.swift
//  Filmily
//
//  Created by Azules on 2018/9/6.
//  Copyright © 2018年 Azules. All rights reserved.
//

import UIKit
import SDWebImage

class BriefMovieTableViewCell: UITableViewCell {
    
    let baseURL: String = "https://image.tmdb.org/t/p/w500"
    
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var popularityLabel: UILabel!
    
    func configure(for movie: Movie) {
        titleLabel?.text = movie.title
        popularityLabel?.text = String(format: "%.1f 🔥", movie.popularity!)
        
        configureImage(for: movie)
    }
    
    private func configureImage(for movie: Movie) {
        let urlString = movie.backdrop_path ?? movie.poster_path
        let url = URL(string: baseURL + urlString!)
        
        movieImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "Loading"), options: .retryFailed) { [weak self] (image, error, cacheType, imageURL) in
            if error != nil {
                self?.movieImageView.image = UIImage(named: "Oops")
            }
            
//            if error == nil && urlString == movie.poster_path {
//                let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
//                visualEffectView.frame = (self?.movieImageView.bounds)!
//                self?.movieImageView.addSubview(visualEffectView)
//            }
        }
    }
    
}
