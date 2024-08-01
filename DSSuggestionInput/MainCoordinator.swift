//
//  MainCoordinator.swift
//  DSSuggestionInput
//
//  Created by Alexandre Bing on 01/08/24.
//

import UIKit

public class MainCoordinator {
    
    let navigator: UINavigationController
    
    public init(navigator: UINavigationController) {
        self.navigator = navigator
    }
    
    public func start() {
        let viewController = ViewController2()
        navigator.pushViewController(viewController, animated: true)
    }
}
