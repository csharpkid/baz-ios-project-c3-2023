//
//  HomeModels.swift
//  BAZProject
//
//  Created by 1034209 on 15/02/23.
//

import Foundation
import UIKit

enum Home {
    enum FetchMoviesBySection {
        struct Request {
            var section: fetchMoviesTypes
        }
        struct Response {
            var section: fetchMoviesTypes
            var movies: [Movie]
            var numberOfMoviesToShow: Int
        }
        struct Error {
            var message: String
        }
        struct ViewModel {
            struct SectionWithMovies {
                var view: MoviesSectionView
                var movies: [MovieSearch]
            }
            var displayedMovies: SectionWithMovies
        }
    }
    
    enum GetMoviesSection {
        struct Response {
            var sections: [fetchMoviesTypes]
        }
        struct ViewModel {
            var displayedSections: [fetchMoviesTypes]
        }
    }
}
