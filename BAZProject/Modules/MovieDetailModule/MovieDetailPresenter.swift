//
//  MovieDetailPresenter.swift
//  BAZProject
//
//  Created by Leobardo Gama Muñoz on 02/02/23.
//

import UIKit

class MovieDetailPresenter: NSObject {
    weak var view: MovieDetailViewProtocol?
    var interactor: MovieDetailInterceptorInputProtocol?
}

extension MovieDetailPresenter: MovieDetailPresenterProtocol {
    func viewDidLoad(textOverview: inout UILabel) {
        if let idMovie = interactor?.data?.id {
            interactor?.movieApiData.getArrayDataMovie = [
                                                            .creditMovie(movieId: "\(idMovie)"): nil,
                                                            .similar(movieId: "\(idMovie)"): nil,
                                                            .recommendations(movieId: "\(idMovie)"): nil,
                                                            .reviews(movieId: "\(idMovie)"): nil
                                                            ]
        } else { debugPrint("idMovie not found") }
        textOverview.text = interactor?.data?.overview
        getUI()
    }
    
    func getUI() {
        if let data = interactor?.data, let image = data.posterPath{
            MovieAPI.getImage(from: image , handler: { image in
                self.view?.poster.image = image
            })
        }
    }
    
    func getMoviesData(from api: URLApi){
        
    }
    
    func getTableViewDataSource() -> UITableViewDataSource {
        return self
    }
    
    func getTableViewDelegate() -> UITableViewDelegate {
        return self
    }
}

extension MovieDetailPresenter: MovieDetailInteractorOutputProtocol {
    func reloadData() {
        view?.reloadData()
    }
}

extension MovieDetailPresenter: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let rows = interactor?.movieApiData.getArrayDataMovie?.count else { return 0 }
        return rows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}

extension MovieDetailPresenter: UITableViewDelegate {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Reparto de actores:"
        case 1:
            return "Peliculas Similares:"
        case 2:
            return "Peliculas Recomendadas:"
        case 3:
            return "Reseñas de Pelicula:"
        default:
            return "Peliculas Similares"
        }
    }
}
