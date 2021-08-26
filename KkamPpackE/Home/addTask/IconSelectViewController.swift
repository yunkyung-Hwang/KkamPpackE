//
//  IconSelectViewController.swift
//  KkamPpackE
//
//  Created by 황윤경 on 2021/08/11.
//

import UIKit

class IconSelectViewController: UIViewController {
    @IBOutlet weak var iconCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super .viewDidLoad()
        iconCollectionView.dataSource = self
        iconCollectionView.delegate = self
        
        navigationController?.navigationBar.topItem?.title = "아이콘 선택"
//        navigationItem.hidesBackButton = false
//        navigationItem.backBarButtonItem = UIBarButtonItem(title: "취소", style: .plain, target: self, action: nil)
        navigationController?.navigationBar.backgroundColor = .clear
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(self.saveIcon))
//        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(self.saveIcon))
    }
    @objc func saveIcon(){
        print("저장됨")
        self.dismiss(animated: true, completion: nil)
    }
}
extension IconSelectViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 28
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = iconCollectionView.dequeueReusableCell(withReuseIdentifier: "iconCell", for: indexPath)
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let cell = iconCollectionView.cellForItem(at: indexPath) as!
        
    }
}

extension IconSelectViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        17
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        17
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - 52) / 4
        let size = CGSize(width: width, height: width)
        return size
    }
}
