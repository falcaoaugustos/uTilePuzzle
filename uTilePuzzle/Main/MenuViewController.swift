//
//  MenuViewController.swift
//  uPuzzle
//
//  Created by Daniel Dias on 02/03/17.
//  Copyright © 2017 Augusto Falcão. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tablePuzzle: UITableView!
    @IBOutlet weak var puzzleImage: UIImageView!
    @IBOutlet weak var levelSelector: UISegmentedControl!    
    
    var puzzles: [String] = ["Airplane","Autumn","Bridge","Carnival","Dog","Flowers","Nature","Peacock","Valley","Winter"]
    var gameImageName: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tablePuzzle.delegate = self
        tablePuzzle.dataSource = self
        
        puzzleImage.layer.borderColor = UIColor.white.cgColor
        puzzleImage.layer.borderWidth = 14.0
        
        view.backgroundColor = UIColor.init(patternImage: UIImage(named: "back-1")!)
        
        levelSelector.setTitleTextAttributes(
            [NSForegroundColorAttributeName : UIColor.white], for: UIControlState.selected)
        levelSelector.setTitleTextAttributes([NSForegroundColorAttributeName : UIColor.init(red: 0.7, green: 0.7, blue: 0.7, alpha: 1.0)], for: UIControlState.normal)
        
        tablePuzzle.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "segue") {
            let nextViewController = segue.destination as! GameViewController
            let image = UIImage(named: gameImageName)
            nextViewController.image = image
            nextViewController.imageName = gameImageName
            nextViewController.levelPuzzle = levelSelector.selectedSegmentIndex + 3
        }
    }
    
    // MARK: TableView Delegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return puzzles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = self.tablePuzzle.dequeueReusableCell(withIdentifier: "cell")! as UITableViewCell

        cell.textLabel?.textColor = UIColor.black
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.text = puzzles[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didUpdateFocusIn context: UITableViewFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        let nextIndexPath = context.nextFocusedIndexPath
        if let index = nextIndexPath?.row {
            puzzleImage.image = UIImage(named: puzzles[index])
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        gameImageName = puzzles[indexPath.row]
        performSegue(withIdentifier: "segue", sender: self)
    }
    
    // MARK: UIFocusEnvironment Delegate
    
    override var preferredFocusEnvironments: [UIFocusEnvironment] {
        return [self.tablePuzzle]
    }
}
