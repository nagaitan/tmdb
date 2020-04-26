//
//  MovieCell.swift
//  TMDB Movie
//
//  Created by Adi Wibowo on 26/04/20.
//  Copyright © 2020 Adi Wibowo. All rights reserved.
//

import UIKit
import AlamofireImage

class MovieCell: UITableViewCell {
    @IBOutlet weak var imgMovie: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblGenreName: UILabel!
    @IBOutlet weak var lblGenreRelease: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func bind(movie : Movie) {
        lblName.text = movie.title ?? ""
        lblGenreName.text = "\(movie.vote_average)"
        lblGenreRelease.text = movie.release_date ?? "-"
        if let urlImage = movie.poster_path, let url = NSURL(string: APIConnector.urlImage + urlImage){
            imgMovie.af_setImage(withURL: url as URL, placeholderImage: nil, filter: nil, progress: nil, imageTransition: .crossDissolve(0.3), runImageTransitionIfCached: true, completion: nil)
        }
    }
    
}
