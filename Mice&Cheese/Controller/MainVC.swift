//
//  ViewController.swift
//  Mice&Cheese
//
//  Created by Bertuğ YILMAZ on 20/10/2017.
//  Copyright © 2017 Bertuğ YILMAZ. All rights reserved.
//

import UIKit

class MainVC: UIViewController {
    
    var isStart: Bool = false
    var mousePosition: Int!
    var cheesePosition: Int!
    var selectedWallCounter: Int = 0
    var isValidPosition: Bool!
    var mouseCell: CollectionCell!
    var cheeseCell: CollectionCell!
    var pug: [Int] = []
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var startButton: RoundedButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureCollectionView()
        
        self.startButton.addTarget(self, action: #selector(self.startButtonAction(_:)), for: .touchUpInside)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.createWall()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func startButtonAction(_ sender: UIButton) {
        self.isStart = !isStart
        
        self.createWall()
        
        self.generateLocationForMouseAndCheese()
        
        sender.isEnabled = false
    }
    
    func generateLocationForMouseAndCheese() {
        repeat{
            if selectedWallCounter > 108 {
                break
            }
            
            isValidPosition = false
            mousePosition = Int(arc4random_uniform(110))
            cheesePosition = Int(arc4random_uniform(110))
            mouseCell = self.collectionView!.cellForItem(at:  IndexPath(row: mousePosition,section: 0)) as! CollectionCell
            cheeseCell = self.collectionView!.cellForItem(at:  IndexPath(row: cheesePosition,section: 0)) as! CollectionCell
            
            if mouseCell.isWall || cheeseCell.isWall{
                isValidPosition = false
            }else{
                isValidPosition = true
            }
            
        }while(mousePosition == cheesePosition || isValidPosition == false)
        
        if selectedWallCounter  > 108 {
            let alert = UIAlertController(title: "Trying to Find a Bug ?", message: "You Selected All cells as wall so there is no place for our mouse and cheese 🤡", preferredStyle: UIAlertControllerStyle.alert)
            alert.view.tintColor = UIColor(red:0.99, green:0.53, blue:0.22, alpha:1.0)
            alert.addAction(UIAlertAction(title: "Okay, I Understood 😔", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        }else{
            self.pug.append(mousePosition) // First step
            self.mouseCell.imageView.image = UIImage(named: "Mouse")
            self.cheeseCell.imageView.image = UIImage(named: "Cheese")
           
            print("Cheese Position --> \(cheesePosition!)")
            print("Mouse Position --> \(mousePosition!)")
            
            findThatCheese()
        }
    }
    
    func findThatCheese() {
        while self.mousePosition != self.cheesePosition {
            foundPrefferedCell()
        }
        
        self.onTranstion()
    }
    
    func foundPrefferedCell()  {
        var min: [Int] = []
        var cells = [CollectionCell!]()
        
        if let positionRight = mousePosition + 1 as? Int {
            if let right = collectionView.cellForItem(at: IndexPath(row: positionRight,section: 0)) as? CollectionCell {
                if !right.isWall {
                    cells.append(right)
                }
            }
        }
        
        if let positionLeft = mousePosition - 1 as? Int {
            if let left = collectionView.cellForItem(at: IndexPath(row: positionLeft,section: 0)) as? CollectionCell {
                if !left.isWall {
                    cells.append(left)
                }
            }
        }
        
        if let positionTop = mousePosition - 10 as? Int {
            if let top = collectionView.cellForItem(at: IndexPath(row: positionTop,section: 0)) as? CollectionCell {
                if !top.isWall {
                    cells.append(top)
                }
            }
        }
        
        if let positionBottom = mousePosition + 10 as? Int {
            if let bottom =  collectionView.cellForItem(at: IndexPath(row: positionBottom,section: 0)) as? CollectionCell {
                if !bottom.isWall {
                    cells.append(bottom)
                }
            }
        }
        
        var cell : CollectionCell!
        
        for item in cells{
            if let count = item?.repeatCount{
            min.append(count)
            }else {
                break
            }
        }
        
        for item  in cells{
            if item != nil{
                if item?.repeatCount == min.min(){
                    cell = item
                    
                }
            }else {
                cell.repeatCount += 1
                break
            }
        }
        if let index = self.collectionView.indexPath(for: cell)?.row {
            self.pug.append(index)
            self.mousePosition = index
            print("Mouse path --> \(index)")
        }
    }
    
    // Girilen parametrelere göre cell in imageView ına ya da backgroundView ına image set eder.
    func setImageOfCell(index: Int, imageName: String, isImageView: Bool) {
        
        let dummyCell = self.collectionView!.cellForItem(at:  IndexPath(row: index,section: 0)) as! CollectionCell
        if isImageView {
            dummyCell.imageView.image = UIImage(named: imageName)
            self.mousePosition = index
            if index == self.cheesePosition {
                return
            }
        }else {
            dummyCell.backgroundView = UIImageView(image: UIImage(named: imageName))
            if imageName == "wireImg"{
                dummyCell.isWall = true
                dummyCell.tag = WALL
                self.selectedWallCounter += 1
            }
        }
    }
    
    // Index i baz alarak labirentin kenar bölgelerine image(Duvar) ekler.
    func createWall(){
        for index in 0...CELLCOUNT - 1{
            let strIndex = String(index)
            let arrIndex = Array(strIndex.characters)
            
            if arrIndex.last == "0" || arrIndex.last == "9" {
                self.setImageOfCell(index: index, imageName: "wireImg", isImageView: false)
            }
            
            if arrIndex.count == 1 || arrIndex.count == 3 {
                self.setImageOfCell(index: index, imageName: "wireImg", isImageView: false)
            }
        }
    }
    
    func delay(_ delay:Double, closure:@escaping ()->()) {
        let when = DispatchTime.now() + delay
        DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
    }
    
    func onTranstion(){
        self.delay(2) {
            
            if self.pug.count != 0{
                for index in 1...self.pug.count - 1 {
                
                    if let cell = self.collectionView!.cellForItem(at: IndexPath(row: self.pug[index],section: 0)) as? CollectionCell {
                        if let beforeCell = self.collectionView!.cellForItem(at:  IndexPath(row: self.pug[index - 1],section: 0)) as? CollectionCell {
                    
                            UIView.transition(with: self.view, duration: 2, options: .transitionCrossDissolve, animations: {

                                cell.imageView.image = UIImage(named: "Mouse")
                                beforeCell.imageView.image = UIImage(named: "")

                            }, completion: { (succes: Bool) in
                                if succes {
                                }
                            })
                        
                        }
                    }
                }
            }
        }
    }
    
}

