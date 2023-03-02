//
//  SearchMoviesViewController.swift
//  BAZProject
//
//  Created by 1034209 on 01/02/23.
//

import Foundation
import UIKit

protocol SearchMoviesDisplayLogic: AnyObject {
    func displayFetchMovies(viewModel: SearchMovies.FetchMovies.ViewModel)
    func displayResetCollection(viewModel: SearchMovies.ResetSearch.ViewModel)
}

class SearchMoviesViewController: UIViewController {
    
    // MARK: IBOutlet
    @IBOutlet weak var moviesSectionView: UIView!
    
    // MARK: Properties VIP
    var interactor: SearchMoviesInteractor?
    var router: SearchMoviesRoutingLogic?
    
    // MARK: Properties
    lazy var searchBar: UISearchBar? = {
        let view = UISearchBar(frame: .zero)
        view.sizeToFit()
        view.placeholder = "Search"
        return view
    }()
    let manager = CarruselCollectionManager<MovieSearch>()
    let collectionView = CarruselCollectionView(direction: .vertical)
    var carruselCollectionDelegate: CarruselCollectionDelegate?
    
    // MARK: Init
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        addSearchViewInNavigation()
        configureMoviesCollectionView()
        hideKeyboardWhenTappedAround()
        searchBar?.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchBar?.becomeFirstResponder()
    }

    // MARK: Setup
    func setup() {
        let viewController = self
        let interactor = SearchMoviesInteractor()
        let presenter = SearchMoviesPresenter()
        let router = SearchMoviesRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    private func addSearchViewInNavigation() {
        guard let searchBar = searchBar else {
            return
        }
        let rightButton = UIBarButtonItem(customView: searchBar)
        self.navigationItem.rightBarButtonItem = rightButton
    }
    
    private func configureMoviesCollectionView() {
        manager.setupCollection(collection: collectionView, delegate: self)
        
        moviesSectionView.addSubview(collectionView)
        collectionView.leadingAnchor.constraint(equalTo: moviesSectionView.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: moviesSectionView.trailingAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: moviesSectionView.topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: moviesSectionView.bottomAnchor).isActive = true
    }
    
    private func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        searchBar?.endEditing(true)
    }
}

extension SearchMoviesViewController: SearchMoviesDisplayLogic {
    func displayFetchMovies(viewModel: SearchMovies.FetchMovies.ViewModel) {
        if viewModel.displayedMovies.count != 0 {
            manager.dataCollection = viewModel.displayedNextPage ? (manager.dataCollection ?? []) + viewModel.displayedMovies : viewModel.displayedMovies
        }
    }
    
    func displayResetCollection(viewModel: SearchMovies.ResetSearch.ViewModel) {
        manager.dataCollection = viewModel.dataCollection
    }
}

extension SearchMoviesViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        interactor?.searchMoviesBy(request: SearchMovies.FetchMovies.Request(byKeyboards: searchBar.text ?? ""))
        searchBar.endEditing(true)
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            interactor?.resetSearch(request: SearchMovies.ResetSearch.Request())
        }
    }
}

extension SearchMoviesViewController: CarruselCollectionDelegate {
    func didTap(element: CarruselCollectionItemProperties) {
        router?.routeToMovieDetails(movie: element as! MovieSearch)
    }
    
    func displayedLastItem() {
        interactor?.searchMoviesBy(request: SearchMovies.FetchMovies.Request(byKeyboards: searchBar?.text ?? "", nextPage: true))
    }
}