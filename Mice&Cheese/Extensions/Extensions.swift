//
//  Extensions.swift
//  Mice&Cheese
//
//  Created by onur hüseyin çantay on 21.10.2017.
//  Copyright © 2017 Bertuğ YILMAZ. All rights reserved.
//

import UIKit

extension MainVC : UICollectionViewDelegate,UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 110
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.item)
        if !isStart {
            if let cell =  self.collectionView.cellForItem(at: indexPath) as? CollectionCell{
                if !cell.isWall{
                    cell.backgroundView = UIImageView(image: UIImage(named: "wireImg"))
                    cell.isWall = true
                    self.selectedWallCounter += 1
                }else{
                    cell.backgroundView = .none
                    cell.isWall = false
                    self.selectedWallCounter -= 1
                }
                
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionCell
        cell.tag = indexPath.row 
        
        return cell
    }
    
    func configureCollectionView() {
        
        self.collectionView.dataSource = self
        
        self.collectionView.delegate = self
        
        self.customLayoutForCollectionView()
    }
    
    func customLayoutForCollectionView(){
        let itemWidth = (UIScreen.main.bounds.width) / 10
        let itemHeight = (collectionView.frame.size.height - 1) / 11
        let layout = UICollectionViewFlowLayout()
        
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        layout.footerReferenceSize = CGSize(width: 0, height: 0)
        
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        
        collectionView.collectionViewLayout = layout
    }
}
