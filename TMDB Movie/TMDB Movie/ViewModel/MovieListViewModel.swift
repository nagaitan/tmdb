//
//  MovieListViewModel.swift
//  TMDB Movie
//
//  Created by Adi Wibowo on 26/04/20.
//  Copyright © 2020 Adi Wibowo. All rights reserved.
//

protocol MovieListViewModelDelegate: class {
    func onLoading()
    func onFetchCompleted(with newIndexPathsToReload: [IndexPath]?)
    func onFetchFailed(with reason: String)
}

import RxSwift
import SwiftyJSON
import UIKit
import RxCocoa
import RxSwift

class MovieListViewModel{
    var genre : Genre!
    let api: APIConnector
    let disposeBag = DisposeBag()
    var movies = [Movie]()
    private let refreshStream = PublishSubject<Void>()
    private var currentPage = 1
    private var totalPage = 0
    var delegate : MovieListViewModelDelegate!
    var isClear = false
    
    init(apiConnector: APIConnector = APIConnector.instance) {
        self.api = apiConnector
        setupStream()
    }
    
    func startStream(){
        refreshStream.onNext(())
    }
    
    func nextStream() {
        currentPage += 1
        if currentPage <= totalPage {
            refreshStream.onNext(())
        }
    }
    
    func setupStream() {
        refreshStream
            .do(onNext : { _ in
                self.delegate.onLoading()
                if self.isClear {
                    self.movies.removeAll()
                    self.currentPage = 1
                    self.totalPage = 0
                    self.isClear = false
                }
            })
            .filter{
                return true
            }
            .flatMap { url in
                self.api.getListMovie(genre_id: self.genre.id, page: self.currentPage)
            }
            .do( onNext : { items in
                self.movies.append(contentsOf: items.0)
                    
                self.delegate.onFetchCompleted(with: .none)
                
                self.currentPage = items.1
                
                self.totalPage = items.2
                
            }, onError : {
                errorType in
                self.delegate.onFetchFailed(with: errorType.localizedDescription)
            })
            .subscribe()
            .disposed(by: disposeBag)
    }
    
    var currentCount: Int {
      return movies.count
    }
    
}
