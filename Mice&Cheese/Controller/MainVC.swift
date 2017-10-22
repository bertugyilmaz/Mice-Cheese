//
//  ViewController.swift
//  Mice&Cheese
//
//  Created by Bertuğ YILMAZ on 20/10/2017.
//  Copyright © 2017 Bertuğ YILMAZ. All rights reserved.
//

import UIKit

class MainVC: UIViewController{
    
    var isStart: Bool = false
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var startButton: RoundedButton!
    var mousePosition : Int!
    var selectedWallCounter : Int = 0
    var cheesePosition : Int!
    var isValidPosition : Bool!
    var cell1 : CollectionCell!
    var cell2 : CollectionCell!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureCollectionView()
        
        self.startButton.addTarget(self, action: #selector(self.startButtonAction(_:)), for: .touchUpInside)
        
    }
    
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func startButtonAction(_ sender: UIButton) {
        self.isStart = !isStart
        generateLocationForMouseAndCheese()
        sender.isEnabled = false
    }
    func generateLocationForMouseAndCheese() {
        repeat{
            if selectedWallCounter > 68 {
                break
            }
            isValidPosition = false
            mousePosition = Int(arc4random_uniform(71))
            cheesePosition = Int(arc4random_uniform(71))
            cell1 = self.collectionView!.cellForItem(at:  IndexPath(row: mousePosition,section: 0)) as! CollectionCell
            cell2 = self.collectionView!.cellForItem(at:  IndexPath(row: cheesePosition,section: 0)) as! CollectionCell
            if cell1.isWall || cell2.isWall{
                isValidPosition = false
            }else{
                isValidPosition = true
            }
            print("Onur : mouse \(mousePosition) cheese : \(cheesePosition)")
            print("Onur : Cell1 isWall = \(cell1.isWall) Cell2 isWall = \(cell2.isWall)")
            
        }while(mousePosition == cheesePosition || isValidPosition == false)
        if selectedWallCounter  > 68 {
            let alert = UIAlertController(title: "Trying to Find a Bug ?", message: "You Selected All cells as wall so there is no place for our mouse and cheese 🤡", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Okay, I Understood 😔", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }else{
            cell1.imageView.image = UIImage(named: "Mouse")
            cell2.imageView.image = UIImage(named: "Cheese")
        }
        
    }
    
    func mouseMovement() {
        //birlikte bakalım
    }
    
    
    
  
}

