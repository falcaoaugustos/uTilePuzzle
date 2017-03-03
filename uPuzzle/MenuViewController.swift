//
//  MenuViewController.swift
//  uPuzzle
//
//  Created by Daniel Dias on 02/03/17.
//  Copyright © 2017 Augusto Falcão. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var tablePuzzle: UITableView!
    @IBOutlet weak var puzzleImage: UIImageView!
    //@IBOutlet weak var titlePuzzle: UILabel!
    
    
    var puzzles:[String] = ["pug","nature","carnival"]
    var gameImageName: String?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.tablePuzzle.delegate = self
        self.tablePuzzle.dataSource = self
        
        self.puzzleImage.layer.borderColor = UIColor.white.cgColor
        self.puzzleImage.layer.borderWidth = 14.0
        
        
        //self.puzzleImage.layer.shadowColor = UIColor.black.cgColor
        //self.puzzleImage.layer.shadowOpacity = 1
        //self.puzzleImage.layer.shadowOffset = CGSize(width: -10, height: 1)
       // self.puzzleImage.layer.shadowRadius = 10
        
        self.tablePuzzle.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "segue") {
            
            let nextViewController:ViewController = segue.destination as! ViewController
            let image = UIImage(named: self.gameImageName!)
            nextViewController.image = image
            nextViewController.imageName = self.gameImageName!
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.puzzles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell:UITableViewCell = self.tablePuzzle.dequeueReusableCell(withIdentifier: "cell")! as UITableViewCell
        //cell.backgroundColor = UIColor(red: 51.0/255.0, green: 63.0/255.0, blue: 95.0/255.0, alpha: 0.8)
        
        
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.text = self.puzzles[indexPath.row]
        //cell.textLabel?.textColor = UIColor.white
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didUpdateFocusIn context: UITableViewFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        let nextIndexPath = context.nextFocusedIndexPath
        if let index = nextIndexPath?.row{
        self.puzzleImage.image = UIImage(named: self.puzzles[index])
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.gameImageName = self.puzzles[indexPath.row]
        performSegue(withIdentifier: "segue", sender: self)
    }
    
}
