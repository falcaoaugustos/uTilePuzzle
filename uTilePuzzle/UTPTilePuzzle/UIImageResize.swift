//
//  UIImageResize.swift
//  uTilePuzzle
//
//  Created by Augusto Falcão on 9/22/17.
//  Copyright © 2017 Augusto Falcão. All rights reserved.
//

import Foundation

/*
extension UIImage {
    func resizedImage(with size: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        let sourceImage = self.cgImage?.copy()
        var newImage = UIImage(cgImage: sourceImage!, scale: 0.0, orientation: self.imageOrientation)
        newImage.draw(in: CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height))
        newImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }

    func kGetScale() -> CGFloat {
        return 1.0
    }

    func cropImageFromFrame(frame: CGRect) -> UIImage {
        let destFrame = CGRect(x: 0.0, y: 0.0, width: frame.size.width, height: frame.size.height)

        var scale: CGFloat = 1.0

        if UIScreen.main.responds(to: #selector(kGetScale)) {
            scale = UIScreen.main.scale
        }

        let sourceFrame = CGRect(x: frame.origin.x * scale, y: frame.origin.y * scale, width: frame.size.width * scale, height: frame.size.height * scale)

        UIGraphicsBeginImageContextWithOptions(destFrame.size, false, 0.0)
        let sourceImage = self.cgImage?.cropping(to: sourceFrame)
        var newImage = UIImage(cgImage: sourceImage!, scale: 0.0, orientation: self.imageOrientation)
        newImage.draw(in: destFrame)
        newImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
}
*/
