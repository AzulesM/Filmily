//
//  MovieDetailTableViewController.swift
//  Filmily
//
//  Created by Azules on 2018/9/8.
//  Copyright © 2018年 Azules. All rights reserved.
//

import UIKit

class MovieDetailTableViewController: UITableViewController, Alertable {
    
    struct SegueIdentifier {
        static let displayBookingWebsite = "DisplayBookMovie"
    }

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var genresLabel: UILabel!
    @IBOutlet weak var runtimeLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    
    var bookingButton: UIButton!
    var originalButtonPoint: CGPoint = CGPoint.zero
    
    var movie: Movie?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateUI()
        addBookingButton()
        retrieveMovieDetail()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if bookingButton.frame == CGRect.zero {
            customBookingButton()
        }
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let point = CGPoint(x: originalButtonPoint.x, y: originalButtonPoint.y + tableView.contentOffset.y)
        bookingButton.frame = CGRect(origin: point, size: bookingButton.frame.size)
    }
    
    func addBookingButton() {
        bookingButton = UIButton(type: .custom)
        bookingButton.backgroundColor = UIColor.buttonRed()
        bookingButton.setImage(UIImage(named: "Ticket"), for: .normal)
        bookingButton.addTarget(self, action: #selector(displayBookingWebsite), for: .touchUpInside)
        tableView.addSubview(bookingButton)
    }
    
    func customBookingButton() {
        let buttonLength: CGFloat = 50.0
        let constantToEdge: CGFloat = 16.0
        originalButtonPoint = CGPoint(x: tableView.bounds.maxX - buttonLength - constantToEdge,
                                      y: tableView.bounds.maxY - buttonLength - constantToEdge)
        bookingButton.frame = CGRect(origin: originalButtonPoint, size: CGSize(width: buttonLength, height: buttonLength))
        bookingButton.layer.cornerRadius = bookingButton.bounds.width / 2.0
        bookingButton.layer.shadowColor = UIColor.lightGray.cgColor
        bookingButton.layer.shadowOpacity = 0.8
        bookingButton.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
    }

    func retrieveMovieDetail() {
        if self.movie?.genres != nil && self.movie?.runtime != nil {
            return
        }
        
        Spinner.start()
        
        TMDBService.shared.getMovieDetail(id: (movie?.id)!) { [weak self] (movie, error) in
            Spinner.stop()
            
            if let error = error {
                self?.showAlert(title: "", message: error.localizedDescription)
            } else {
                self?.movie?.genres = movie?.genres
                self?.movie?.runtime = movie?.runtime
                self?.updateUI()
            }
        }
    }
    
    @objc func displayBookingWebsite() {
        performSegue(withIdentifier: SegueIdentifier.displayBookingWebsite, sender: nil)
    }
    
    // MARK: - Display
    
    func updateUI() {
        requestForImage()
        
        titleLabel.text = movie?.title
        languageLabel.text = languageString()
        genresLabel.text = genresString()
        runtimeLabel.text = runtimeString()
        overviewLabel.text = movie?.overview
        
        tableView.reloadData()
    }
    
    func requestForImage() {
        let urlString = self.movie!.backdrop_path ?? self.movie!.poster_path
        let url = URL(string: "https://image.tmdb.org/t/p/w500" + urlString!)
        
        self.imageView.sd_setImage(with: url, placeholderImage: nil, options: .retryFailed) { [weak self] (image, error, cacheType, imageURL) in
            if error != nil {
                self?.imageView.image = UIImage(named: "Oops")
            }
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

}
