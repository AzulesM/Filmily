//
//  MovieTableViewController.swift
//  Filmily
//
//  Created by Azules on 2018/9/4.
//  Copyright © 2018年 Azules. All rights reserved.
//

import UIKit

class MovieTableViewController: UITableViewController {
    
    struct SegueIdentifier {
        static let showMovieDetail = "ShowDetailSegue"
    }
    
    struct BundleKey {
        static let displayName = "CFBundleDisplayName"
    }
    
    var discoverResult: DiscoverResult?
    
    var movies: [Movie] = [Movie]()
    
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = Bundle.main.object(forInfoDictionaryKey: BundleKey.displayName) as? String
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        initView()
        Spinner.start()
        fetchLatestMovies()
    }
    
    func initView() {
        refreshControl = UIRefreshControl()
        refreshControl!.addTarget(self, action: #selector(fetchLatestMovies), for: .valueChanged)
        
        tableView.estimatedRowHeight = 242.0
    }
    
    @objc func fetchLatestMovies() {
        TMDBService.shared.discoverMovies(page: 1) { [weak self] (discoverResult, error) in
            Spinner.stop()
            self?.refreshControl?.endRefreshing()

            if let error = error {
                print(error)
            } else {
                self?.discoverResult = discoverResult
                self?.insertMovies((discoverResult?.results)!, at: 0)
            }
        }
    }
    
    func fetchMoreMovies() {
        indicatorView.startAnimating()
        
        TMDBService.shared.discoverMovies(page: (discoverResult?.page)! + 1) { [weak self] (discoverResult, error) in
            self?.indicatorView.stopAnimating()
            
            if let error = error {
                print(error)
            } else {
                self?.discoverResult?.page = discoverResult?.page
                self?.insertMovies((discoverResult?.results)!, at: (self?.movies.count)! - 1)
            }
        }
    }
    
    func insertMovies(_ movies: [Movie], at index: Int) {
        var newMovies = [Movie]()
        
        // Display those movie info TMDB provided with title and at least poster or backdrop
        for movie in movies where movie.isInfoEnough() {
            if index != 0 {
                newMovies.append(movie)
            } else if !self.movies.contains(movie) {
                newMovies.append(movie)
            }
        }
        
        self.movies.insert(contentsOf: newMovies, at: index)
        tableView.reloadData()
    }
    
    func cellIdentifier(for data: Any) -> String {
        switch data {
        case is Movie:
            return BriefMovieTableViewCell.cellIdentifier()

        default:
            fatalError("Unexpected data type: \(data)")
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 242.0
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // The max input parameter of page for discover TMDB movies is 1000
        let maxPage = 1000
        let page = discoverResult?.page ?? 0
        let isMoreMoviesExisted = page < (discoverResult?.total_results)! && page < maxPage
        
        if indexPath.row == movies.count - 1 && isMoreMoviesExisted {
            fetchMoreMovies()
        } else if !isMoreMoviesExisted {
            tableView.tableFooterView?.isHidden = true
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let movie = self.movies[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier(for: movie), for: indexPath)
        
        if let cell = cell as? BriefMovieTableViewCell {
            cell.configure(for: movie)
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: SegueIdentifier.showMovieDetail, sender: indexPath)
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = sender as? IndexPath {
            let viewController = segue.destination as? MovieDetailTableViewController
            viewController?.movie = self.movies[indexPath.row]
        }
    }

}
