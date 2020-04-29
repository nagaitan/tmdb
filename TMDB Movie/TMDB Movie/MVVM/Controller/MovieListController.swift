//
//  MovieListController.swift
//  TMDB Movie
//
//  Created by Adi Wibowo on 26/04/20.
//  Copyright © 2020 Adi Wibowo. All rights reserved.
//

import UIKit

class MovieListController: UIViewController, AlertDisplayer {
    let viewModel = MovieListViewModel()
    @IBOutlet weak var tableView: UITableView!
    private let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = viewModel.genre.name ?? "-"
        setupUI()
        
        self.viewModel.delegate = self
        self.viewModel.startStream()
        
    }
    
    static func initiate(genre : Genre) -> MovieListController{
        let cont = MovieListController()
        cont.viewModel.genre = genre
        return cont
    }
    
    func setupUI(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.prefetchDataSource = self
        
        tableView.register(UINib(nibName: "MovieCell", bundle: nil), forCellReuseIdentifier: "MovieCell")
        
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl)
        }
    }
    
    @objc private func refreshData(_ sender: Any) {
        self.viewModel.isClear = true
        viewModel.startStream()
    }

}

extension MovieListController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(self.viewModel.movies.count)
        return self.viewModel.movies.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as? MovieCell
        if indexPath.row < viewModel.movies.count {
            cell?.bind(movie: viewModel.movies[indexPath.row])
            return cell ?? UITableViewCell()
        }
        
         return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var movie = viewModel.movies[indexPath.row]
        movie.genreString = self.viewModel.genre.name ?? ""
        let cont = DetailMovieController.initiate(movie: movie)
        self.tableView.deselectRow(at: indexPath, animated: false)
        self.navigationController?.pushViewController(cont, animated: true)
    }
}

extension MovieListController : MovieListViewModelDelegate {
    func onLoading() {
        self.refreshControl.beginRefreshing()
    }
    func onFetchCompleted(with newIndexPathsToReload: [IndexPath]?) {
        self.refreshControl.endRefreshing()
        print("Load \(self.viewModel.movies.count)")
        self.tableView.reloadData()
    }
    func onFetchFailed(with reason: String) {
        print(reason)
        self.refreshControl.endRefreshing()
        let title = "Warning"
        let action = UIAlertAction(title: "OK", style: .default)
        displayAlert(with: title , message: reason, actions: [action])
    }
}

extension MovieListController: UITableViewDataSourcePrefetching {
  func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
    print("Load Next \(indexPaths)")
        if indexPaths.contains(where: isLoadingCell) {
        print("Load Next")
          viewModel.nextStream()
    }
  }
}

private extension MovieListController {
  func isLoadingCell(for indexPath: IndexPath) -> Bool {
    return indexPath.row >= viewModel.currentCount/2
  }

  func visibleIndexPathsToReload(intersecting indexPaths: [IndexPath]) -> [IndexPath] {
    let indexPathsForVisibleRows = tableView.indexPathsForVisibleRows ?? []
    let indexPathsIntersection = Set(indexPathsForVisibleRows).intersection(indexPaths)
    return Array(indexPathsIntersection)
  }
}
