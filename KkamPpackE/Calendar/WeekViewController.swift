//
//  WeekViewController.swift
//  KkamPpackE
//
//  Created by 황윤경 on 2021/08/09.
//

import UIKit

class WeekViewController: UIViewController {
    @IBOutlet weak var iconCollectionView: UICollectionView!
    @IBOutlet weak var memoViewController: UICollectionView!
    
    var memoList = ["일정 1", "일정 2"]
    
    override func viewDidLoad() {
        super .viewDidLoad()
        
        iconCollectionView.dataSource = self
        iconCollectionView.delegate = self
        iconCollectionView.collectionViewLayout = UICollectionViewFlowLayout()
        if let layout = iconCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
        }
        
        memoViewController.dataSource = self
        memoViewController.delegate = self
    }
}
extension WeekViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == iconCollectionView {
            return 5
        } else {        // == memoViewcontroller
            return memoList.count + 1
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == iconCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "iconCell", for: indexPath) as! IconCell
            
            return cell
        } else {        // == memoViewcontroller
            if indexPath.row < memoList.count {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "memoCell", for: indexPath) as! MemoCell
                cell.layer.borderWidth = 1
                cell.layer.borderColor = UIColor.lightGray.cgColor
                cell.layer.cornerRadius = 15
                
                cell.memoEditBtn.menu = cell.menu
                cell.memoEditBtn.showsMenuAsPrimaryAction = true
                return cell
            } else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "addCell", for: indexPath)
                return cell
            }
        }

    }
}
extension WeekViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout:UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout:UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout:UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == iconCollectionView {
            return CGSize(width: 90, height: 90)
        } else {        // == memoViewcontroller
            return CGSize(width: view.frame.width, height: 128)
        }
    }
    
}
