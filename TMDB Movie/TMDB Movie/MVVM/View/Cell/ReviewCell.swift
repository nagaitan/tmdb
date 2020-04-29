//
//  ReviewCell.swift
//  TMDB Movie
//
//  Created by Adi Wibowo on 26/04/20.
//  Copyright © 2020 Adi Wibowo. All rights reserved.
//

import UIKit

class ReviewCell: UITableViewCell {
    @IBOutlet weak var lblReviewTitle: UILabel!
    @IBOutlet weak var lblReviewContent: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    func bind(review : Review){
        lblReviewTitle.text = review.author ?? "-"
        lblReviewContent.text = review.content ?? "-"
    }
    
}
