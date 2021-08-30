//
//  WeekViewController.swift
//  KkamPpackE
//
//  Created by 황윤경 on 2021/08/09.
//

import UIKit

class WeekViewController: UIViewController {
    @IBOutlet weak var iconCollectionView: UICollectionView!
    @IBOutlet weak var memoCollectionView: UICollectionView!
    
    var memoList = [["친구랑 점심 약속", "장소: 우리집 \n미리 음식 주문해두기!!\nasdf\nasdf"],
                    ["메모 제목2", "asdfasdfasdfasdfasdfasdfasdfasdfasdfadsfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasf"],["메모 제목3", "일이삼사오육칠팔구십일이삼사오육칠팔구십일이삼사오육칠팔구십일이삼사오육칠팔구십일이삼사오육칠팔구십"]]
    
    override func viewDidLoad() {
        super .viewDidLoad()
//        memoList.removeAll()
        iconCollectionView.dataSource = self
        iconCollectionView.delegate = self
        iconCollectionView.collectionViewLayout = UICollectionViewFlowLayout()
        if let layout = iconCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
        }
        
        memoCollectionView.dataSource = self
        memoCollectionView.delegate = self
    }
}
extension WeekViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == iconCollectionView {
            return 2
        } else {        // == memoViewcontroller
            return memoList.count + 1
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == iconCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "iconCell", for: indexPath) as! IconCell
            cell.layer.borderWidth = 1
            cell.layer.borderColor = #colorLiteral(red: 0.862745098, green: 0.8235294118, blue: 0.7843137255, alpha: 1).cgColor
            cell.layer.cornerRadius = cell.frame.width / 2
            
            cell.backgroundColor = .white
            
            return cell
        } else {        // == memoViewcontroller
            if indexPath.row < memoList.count {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "memoCell", for: indexPath) as! MemoCell
                cell.layer.borderWidth = 1
                cell.layer.borderColor = #colorLiteral(red: 0.862745098, green: 0.8235294118, blue: 0.7843137255, alpha: 1).cgColor
                cell.layer.cornerRadius = 15
                
                cell.backgroundColor = #colorLiteral(red: 0.862745098, green: 0.8235294118, blue: 0.7843137255, alpha: 1)
                
                cell.memoEditBtn.menu = cell.menu
                cell.memoEditBtn.showsMenuAsPrimaryAction = true
                
                cell.memoName.text = memoList[indexPath.row][0]
                
                
                if memoList[indexPath.row][1] != ""{
                    let memo = UITextView()
                    memo.frame = CGRect(x: 0, y: 93, width: cell.frame.width, height: cell.frame.height - 93)
                    memo.font = UIFont.systemFont(ofSize: 17)
                    memo.textContainerInset = UIEdgeInsets(top: 9, left: 10, bottom: 10, right: 10)
                    
                    memo.text = memoList[indexPath.row][1]
                    memo.isEditable = false
                    cell.addSubview(memo)
                }
                return cell
            } else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "addCell", for: indexPath)
                return cell
            }
        }
    }
}
extension WeekViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionView == iconCollectionView {
            return UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        } else {
            return UIEdgeInsets()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout:UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == iconCollectionView {
            return 7
        } else {
            return 12
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout:UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout:UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == iconCollectionView {
            return CGSize(width: 83, height: 83)
        }
        else {
            if indexPath.row < memoList.count {
                if memoList[indexPath.row][1] != "" {
                    return CGSize(width: 374, height: 168)
                } else {
                    return CGSize(width: 374, height: 98)
                }
            } else {
                return CGSize(width: 374, height: 82)
            }
        }
    }
}
extension UITextView {
    func numberOfLine() -> Int {
        
        let size = CGSize(width: frame.width, height: .infinity)
        let estimatedSize = sizeThatFits(size)
        
        return Int(estimatedSize.height / (self.font!.lineHeight))
    }
} 
