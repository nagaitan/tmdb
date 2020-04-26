//
//  GenreCell.swift
//  TMDB Movie
//
//  Created by Adi Wibowo on 26/04/20.
//  Copyright © 2020 Adi Wibowo. All rights reserved.
//

import UIKit

class GenreCell: UITableViewCell {
    @IBOutlet weak var lblTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func bind(genre : Genre) {
        if let name = genre.name {
            lblTitle.text = name
        }
    }
    
}
