//
//  ViewController.swift
//  TMDB Movie
//
//  Created by Adi Wibowo on 26/04/20.
//  Copyright © 2020 Adi Wibowo. All rights reserved.
//

import UIKit

class GenresController: UIViewController, AlertDisplayer {
    @IBOutlet weak var tableView: UITableView!
    let viewModel = GenresViewModel()
    private let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        viewModel.delegate = self
        viewModel.startStream()
    }
    
    func setupUI(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "GenreCell", bundle: nil), forCellReuseIdentifier: "GenreCell")
        
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl)
        }
    }
    
    @objc private func refreshData(_ sender: Any) {
        viewModel.startStream()
    }


}

extension GenresController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return viewModel.getGenresCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GenreCell", for: indexPath) as? GenreCell
        cell?.bind(genre: viewModel.genres[indexPath.row])
        
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cont = MovieListController.initiate(genre: viewModel.genres[indexPath.row])
        
        self.navigationController?.pushViewController(cont, animated: true)
    }
}

extension GenresController : GenresViewModelDelegate {
    func onLoading() {
        
    }
    func onFetchCompleted(with newIndexPathsToReload: [IndexPath]?) {
        print(viewModel.getGenresCount())
        self.tableView.reloadData()
    }
    func onFetchFailed(with reason: String) {
        print(reason)
        let title = "Warning"
        let action = UIAlertAction(title: "OK", style: .default)
        displayAlert(with: title , message: reason, actions: [action])
    }
}

