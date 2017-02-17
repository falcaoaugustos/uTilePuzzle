//
//  ViewController.swift
//  uPuzzle
//
//  Created by Augusto Falcão on 2/9/17.
//  Copyright © 2017 Augusto Falcão. All rights reserved.
//

import UIKit

class ViewController: UIViewController, PuzzleManagerProtocol {
    
    @IBOutlet weak var gameView2: IXNTileBoardView!
        
    @IBOutlet weak var stepsLbl: UILabel!
    
    lazy var manager: PuzzleManagerObject = { PuzzleManagerObject(parent: self, tileBoardView: self.gameView2) }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //self.gameView.tou
        self.manager.delegate = self
        self.manager.startPuzzle()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func restartPuzzle(_ sender: Any) {
        self.manager.startPuzzle()
    }
    
    // pragma mark - Puzzle Manager Delegate Method
    
    func changeSteps() {
        stepsLbl.text = "\(manager.steps)"
    }

}

