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
    }
    
    @objc func fetchLatestMovies() {
        service.discoverMovies(page: 1) { [weak self] (discoverResult, error) in
            self?.refreshControl?.endRefreshing()
            
            if let error = error {
                print(error)
            } else {
                self?.discoverResult = discoverResult
                print(discoverResult!)
            }
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
