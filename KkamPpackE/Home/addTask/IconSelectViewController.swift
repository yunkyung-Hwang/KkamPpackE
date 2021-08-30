//
//  IconSelectViewController.swift
//  KkamPpackE
//
//  Created by 황윤경 on 2021/08/11.
//

import UIKit

class IconSelectViewController: UIViewController {
    @IBOutlet weak var iconCollectionView: UICollectionView!
    @IBOutlet weak var selectedIcon: UIImageView!
    
    override func viewDidLoad() {
        super .viewDidLoad()
        iconCollectionView.dataSource = self
        iconCollectionView.delegate = self
        
        navigationController?.navigationBar.topItem?.title = "아이콘 선택"
        navigationController?.navigationBar.backgroundColor = .clear
        
        let backBtn = UIButton(type: .system)
        backBtn.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        backBtn.setTitle("  취소", for: .normal)
        backBtn.titleLabel?.font = UIFont(name: "System", size: 20)
        backBtn.addTarget(self, action: #selector(closeModal), for: .touchUpInside)
        navigationController?.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(customView: backBtn)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(self.saveIcon))
        
        
        selectedIcon.layer.borderWidth = 1
        selectedIcon.layer.borderColor = #colorLiteral(red: 0.862745098, green: 0.8235294118, blue: 0.7843137255, alpha: 1).cgColor
        selectedIcon.layer.cornerRadius = selectedIcon.frame.width/2
        selectedIcon.image = iconImgList.randomElement()!
    }
    
    @objc func closeModal() {
        dismiss(animated: true, completion: nil)
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
        let cell = iconCollectionView.dequeueReusableCell(withReuseIdentifier: "iconCell", for: indexPath) as! IconSelectCell
        cell.layer.borderWidth = 1
        cell.layer.borderColor = #colorLiteral(red: 0.862745098, green: 0.8235294118, blue: 0.7843137255, alpha: 1).cgColor
        cell.layer.cornerRadius = cell.frame.width / 2
        cell.iconImg.image = iconImgList[indexPath.row]
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = iconCollectionView.cellForItem(at: indexPath) as! IconSelectCell
        
        selectedIcon.image = cell.iconImg.image
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
