//
//  AlertUtilities.swift
//  ArtScreen
//
//  Created by Heng on 2020/7/30.
//  Copyright © 2020 Heng. All rights reserved.
//

import UIKit

extension UIView {
    func showNotification(_ imageView : UIImageView) {
        let alert = UIAlertController(title: "Do you want add AR Animation on your ArtWork",message:"If you don't want to add it now, you can click Edit in your profile page",
                                      preferredStyle: UIAlertController.Style.alert)
        let notNowAction = UIAlertAction(title: "Not Now", style: UIAlertAction.Style.default) {
            UIAlertAction in
            NSLog("Not Now Pressed ...")
            let viewController =  DefaultController()
            viewController.imageView = imageView
            self.window?.rootViewController?.present(viewController, animated: true,completion: nil)
            

        }
        
        let doItAction = UIAlertAction(title: "Do It", style: UIAlertAction.Style.cancel) {
            UIAlertAction in
            NSLog("Do It Pressed ...")
            let viewController = AnimateController()
            viewController.imageView = imageView
            self.window?.rootViewController?.present(viewController, animated: true,completion: nil)

        }

        // Add the actions
        alert.addAction(notNowAction)
        alert.addAction(doItAction)
        self.window?.rootViewController?.present(alert, animated: true, completion: nil)
    }
    
    func nextViewControllerWithNavigationController (_ image : UIImage) {

        let origin = CGPoint(x: 0.0, y: 70.0)
        let size = CGSize(width: image.size.width, height: image.size.width)
        let rect = CGRect(origin: origin, size: size)
        let viewController = ConfirmImageController()
        viewController.image.image = trimImage(image: image, area: rect)
        self.window?.rootViewController?.present(viewController, animated: true,completion: nil)
    }
    
    func trimImage(image: UIImage, area: CGRect) -> UIImage? {
        guard let cgImage = image.cgImage else { return nil }
        guard let imageCropping = cgImage.cropping(to: area) else { return nil }
        let trimImage = UIImage(cgImage: imageCropping, scale: image.scale, orientation: image.imageOrientation)

        return trimImage
    }
}

extension UIImage {
    func resized() -> UIImage? {
        let canvasSize = CGSize(width: screenWidth, height: screenWidth)
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        let origin = CGPoint(x: 0, y: 0)
        draw(in: CGRect(origin: origin, size: canvasSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}

