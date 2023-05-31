//
//  PDCollectionInfiteView.swift
//  PDCollectionInfiteView
//
//  Created by BBPL on 31/05/23.
//

import Foundation
import UIKit

public protocol MyCollectionViewDelegate : AnyObject {
    func numberOfSections(in collectionView: MyCollectionView) -> Int
    func collectionView(_ collectionView: MyCollectionView, didSelectItemAt indexPath: IndexPath)
    
    func collectionView(_ collectionView: MyCollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
}
public protocol MyCollectionViewDataSource : AnyObject {
    func collectionView(_ collectionView: MyCollectionView, numberOfItemsInSection section: Int) -> Int
    func collectionView(_ collectionView: MyCollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
}
public extension MyCollectionViewDelegate {
    func numberOfSections(in collectionView: MyCollectionView) -> Int { return 1}
    func collectionView(_ collectionView: MyCollectionView, didSelectItemAt indexPath: IndexPath) { }
    func collectionView(_ collectionView: MyCollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize { CGSize(width: 100, height: 100) }
}

public class MyCollectionView: UICollectionView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    public override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.dataSource = self
        self.delegate = self
//        fatalError("init(coder:) has not been implemented")
    }
    weak public var myDelegate : MyCollectionViewDelegate? {
        didSet {
            self.delegate = self
        }
    }
    weak public var myDataSource: MyCollectionViewDataSource? {
        didSet {
            self.dataSource = self
            subviews.forEach { (view) in
                if let scrollView = view as? UIScrollView {
                    scrollView.delegate = self
                }
            }
        }
    }
    var totalSection = 0
    var totalRow = 0
    public func scrollToItem(item: Int, section: Int, at: UICollectionView.ScrollPosition, animated: Bool) {
        if section == 0 {
            let items = item + 1
            self.scrollToItem(at: IndexPath(item: items, section: section), at: at, animated: animated)
        }else{
            self.scrollToItem(at: IndexPath(item: item, section: section), at: at, animated: animated)
        }
        self.setUp()
    }
    public func startInfiteScrollToItem(at: UICollectionView.ScrollPosition = .left) {
        if totalSection > 0 && totalRow > 0 {
            self.scrollToItem(at: IndexPath(item: 1, section: 0), at: at, animated: false)
        }
        self.setUp()
    }
    public func setUp()  {
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
    }

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let tamp = myDataSource?.collectionView(self, numberOfItemsInSection: section) {
            totalRow = tamp
            if tamp == 0 {
                return 0
            }
            return tamp + 2
        }
        return 0
    }
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var index = indexPath.item
        if index == 0 {
            index = self.totalRow - 1
        }else if index == (self.totalRow + 1) {
            index = 0
        }else{
            index = index - 1
        }
        if let tamp = myDataSource?.collectionView(self, cellForItemAt: IndexPath(row: index, section: indexPath.section)){
            return tamp
        }
        return UICollectionViewCell()
    }
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        let tamp = myDelegate?.numberOfSections(in: self) ?? 1
        totalSection = tamp
        return tamp
    }
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var index = indexPath.item
        if index == 0 {
            index = self.totalRow - 1
        }else if index == (self.totalRow + 1) {
            index = 0
        }else{
            index = index - 1
        }
        myDelegate?.collectionView(self, didSelectItemAt: IndexPath(item: index, section: indexPath.section))
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if self.totalRow <= 0 {
            return
        }
        guard let inde = self.indexPathsForVisibleItems.first?.item else {
            return
        }
        if inde == 0 {
            self.scrollToItem(at: IndexPath(item: self.totalRow, section: 0), at: .left, animated: false)
        }
        if inde == (self.totalRow+1) {
            self.scrollToItem(at: IndexPath(item: 1, section: 0), at: .left, animated: false)
        }
    }
    

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return myDelegate?.collectionView(self, layout: collectionViewLayout, sizeForItemAt: indexPath) ?? self.frame.size
    }
}
