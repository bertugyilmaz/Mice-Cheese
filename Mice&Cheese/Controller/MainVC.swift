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
    var mousePosition : Int!
    var selectedWallCounter : Int = 0
    var cheesePosition : Int!
    var isValidPosition : Bool!
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
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func startButtonAction(_ sender: UIButton) {
        self.isStart = !isStart
        createWall()
        generateLocationForMouseAndCheese()
        sender.isEnabled = false
    }
    
    func generateLocationForMouseAndCheese() {
        repeat{
            if selectedWallCounter > 108 {
                break
            }
            
            isValidPosition = false
            mousePosition = Int(arc4random_uniform(111))
            cheesePosition = Int(arc4random_uniform(111))
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
            mouseCell.imageView.image = UIImage(named: "Mouse")
            cheeseCell.imageView.image = UIImage(named: "Cheese")
            print("Cheese Position --> \(cheesePosition!)")
            print("Mouse Position --> \(mousePosition!)")
            findMousePug()
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
    
    // Farenin ayak izlerini bulup array a append etmektedir.
    func findMousePug() {
        repeat{
            
            if let positionRight = mousePosition + 1 as? Int {
                if let rightCell = self.collectionView.cellForItem(at: IndexPath(row: positionRight, section: 0)) as? CollectionCell {
                    if !rightCell.isWall && !rightCell.isPug {
                        rightCell.isPug = true
                        self.mousePosition = positionRight
                        self.pug.append(mousePosition)
                        print(mousePosition)
                        if positionRight == cheesePosition {
                            rightCell.foundItCheese = true
                            break
                        }

                        continue
                    }
                }
            }
            
            if let positionBottom = mousePosition + 10 as? Int {
                if let bottomCell = self.collectionView.cellForItem(at: IndexPath(row: positionBottom, section: 0)) as? CollectionCell {
                    if !bottomCell.isWall && !bottomCell.isPug {
                        bottomCell.isPug = true
                        mousePosition = positionBottom
                        self.pug.append(mousePosition)
                        print(mousePosition)
                        if positionBottom == cheesePosition {
                            bottomCell.foundItCheese = true
                            break
                        }
                        
                        continue
                        
                    }
                }
            }
          
            if let positionLeft = mousePosition - 1 as? Int {
                if let leftCell = self.collectionView.cellForItem(at: IndexPath(row: positionLeft, section: 0)) as? CollectionCell {
                    if !leftCell.isWall && !leftCell.isPug{
                        leftCell.isPug = true
                        mousePosition = positionLeft
                        self.pug.append(mousePosition)
                        print(mousePosition)
                        if positionLeft == cheesePosition {
                            leftCell.foundItCheese = true
                            break
                        }
                        
                        continue
                    }
                }
            }
            
            if let positionTop = mousePosition - 10 as? Int {
                if let topCell = self.collectionView.cellForItem(at: IndexPath(row: positionTop, section: 0)) as? CollectionCell {
                    if !topCell.isWall && !topCell.isPug{
                        topCell.isPug = true
                        mousePosition = positionTop
                        self.pug.append(mousePosition)
                        print(mousePosition)
                        if positionTop == cheesePosition {
                            topCell.foundItCheese = true
                            break
                        }
                        
                        continue
                    }
                }
            }
            
        }while (!cheeseCell.foundItCheese)
        
    }
    
    // Girilen parametrelere göre cell in imageView ına ya da backgroundView ına image set eder.
    func setImageOfCell(index: Int, imageName: String, isImageView: Bool) {
        
        let dummyCell = self.collectionView!.cellForItem(at:  IndexPath(row: index,section: 0)) as! CollectionCell
        if isImageView {
            dummyCell.imageView.image = UIImage(named: imageName)
            self.mousePosition = index
            if index == cheesePosition {
                dummyCell.foundItCheese = true
                return
            }
        }else {
            dummyCell.backgroundView = UIImageView(image: UIImage(named: imageName))
            if imageName == "wireImg"{
                dummyCell.isWall = true
                dummyCell.tag = WALL
            }
        }
    }
}

