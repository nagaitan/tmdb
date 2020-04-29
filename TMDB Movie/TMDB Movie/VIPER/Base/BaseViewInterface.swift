//
//  BaseViewInterface.swift
//  TMDB Movie
//
//  Created by Adi Wibowo on 29/04/20.
//  Copyright © 2020 Adi Wibowo. All rights reserved.
//


import Foundation
import UIKit

protocol BaseViewInterface {
    
    func setupUI()
    func setupTableView(tableView: UITableView)
    func onError(message: String)
}

protocol BasePresenterInterface {
    
    func viewDidLoad()
    func viewDidDisappear(_ animated: Bool)
    func viewWillAppear(_ animated: Bool)
    func viewWillDisappear(_ animated: Bool)
}

protocol BaseInteractorInterface {
    
    func outputDidLoad()
    func outputFinished()
}

protocol BaseWireframeInterface {
    
    var viewController: UIViewController? { get set }
}

