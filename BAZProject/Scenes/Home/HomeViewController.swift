//
//  HomeViewController.swift
//  BAZProject
//
//  Created by 1034209 on 01/02/23.
//

import Foundation
import UIKit

protocol HomeDisplayLogic: AnyObject {
    // TODO: create functions to manage display logic
}

class HomeViewController: UIViewController {
    
    // MARK: Properties VIP
    var interactor: HomeBusinessLogic?
    var router: (HomeRoutingLogic & HomeDataPassing)?
    
    // MARK: Init
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    // MARK: Setup
    func setup() {
        // TODO: setup VIP Module
    }
    
    override func viewDidLoad() {
        MoviesAPI().fetchMovies(type: .byKeyword("Jojo")) { movies, error in
            print(movies)
        }
        
        MoviesAPI().fetchReviews(id: 603) { reviews, error in
            print(reviews)
        }
    }
}

extension HomeViewController: HomeDisplayLogic {
    // TODO: conform HomeDisplayLogic protocol
}
