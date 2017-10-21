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
    var cheesePosition : Int!
    var isValidPosition : Bool!
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
    }
    func generateLocationForMouseAndCheese() {
        repeat{
            isValidPosition = false
            mousePosition = Int(arc4random_uniform(71))
            cheesePosition = Int(arc4random_uniform(71))
            let cell1 = self.collectionView!.cellForItem(at:  IndexPath(row: mousePosition,section: 0)) as! CollectionCell
            let cell2 = self.collectionView!.cellForItem(at:  IndexPath(row: cheesePosition,section: 0)) as! CollectionCell
            if cell1.isWall || cell2.isWall{
                isValidPosition = false
            }else{
                isValidPosition = true
            }
            print("Onur : mouse \(mousePosition) cheese : \(cheesePosition)")
            print("Onur : Cell1 isWall = \(cell1.isWall) Cell2 isWall = \(cell2.isWall)")
        }while(mousePosition == cheesePosition && isValidPosition == true)
    }
    
    func configureCollectionView() {
        
        self.collectionView.dataSource = self
        
        self.collectionView.delegate = self
        
        self.customLayoutForCollectionView()
    }
    
    func customLayoutForCollectionView(){
        let itemWidth = (UIScreen.main.bounds.width - 16 ) / 7
        let itemHeight = collectionView.frame.size.height / 10
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        layout.footerReferenceSize = CGSize(width: 0, height: 0)
        
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        
        collectionView.collectionViewLayout = layout
    }
}

extension MainVC : UICollectionViewDelegate,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 70
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if !isStart {
            if let cell =  self.collectionView.cellForItem(at: indexPath) as? CollectionCell{
                cell.backgroundView = UIImageView(image: UIImage(named: "wireImg"))
                cell.isWall = true
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionCell
        cell.tag = indexPath.row + 1
        
        return cell
    }
}
