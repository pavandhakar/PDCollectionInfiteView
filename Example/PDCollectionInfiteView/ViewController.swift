//
//  ViewController.swift
//  PDCollectionInfiteView
//
//  Created by Pavan on 05/31/2023.
//  Copyright (c) 2023 Pavan. All rights reserved.
//

import UIKit
import PDCollectionInfiteView
class ViewController: UIViewController {
    
    @IBOutlet weak var collectioView : MyCollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        collectioView.register(UINib(nibName: "NewCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "NewCollectionViewCell")
        collectioView.myDelegate = self
        collectioView.myDataSource = self
        DispatchQueue.main.async {
            self.collectioView.startInfiteScrollToItem()
        }
    }
}

extension ViewController : MyCollectionViewDataSource {
    func collectionView(_ collectionView: MyCollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    func collectionView(_ collectionView: MyCollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectioView.dequeueReusableCell(withReuseIdentifier: "NewCollectionViewCell", for: indexPath) as! NewCollectionViewCell
        cell.lbl.text = "\(indexPath.row)"
        return cell
    }
}
extension ViewController: MyCollectionViewDelegate {
    func collectionView(_ collectionView: MyCollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return self.collectioView.bounds.size
    }
    func collectionView(_ collectionView: MyCollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath)
    }
}
