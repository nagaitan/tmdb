//
//  BaseInteractor.swift
//  TMDB Movie
//
//  Created by Adi Wibowo on 29/04/20.
//  Copyright © 2020 Adi Wibowo. All rights reserved.
//

import Foundation
import RxSwift

class BaseInteractor {
    
    var disposibles: CompositeDisposable
    
    init() {
        disposibles = CompositeDisposable()
    }
    
    func add(_ d: Disposable?) {
        if (d == nil) { return }
        
        _ = disposibles.insert(d!)
    }
}
