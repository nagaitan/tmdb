//
//  DetailMovieController.swift
//  TMDB Movie
//
//  Created by Adi Wibowo on 26/04/20.
//  Copyright © 2020 Adi Wibowo. All rights reserved.
//

import UIKit

class DetailMovieController: UIViewController {
    @IBOutlet weak var imgBackground: UIImageView!
    @IBOutlet weak var imgPoster: UIImageView!
    let viewModel = DetailViewModel()
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblGenre: UILabel!
    @IBOutlet weak var lblRelease: UILabel!
    @IBOutlet weak var lblOverview: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    static func initiate(movie : Movie) -> DetailMovieController{
        let cont = DetailMovieController()
        cont.viewModel.movie = movie
        
        return cont
    }
    @IBAction func goBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func goReview(_ sender: Any) {
        print("GoReview")
        let cont = ReviewViewController.initiate(movie: self.viewModel.movie)
        
        self.navigationController?.pushViewController(cont, animated: true)
    }
    
    @IBAction func goTrailer(_ sender: Any) {
        print("GoTrailer")
        let cont = TrailersViewController.initiate(movie: self.viewModel.movie)
        
        self.navigationController?.pushViewController(cont, animated: true)
    }
    
    func setupUI() {
        self.navigationItem.title = "Detail"
        lblTitle.text = viewModel.movie.title ?? "-"
        lblGenre.text = viewModel.movie.genreString ?? "-"
        lblRelease.text = viewModel.movie.release_date
        lblOverview.text = viewModel.movie.overview ?? ""
        
        if let urlImage = viewModel.movie.poster_path, let url = NSURL(string: APIConnector.urlImage + urlImage){
            imgPoster.af_setImage(withURL: url as URL, placeholderImage: nil, filter: nil, progress: nil, imageTransition: .crossDissolve(0.3), runImageTransitionIfCached: true, completion: nil)
        }
        
        if let urlImage = viewModel.movie.backdrop_path, let url = NSURL(string: APIConnector.urlImage + urlImage){
            imgBackground.af_setImage(withURL: url as URL, placeholderImage: nil, filter: nil, progress: nil, imageTransition: .crossDissolve(0.3), runImageTransitionIfCached: true, completion: nil)
        }
        
        
    }

}
