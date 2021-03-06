//
//  PhotoDetailDragCoordinator.swift
//  EfimerumTestGrid
//
//  Created by Charles Moncada on 08/02/17.
//  Copyright © 2017 Charles Moncada. All rights reserved.
//

import UIKit

final class PhotoDetailDragCoordinator: Coordinator {
    
    private unowned let navigationController: UINavigationController
    private let viewController: PhotoDetailDragViewController
    private let model : PhotoWallModelType
    
    var startIndex: Int = 0
    
    init(navigationController: UINavigationController, model: PhotoWallModelType, startIndex: Int) {
        self.navigationController = navigationController
        self.startIndex = startIndex
        self.model = model
        self.viewController = PhotoDetailDragViewController(model: model, startIndex: startIndex)
        
        super.init()
        
        viewController.didFinish = { [weak self] in
            guard let `self` = self else {
                return
            }
            
            // This will remove the coordinator from its parent
            self.didFinish()
        }
        
        viewController.didAskPhotoInfo = { [weak self] photo in
            guard let strongSelf = self else {
                return
            }
            
            let coordinator = PhotoDetailInfoCoordinator(navigationController: navigationController, photo: photo)
            
            strongSelf.add(child: coordinator)
            
            coordinator.start()
            
        }
        
        viewController.needAuthLogin = { [weak self] identifier, location in
            guard let strongSelf = self else {
                return
            }
            
            let coordinator = LoginCoordinator(navigationController: navigationController)
            strongSelf.add(child: coordinator)
            
            coordinator.action = {
                strongSelf.viewController.output.likeToPhotoWithIdentifier(identifier, location: location)
            }
            
            coordinator.start()
        }
    }
    
    override func start() {
        viewController.definesPresentationContext = true
        navigationController.pushViewController(viewController, animated: true)
    }
    
}
