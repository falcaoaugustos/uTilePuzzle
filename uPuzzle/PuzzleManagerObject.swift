//
//  PuzzleManagerObject.swift
//  bridgingHeaderTest
//
//  Created by Augusto Falcão on 2/12/17.
//  Copyright © 2017 Augusto Falcão. All rights reserved.
//

import Foundation

protocol PuzzleManagerProtocol {
    func changeSteps()
}

class PuzzleManagerObject: NSObject, IXNTileBoardViewDelegate {
    
    var delegate: PuzzleManagerProtocol? = nil
    
    var gameView: IXNTileBoardView!
    var clueView: UIImageView!
    
    var parentViewController: UIViewController!
    
    let boardImage: UIImage! = UIImage(named: "pug.jpg")
    let boardSize = 3
    
    let AnimationSpeed: TimeInterval! = 0.05
    
    var startTime: TimeInterval! = 0
    var currentTime: TimeInterval! = 0
    var steps = 0 {
        didSet {
            self.delegate?.changeSteps()
        }
    }
    
    init(parent: UIViewController, tileBoardView: IXNTileBoardView) {
        super.init()
        parentViewController = parent
        gameView = tileBoardView
        gameView.delegate = self
    }
    
    func startPuzzle() {
        
        hideImage()
        gameView.play(with: boardImage, size: boardSize)
        gameView.shuffleTimes(100)
        steps = 0
    }
    
    func originalImageView() -> UIImageView {
        
        let originalImage = UIImageView(image: boardImage)
        
        originalImage.frame = gameView.frame;
        originalImage.alpha = 0.0;
        
        originalImage.layer.shadowColor = UIColor.black.cgColor
        originalImage.layer.shadowOpacity = 0.65
        originalImage.layer.shadowRadius = 1.5
        originalImage.layer.shadowOffset = CGSize(width: 1.5, height: 1.5)
        originalImage.layer.shadowPath = UIBezierPath(rect: originalImage.layer.bounds).cgPath
        
        return originalImage
    }
    
    func showImage() {
        
        clueView = originalImageView()
        
        parentViewController.view.addSubview(clueView)
        
        UIView.animate(withDuration: AnimationSpeed) {
            self.clueView.alpha = 1.0
            self.gameView.alpha = 0.0
        }
    }
    
    func hideImage() {
        
        if clueView == nil {
            return
        }
            
        UIView.animate(withDuration: AnimationSpeed, animations: {
                self.clueView.alpha = 0.0
                self.gameView.alpha = 1.0
                self.clueView.removeFromSuperview()
                self.clueView = nil
            })
    }
    
    func finishMessage() {
        
        let message = "You've completed a \(boardSize) x \(boardSize) puzzle with \(steps) steps. Press restart button to play again."
        let alert = UIAlertController(title: "Congratulations!", message: message, preferredStyle: .actionSheet) // study best style
        
        alert.addAction(UIAlertAction(title: "Menu", style: .default, handler: { (handler) in
            self.parentViewController.dismiss(animated: false, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "Restart", style: .default, handler: { (handler) in
            self.startPuzzle()
        }))
        
        parentViewController.present(alert, animated: false, completion: nil)
    }
    
    // pragma mark - Tile Board Delegate Method
    
    func tileBoardView(_ tileBoardView: IXNTileBoardView!, tileDidMove position: CGPoint) {
                
        steps = steps + 1
    }
    
    func tileBoardViewDidFinished(_ tileBoardView: IXNTileBoardView!) {
        
        showImage()
        finishMessage()
    }
    
}
