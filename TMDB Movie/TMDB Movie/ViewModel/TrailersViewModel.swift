//
//  TrailersViewModel.swift
//  TMDB Movie
//
//  Created by Adi Wibowo on 26/04/20.
//  Copyright © 2020 Adi Wibowo. All rights reserved.
//
import RxSwift
import SwiftyJSON
import UIKit
import RxCocoa
import RxSwift

import Foundation
protocol TrailersViewModelDelegate: class {
    func onLoading()
    func onFetchCompleted(with newIndexPathsToReload: [IndexPath]?)
    func onFetchFailed(with reason: String)
}

class TrailersViewModel {
    var movie : Movie!
    let api: APIConnector
       let disposeBag = DisposeBag()
       var traillers = [Trailer]()
    
    private let refreshStream = PublishSubject<Void>()
    var delegate : TrailersViewModelDelegate!
    
    
    init(apiConnector: APIConnector = APIConnector.instance) {
        self.api = apiConnector
        setupStream()
    }
    
    func startStream(page : Int = 0){
        refreshStream.onNext(())
    }
    
    func setupStream() {
        refreshStream
            .do(onNext : { _ in
                self.delegate.onLoading()
            })
            .filter{
                return true
            }
            .flatMap { url in
                self.api.getListTraillers(movieId: self.movie.id)
            }
            .do( onNext : { items in
                self.traillers.append(contentsOf: items)
                    self.delegate.onFetchCompleted(with: .none)
            }, onError : {
                errorType in
                self.delegate.onFetchFailed(with: errorType.localizedDescription)
            })
            .subscribe()
            .disposed(by: disposeBag)
    }
    
}
