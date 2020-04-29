//
//  DefaultError.swift
//  TMDB Movie
//
//  Created by Adi Wibowo on 29/04/20.
//  Copyright © 2020 Adi Wibowo. All rights reserved.
//

import Foundation

class DefaultError: Error {
    
    var err: String!
    
    init(_err: String) {
        self.err = _err
    }
}
