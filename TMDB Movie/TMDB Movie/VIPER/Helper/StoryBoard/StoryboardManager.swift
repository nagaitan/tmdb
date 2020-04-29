//
//  StoryboardManager.swift
//  TMDB Movie
//
//  Created by Adi Wibowo on 29/04/20.
//  Copyright © 2020 Adi Wibowo. All rights reserved.
//


import UIKit

class StoryboardManager: NSObject {
    
    static let instance = StoryboardManager()
    
    let genreList: UIStoryboard
    
    override init() {
        genreList = UIStoryboard(name: "GenreList", bundle: nil)
        
        super.init()
    }
}

