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
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionCell
        return cell
    }
}
