//
//  WatchedMovieProtocols.swift
//  BAZProject
//
//  Created by Leobardo Gama Muñoz on 18/02/23.
//

import UIKit

protocol WatchedMovieViewProtocols: AnyObject {
    var presenter: WatchedMoviePresenterProtocols? { get set }
    
    func reloadData()
}

protocol WatchedMoviePresenterProtocols: AnyObject {
    var view: WatchedMovieViewProtocols? { get set }
    var interactor: WatchedMovieInteractorInputProtocols? { get set }
    
    func viewDidLoad(tableView: UITableView)
    func getWatchedMovies()
    func getTableViewDataSource() -> UITableViewDataSource
    func getTableViewDelegate() -> UITableViewDelegate
}

protocol WatchedMovieInteractorInputProtocols: AnyObject {
    var presenter: WatchedMovieInteractorOutputProtocols? { get set }
    var getDataMovies: [Movie]? { get set }

    func getWatchedMovies(from api: URLApi)
    func setIdMovies()
}

protocol WatchedMovieInteractorOutputProtocols: AnyObject {
    
}