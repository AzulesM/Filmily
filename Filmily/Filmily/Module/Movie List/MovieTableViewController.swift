//
//  MovieTableViewController.swift
//  Filmily
//
//  Created by Azules on 2018/9/4.
//  Copyright © 2018年 Azules. All rights reserved.
//

import UIKit

class MovieTableViewController: UITableViewController {
    
    var discoverResult: DiscoverResult?
    
    var movies: [Movie] = [Movie]()
    
    let service = TMDBService()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initView()
        fetchLatestMovies()
    }
    
    func initView() {
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.addTarget(self, action: #selector(fetchLatestMovies), for: .valueChanged)
        
        tableView.estimatedRowHeight = 242.0
    }
    
    @objc func fetchLatestMovies() {
        service.discoverMovies(page: 1) { [weak self] (discoverResult, error) in
            self?.refreshControl?.endRefreshing()
            
            if let error = error {
                print(error)
            } else {
                self?.discoverResult = discoverResult
                self?.insertLatestMovies((discoverResult?.results)!)
            }
        }
    }
    
    func insertLatestMovies(_ movies: [Movie]) {
        for movie in movies.reversed() where !self.movies.contains(movie) {
            // display those movie info TMDB provided with title and at least poster or backdrop
            if movie.isInfoEnough() {
                self.movies.insert(movie, at: 0)
            }
        }
        
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
        return self.movies.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 242.0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let movie = self.movies[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier(for: movie), for: indexPath)
        
        if let cell = cell as? BriefMovieTableViewCell {
            cell.configure(for: movie)
        }

        return cell
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
