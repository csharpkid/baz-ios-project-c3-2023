//
//  MainTabRouter.swift
//  BAZProject
//
//  Created by 1029187 on 08/02/23.
//

import UIKit

//crear router para gestionar tabbar
class MainTabBarRouter {
    class func createMainTabBarModule() -> UITabBarController {
        let mainTabBar = UITabBarController()
        let trendingView = TrendingRouter.createTrendingModule()
        let topRatedView = TopRatedRouter.createTopRatedModule()
        let searchingViewController = SearchingRouter.createSearchingModule()
        mainTabBar.viewControllers = [trendingView, topRatedView, searchingViewController]
        return mainTabBar
    }
}