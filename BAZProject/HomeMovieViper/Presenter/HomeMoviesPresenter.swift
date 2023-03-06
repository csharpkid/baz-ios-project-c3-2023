//
//  HomeMoviesPresenter.swift
//  BAZProject
//
//  Created by 1050210 on 29/01/23.
//
//

import UIKit

class HomeMoviesPresenter: HomeMoviesPresenterProtocol  {
 
    // MARK: Properties
    weak var view: HomeMoviesViewProtocol?
    var interactor: HomeMoviesInteractorInputProtocol?
    var router: HomeMoviesRouterProtocol?
    private let movieApi : MovieAPI = MovieAPI()
    private var indexSelected : Int = 0
    private var firstLoad : Bool = true
    var categoriesMovies: [Movie] = []
    var toShowMovies: [Movie] = []
    var recentViews: [Int] = []

    /// Call the setup observers and get the first consume for the initial view
    func viewDidLoad() {
        setupObserver()
        interactor?.getTrendingMovies()
    }
    
    /// Setup the observers for the recent view movies
    func setupObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(addRecentMovie), name: NSNotification.Name("RecentViewMovie"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(deleteRecentMovie), name: NSNotification.Name("DeleteRecentMovie"), object: nil)
    }
    
    /// Function for the observer to add the recent movie
    ///
    /// - Parameter notification: the notification coming from the observer
    @objc func addRecentMovie(_ notification: Notification) {
        let info = notification.object as? [String:Int]
        if let idMovie = info?["idMovie"], !recentViews.contains(where: { $0 == idMovie }) {
            recentViews.insert(idMovie, at: 0)
        }
    }
    
    /// Function for the observer for delete the RecentMovie
    ///
    /// - Parameter notification: the notification coming from the observer
    @objc func deleteRecentMovie(_ notification: Notification) {
        let info = notification.object as? [String:Int]
        if let idMovie = info?["idMovie"] {
            recentViews.removeAll(where: { $0 == idMovie })
            if recentViews.isEmpty {
                view?.poopToRoot()
            }
        }
    }
    
    /// Get the movie from the toShowMovies  array
    ///
    /// - Parameter index: Int index of the movie to get from the array
    /// - Returns: A Movie struct from the array of toShowMovies
    func getOneMovie(index: Int) -> Movie {
        return self.toShowMovies[index]
    }
    
    /// Returns the toShowMovies  array count
    ///
    /// - Returns: An Int that is the toShowMovies array count
    func getMoviesCount() -> Int {
        return self.toShowMovies.count
    }
    
    /// Get the categorie movie from the categoriesMovies array
    ///
    /// - Parameter index: Int index of the movie to get from the array
    /// - Returns: A Movie struct from the array of categoriesMovies
    func getOneCategorieMovie(index: Int) -> Movie {
        return self.categoriesMovies[index]
    }
    
    /// Returns the categoriesMovies array count, if the categoriesMovies array is more than 1 always return 5
    ///
    /// - Returns: An Int that is the categoriesMovies array count
    func getCategoriesMoviesCount() -> Int {
        if categoriesMovies.count > 1 { return 5 }
        return 0
    }
    
    /// Get an image from the MovieApi class using the index of the movies array and return and UIImage
    ///
    /// - Parameter index: Index of the array movies for get the string url image
    /// - Parameter completion: Escaping closure that escapes a UIImage or a nil
    /// - Returns: escaping closure with the UIImage type, if the parse fails, can return nil
    func getImage(index: Int, completion: @escaping (UIImage?) -> Void) {
        if let urlImage = self.toShowMovies[index].poster_path {
            ImageProvider.shared.getImage(for: urlImage) { movieImage in
                completion(movieImage)
            }
        }
    }
    
    /// Get an image from the ImageProvider singleton using the index of the movies array and return and UIImage
    ///
    /// - Parameter index: Index of the array categoryMovies for get the string url image
    /// - Parameter completion: Escaping closure that escapes a UIImage or a nil
    /// - Returns: escaping closure with the UIImage type, if the parse fails, can return nil
    func getCategorieImage(index: Int, completion: @escaping (UIImage?) -> Void) {
        if let urlImage = self.categoriesMovies[index].backdrop_path {
            ImageProvider.shared.getImage(for: urlImage) { categorieImage in
                completion(categorieImage)
            }
        }
    }
    
    /// Get the category title depending the index of the cell
    ///
    /// - Parameter index: Index of the array categoryMovies for get the string name
    /// - Returns: name of the cell in string format
    func getCategorieTitle(index: Int) -> String {
        switch index {
            case 0:
                return "Trending"
            case 1:
                return "Now Playing"
            case 2:
                return "Popular"
            case 3:
                return "Top rated"
            case 4:
                return "Upcoming"
            default:
                return ""
        }
    }
    
    /// Get the movies filters depending tha index of the cell
    ///
    /// - Parameter index: Index of the array categoryMovies for get the movies type
    func selectFilterMovies(index: Int) {
        if index == indexSelected { return }
        switch index {
            case 0:
                indexSelected = 0
                interactor?.getTrendingMovies()
            case 1:
                indexSelected = 1
                interactor?.getNowPlayingMovies()
            case 2:
                indexSelected = 2
                interactor?.getPopularMovies()
            case 3:
                indexSelected = 3
                interactor?.getTopRatedMovies()
            case 4:
                indexSelected = 4
                interactor?.getUpcomingMovies()
            default:
                break
        }
    }
    
    /// Go to initial the router detailsController and present the view
    ///
    /// - Parameter index: Index of the collectionCell pressed
    func goToDetails(index: Int) {
        if let view = view {
            router?.goToDetails(from: view, idMovie: self.toShowMovies[index].id)
        }
    }
    
    /// Go to initial the router searchController and present the view
    func goToSearch() {
        if let view = view {
            router?.goToSearch(from: view)
        }
    }
    
    /// Go to initial the router recentController and present the view
    func goToRecent() {
        if let view = view, recentViews.count > 0 {
            router?.goToRecent(from: view, idMovies: recentViews)
        } else {
            view?.showNotRecentAlert()
        }
    }
}


extension HomeMoviesPresenter: HomeMoviesInteractorOutputProtocol {
   
    func pushTrendingMovieInfo(trendingMovies: [Movie]) {
        self.toShowMovies = trendingMovies
        view?.loadMovies()
        if firstLoad {
            self.firstLoad = false
            self.categoriesMovies = trendingMovies
            view?.loadTrendingMovies()
        }
    }
    
    func pushNowPlayingMovieInfo(nowPlayingMovies: [Movie]) {
        self.toShowMovies = nowPlayingMovies
        view?.loadMovies()
    }
    
    func pushPopularMovieInfo(popularMovies: [Movie]) {
        self.toShowMovies = popularMovies
        view?.loadMovies()
    }
    
    func pushTopRatedMovieInfo(topRatedMovies: [Movie]) {
        self.toShowMovies = topRatedMovies
        view?.loadMovies()
    }
    
    func pushUpcomingMovieInfo(upcomingMovies: [Movie]) {
        self.toShowMovies = upcomingMovies
        view?.loadMovies()
    }
    
    
}
