//
//  ReviewViewController.swift
//  TMDB Movie
//
//  Created by Adi Wibowo on 26/04/20.
//  Copyright © 2020 Adi Wibowo. All rights reserved.
//

import UIKit

class ReviewViewController: UIViewController, AlertDisplayer {
    @IBOutlet weak var tableView: UITableView!
    let viewModel = ReviewViewModel()
    
    private let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        self.viewModel.delegate = self
        self.viewModel.startStream()
    }
    
    static func initiate(movie : Movie) -> ReviewViewController{
        let cont = ReviewViewController()
        cont.viewModel.movie = movie
        return cont
    }
    
    func setupUI(){
        self.navigationController?.navigationBar.isHidden = false
        self.navigationItem.title = "Review"
        tableView.delegate = self
        tableView.dataSource = self
        tableView.prefetchDataSource = self
        
        tableView.register(UINib(nibName: "ReviewCell", bundle: nil), forCellReuseIdentifier: "ReviewCell")
        
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

extension ReviewViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(self.viewModel.review.count)
        return self.viewModel.review.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewCell", for: indexPath) as? ReviewCell
        if indexPath.row < viewModel.review.count {
            cell?.bind(review: viewModel.review[indexPath.row])
            return cell ?? UITableViewCell()
        }
        
         return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: false)
    }
}

extension ReviewViewController : ReviewViewModelDelegate {
    func onLoading() {
        self.refreshControl.beginRefreshing()
    }
    func onFetchCompleted(with newIndexPathsToReload: [IndexPath]?) {
        self.refreshControl.endRefreshing()
        print("Load \(self.viewModel.review.count)")
        self.tableView.reloadData()
        if self.viewModel.review.count == 0 {
            let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                UIAlertAction in
                self.navigationController?.popViewController(animated: true)
            }
            displayAlert(with: "No Review Found" , message: "", actions: [okAction])
        }
    }
    func onFetchFailed(with reason: String) {
        print(reason)
        self.refreshControl.endRefreshing()
        let title = "Warning"
        let action = UIAlertAction(title: "OK", style: .default)
        displayAlert(with: title , message: reason, actions: [action])
    }
}

extension ReviewViewController: UITableViewDataSourcePrefetching {
  func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
    print("Load Next \(indexPaths)")
        if indexPaths.contains(where: isLoadingCell) {
        print("Load Next")
          viewModel.nextStream()
    }
  }
}

private extension ReviewViewController {
  func isLoadingCell(for indexPath: IndexPath) -> Bool {
    return indexPath.row >= viewModel.currentCount/2
  }

  func visibleIndexPathsToReload(intersecting indexPaths: [IndexPath]) -> [IndexPath] {
    let indexPathsForVisibleRows = tableView.indexPathsForVisibleRows ?? []
    let indexPathsIntersection = Set(indexPathsForVisibleRows).intersection(indexPaths)
    return Array(indexPathsIntersection)
  }
}

