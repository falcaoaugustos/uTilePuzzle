//
//  ViewController.swift
//  uPuzzle
//
//  Created by Augusto Falcão on 2/9/17.
//  Copyright © 2017 Augusto Falcão. All rights reserved.
//

import UIKit

class ViewController: UIViewController, PuzzleManagerProtocol {

    @IBOutlet weak var timerLabel: UILabel!
    
    var timer = Timer()
    var counter = 0

    @IBOutlet weak var clueImage: UIImageView!
    @IBOutlet weak var puzzleName: UILabel!
    
    var levelPuzzle: Int = 0
    var imageName: String?
    var image: UIImage?
    
    @IBOutlet var gameView2: UTPTileBoardView!

    @IBOutlet weak var stepsLbl: UILabel!
    
    lazy var manager: PuzzleManagerObject = { PuzzleManagerObject(parent: self, tileBoardView: self.gameView2, image:self.image!) }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.init(patternImage: UIImage(named: "back-1")!)
        
        manager.delegate = self
        manager.startPuzzle(size: levelPuzzle)
        
        clueImage.image = image
        puzzleName.text = imageName
        
        addGestures()
        
        let (hour, minute, second) = formatTimer(seconds: counter)
        timerLabel.text = String(format: "%02d", hour) + ":" + String(format: "%02d", minute) + ":" + String(format: "%02d", second)

        startTimer()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addGestures() {
        
        let tapRestart = UITapGestureRecognizer(target: self, action: #selector(ViewController.tapRestartHandler(_:)))
        tapRestart.allowedPressTypes = [NSNumber(value: UIPressType.playPause.rawValue)]
        view.addGestureRecognizer(tapRestart)
    }
    
    func tapRestartHandler(_ gestureRecognizer: UITapGestureRecognizer) {
        manager.startPuzzle(size: self.levelPuzzle)
        stopTimer()
        startTimer()
    }
    
    @IBAction func restartPuzzle(_ sender: Any) {
        manager.startPuzzle(size: self.levelPuzzle)
        
        stopTimer()
        startTimer()
    }
    
    // MARK: Timer functions
    
    func updateCounter() {
        counter = counter + 1
        let (hour, minute, second) = formatTimer(seconds: counter)
        self.timerLabel.text = String(format: "%02d", hour) + ":" + String(format: "%02d", minute) + ":" + String(format: "%02d", second)
    }

    func formatTimer(seconds : Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }

    func startTimer() {
        timer.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 1, target:self, selector: #selector(ViewController.updateCounter), userInfo: nil, repeats: true)
    }
    func stopTimer(){
        timer.invalidate()
        counter = 0
        let (hour, minute, second) = formatTimer(seconds: counter)
        timerLabel.text = String(format: "%02d", hour) + ":" + String(format: "%02d", minute) + ":" + String(format: "%02d", second)
    }
    
    // MARK: Puzzle Manager Delegate Method
    
    func changeSteps() {
        stepsLbl.text = "\(manager.steps)"
    }
    
    func timeFinishMessage() -> String {
        let (hour, minute, second) = formatTimer(seconds: counter)
        return String(format: "%02d", hour) + ":" + String(format: "%02d", minute) + ":" + String(format: "%02d", second)
    }
}
