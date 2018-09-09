//
//  BriefMovieTableViewCell.swift
//  Filmily
//
//  Created by Azules on 2018/9/6.
//  Copyright © 2018年 Azules. All rights reserved.
//

import UIKit

class BriefMovieTableViewCell: UITableViewCell {

    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var popularityLabel: UILabel!
    
    func configure(for movie: Movie) {
        titleLabel?.text = movie.title
        popularityLabel?.text = String(format: "%.1f ★", movie.popularity!)
    }
    
}

public extension UITableViewCell {
    public static func cellIdentifier() -> String {
        return String(describing: self)
    }
}
