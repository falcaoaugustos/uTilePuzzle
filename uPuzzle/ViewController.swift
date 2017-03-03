//
//  ViewController.swift
//  uPuzzle
//
//  Created by Augusto Falcão on 2/9/17.
//  Copyright © 2017 Augusto Falcão. All rights reserved.
//

import UIKit

class ViewController: UIViewController, PuzzleManagerProtocol {
   
    // counter
    @IBOutlet weak var timerLabel: UILabel!
    
    var timer = Timer()
    var counter = 0
    
    //images
    @IBOutlet weak var clueImage: UIImageView!
    @IBOutlet weak var puzzleName: UILabel!
    

   //-------------------------------------------
    var imageName: String? = "pug"
    var image: UIImage? = UIImage(named: "pug")
    
    @IBOutlet weak var gameView2: IXNTileBoardView!
        
    @IBOutlet weak var stepsLbl: UILabel!
    
    lazy var manager: PuzzleManagerObject = { PuzzleManagerObject(parent: self, tileBoardView: self.gameView2, image:self.image!) }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //self.gameView.tou
        self.manager.delegate = self
        self.manager.startPuzzle()
        
        self.clueImage.image = self.image
        self.puzzleName.text = self.imageName
        
        self.addGestures()
        
        //ajustando timer
        let (h,m,s) = formatTimer(seconds: self.counter)
        self.timerLabel.text = String(format: "%02d", h) + ":" + String(format: "%02d", m) + ":" + String(format: "%02d", s)
        //--------------
        //iniciando timer
        self.startTimer()
        //-------------
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addGestures() {
        
        let tapRestart = UITapGestureRecognizer(target: self, action: #selector(ViewController.tapRestartHandler(_:)))
        tapRestart.allowedPressTypes = [NSNumber(value: UIPressType.playPause.rawValue)]
        self.view.addGestureRecognizer(tapRestart)
    }
    
    func tapRestartHandler(_ gestureRecognizer: UITapGestureRecognizer) {
        self.manager.startPuzzle()
        self.stopTimer()
        self.startTimer()
    }
    
    @IBAction func restartPuzzle(_ sender: Any) {
        self.manager.startPuzzle()
        
        //zera o timer
        self.stopTimer()
        //inicia o timer novamente
        self.startTimer()
        //-------------------------
        
    }
    
    // pragma mark - Timer functions
    
    //essa função é cahmada quando o timer gera um evento
    
    
    func updateCounter() {
        self.counter = self.counter+1
        let (h,m,s) = formatTimer(seconds: self.counter)
        self.timerLabel.text = String(format: "%02d", h) + ":" + String(format: "%02d", m) + ":" + String(format: "%02d", s)
    }
    //formata a label em hh:mm:ss
    func formatTimer(seconds : Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    func startTimer(){
        timer.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 1, target:self, selector: #selector(ViewController.updateCounter), userInfo: nil, repeats: true)
    }
    func stopTimer(){
        self.timer.invalidate()
        self.counter = 0
        let (h,m,s) = formatTimer(seconds: self.counter)
        self.timerLabel.text = String(format: "%02d", h) + ":" + String(format: "%02d", m) + ":" + String(format: "%02d", s)
    }
    
    // pragma mark - Puzzle Manager Delegate Method
    
    func changeSteps() {
        stepsLbl.text = "\(manager.steps)"
    }

    
}

