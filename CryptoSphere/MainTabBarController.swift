//
//  MainTabBarController.swift
//  CryptoSphere
//
//  Created by Nurtore on 20.05.2026.
//

import Foundation
import UIKit
import SwiftUI // Обязательно импортируем, чтобы использовать UIHostingController
import ComposableArchitecture

class MainTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground 
        tabBar.tintColor = .systemPurple
        let cryptoListView = UIHostingController(
            rootView: CryptoListView(
                store: Store(initialState: CryptoListFeature.State()) {
                    CryptoListFeature()
                }
            )
        )

        let portfolioView = UIViewController()
        portfolioView.view.backgroundColor = .systemBackground
        
        viewControllers = [
            generateViewController(
                rootViewController: cryptoListView,
                image: UIImage(systemName: "house.fill") ?? UIImage(),
                title: "Home"
            ),
            generateViewController(
                rootViewController: portfolioView,
                image: UIImage(systemName: "chart.pie.fill") ?? UIImage(),
                title: "Portfolio"
            )
        ]
    }

    private func generateViewController(rootViewController: UIViewController, image: UIImage, title: String) -> UIViewController {
        let navigationVC = UINavigationController(rootViewController: rootViewController)
        navigationVC.tabBarItem.image = image
        navigationVC.tabBarItem.title = title
        rootViewController.navigationItem.title = title
        navigationVC.isNavigationBarHidden = true
        return navigationVC
    }
}
