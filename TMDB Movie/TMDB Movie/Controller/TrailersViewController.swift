//
//  TrailersViewController.swift
//  TMDB Movie
//
//  Created by Adi Wibowo on 26/04/20.
//  Copyright © 2020 Adi Wibowo. All rights reserved.
//

import UIKit
import AVKit
import WebKit

class TrailersViewController: UIViewController, AlertDisplayer {
    @IBOutlet weak var tableView: UITableView!
    let viewModel = TrailersViewModel()
    private let refreshControl = UIRefreshControl()
    var mywkwebview: WKWebView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        self.viewModel.delegate = self
        self.viewModel.startStream()
    }
    
    static func initiate(movie : Movie) -> TrailersViewController{
         let cont = TrailersViewController()
         cont.viewModel.movie = movie
         return cont
     }
    
    func setupUI(){
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: "TraillerCell", bundle: nil), forCellReuseIdentifier: "TraillerCell")
        
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



extension TrailersViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(self.viewModel.traillers.count)
        return self.viewModel.traillers.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TraillerCell", for: indexPath) as? TraillerCell
        if indexPath.row < viewModel.traillers.count {
            
            cell?.bind(movie: self.viewModel.movie, trailler: self.viewModel.traillers[indexPath.row])
            
            return cell ?? UITableViewCell()
        }
        
         return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: false)
        presentTrailler(url: self.viewModel.traillers[indexPath.row].keyURl ?? "")
    }
    
    func presentTrailler(url : String){
        print("https://www.youtube.com/watch?v=\(url)")
        
        let mywkwebviewConfig = WKWebViewConfiguration()

        mywkwebviewConfig.allowsInlineMediaPlayback = true
        mywkwebview = WKWebView(frame: self.view.frame, configuration: mywkwebviewConfig)

        let myURL = URL(string: "https://www.youtube.com/embed/\(url)?playsinline=1?autoplay=1")
        let youtubeRequest = URLRequest(url: myURL!)

        mywkwebview?.load(youtubeRequest)
        mywkwebview?.navigationDelegate = self
        self.view.addSubview(mywkwebview!)
        self.view.bringSubviewToFront(mywkwebview!)
        
    }
    
    @objc func buttonAction(sender: UIButton!, web : WKWebView) {
      print("Button tapped")
        self.mywkwebview?.removeFromSuperview()
    }
    
}


extension TrailersViewController : TrailersViewModelDelegate {
    func onLoading() {
        self.refreshControl.beginRefreshing()
    }
    func onFetchCompleted(with newIndexPathsToReload: [IndexPath]?) {
        self.refreshControl.endRefreshing()
        print("Load \(self.viewModel.traillers.count)")
        self.tableView.reloadData()
        // Create the actions
        if self.viewModel.traillers.count == 0 {
            let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                UIAlertAction in
                self.navigationController?.popViewController(animated: true)
            }
            displayAlert(with: "No Trailer Found" , message: "", actions: [okAction])
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

extension TrailersViewController : WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        let button = UIButton(frame: CGRect(x: 0, y: self.view.frame.height - 150, width: self.view.frame.width, height: 50))
        button.backgroundColor = .darkGray
        button.setTitle("Close Trailer", for: .normal)
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        
        mywkwebview?.addSubview(button)
        mywkwebview?.bringSubviewToFront(button)
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
            UIAlertAction in
            self.mywkwebview?.removeFromSuperview()
        }
        displayAlert(with: "Cannot Load" , message: "", actions: [okAction])
    }
}
