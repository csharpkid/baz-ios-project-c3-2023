//
//  DetailPresenter.swift
//  BAZProject
//
//  Created by 1058889 on 14/02/23.
//

import Foundation

final class DetailPresenter {
    var router: DetailRouterProtocol?
    weak var view: DetailViewProtocol?
    var interactor: DetailInteractorInputProtocol?

    private var numberCalls: Int = .zero
    private var errorGetData: Bool = false

    // MARK: - Private methods
    private func stopLoading() {
        view?.setErrorGettingData(false)
        errorGetData = false
        popCallService()
    }

    private func addCallService() {
        numberCalls += LocalizedConstants.commonIncrementNumber
    }

    private func popCallService() {
        numberCalls -= LocalizedConstants.commonIncrementNumber
        if numberCalls != .zero { return }
        view?.stopLoading()
    }
}

extension DetailPresenter: DetailPresenterProtocol {
    func willFetchMedia(detailType: DetailType) {
        interactor?.fetchMedia(detailType: detailType)
        addCallService()
    }

    func willFetchReview(of idMovie: String) {
        interactor?.fetchReview(of: idMovie)
        addCallService()
    }
}

extension DetailPresenter: DetailInteractorOutputProtocol {
    func onReceivedMedia(result: MovieDetailResult) {
        view?.updateView(data: result)
        stopLoading()
    }

    func onReceivedReview(_ result: [ReviewResult]) {
        view?.updateView(data: result)
        stopLoading()
    }

    func showViewError(_ error: Error) {
        if errorGetData { return }
        errorGetData = true
        var errorModel: ErrorType
        if let fetchedError: ServiceError = error as? ServiceError {
            errorModel = ErrorType(serviceError: fetchedError)
        } else {
            errorModel = ErrorType(title: error.localizedDescription,
                                   message: "Error code: \(error._code) - \(error._domain)")
        }

        errorModel.setTitleNavBar(.trendingTitle)
        view?.setErrorGettingData(true)
        router?.showViewError(errorModel)
    }
}