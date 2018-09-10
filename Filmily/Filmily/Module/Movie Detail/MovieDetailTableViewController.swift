//
//  MovieDetailTableViewController.swift
//  Filmily
//
//  Created by Azules on 2018/9/8.
//  Copyright © 2018年 Azules. All rights reserved.
//

import UIKit

class MovieDetailTableViewController: UITableViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var genresLabel: UILabel!
    @IBOutlet weak var runtimeLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    
    var movie: Movie?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateUI()
        retrieveMovieDetail()
    }
    
    func updateUI() {
        requestForImage()
        
        titleLabel.text = movie?.title
        languageLabel.text = languageString()
        genresLabel.text = genresString()
        runtimeLabel.text = runtimeString()
        overviewLabel.text = movie?.overview
        
        tableView.reloadData()
    }
    
    func retrieveMovieDetail() {
        TMDBService.shared.getMovieDetail(id: (movie?.id)!) { [weak self] (movie, error) in
            if let error = error {
                print(error)
            } else {
                self?.movie?.genres = movie?.genres
                self?.movie?.runtime = movie?.runtime
                self?.updateUI()
            }
        }
    }
    
    func requestForImage() {
        let urlString = self.movie!.backdrop_path ?? self.movie!.poster_path
        let url = URL(string: "https://image.tmdb.org/t/p/w500" + urlString!)
        
        self.imageView.sd_setImage(with: url, placeholderImage: nil, options: .retryFailed) { (image, error, cacheType, imageURL) in
        }
    }
    
    func languageString() -> String {
        if let language = movie?.original_language {
            return Locale.current.localizedString(forLanguageCode: language)!
        }
        
        return ""
    }
    
    func genresString() -> String {
        if let genres = self.movie?.genres {
            var genresString = ""
            
            for genre in genres {
                genresString += genre.name!
            }
            
            return genresString
        }
        
        return ""
    }
    
    func runtimeString() -> String {
        if let runtime = movie?.runtime {
            return String(format: "🕒 %02d : %02d", runtime / 60, runtime % 60)
        } else {
            return ""
        }
    }

    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 && indexPath.row == 0 {
            // 0.56 is the backdrop image from TMDb height/width ratio
            let backdropImageRatio: CGFloat = 0.56
            return (UIScreen.main.bounds.width - tableView.layoutMargins.left - tableView.layoutMargins.right) * backdropImageRatio
        }
        
        return UITableViewAutomaticDimension
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
