//
//  GenreListController.swift
//  TMDB Movie
//
//  Created by Adi Wibowo on 29/04/20.
//  Copyright © 2020 Adi Wibowo. All rights reserved.
//

import UIKit

class GenreListController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    var presenter: GenreListPresenterInterface?
    var genres: [VGenre] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        presenter?.viewWillDisappear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        presenter?.viewDidDisappear(animated)
    }
    
}

extension GenreListController: GenreListViewInterface {
    func setupUI() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "GenreCell", bundle: nil), forCellReuseIdentifier: "GenreCell")
        setupTableView(tableView: tableView)
        refreshControl.beginRefreshing()
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
       
    }
    
    func showGenres(with genres: [VGenre]) {
        refreshControl.endRefreshing()
        self.genres = genres
        print("GetGenres \(self.genres)")
        self.tableView.reloadData()
    }
    
    @objc private func refreshData(_ sender: Any) {
        presenter?.loadGenres()
    }
    
}

extension GenreListController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return genres.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GenreCell", for: indexPath) as? GenreCell
        cell?.bind(genre: genres[indexPath.row])
        
        return cell ?? UITableViewCell()
    }

}
