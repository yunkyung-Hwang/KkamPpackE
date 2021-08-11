//
//  CalendarViewController.swift
//  KkamPpackE
//
//  Created by 황윤경 on 2021/08/08.
//

import UIKit

class CalendarViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var weekView: UIView!
    
    var isMonth = true
    
    override func viewWillDisappear(_ animated: Bool) {
        super .viewWillDisappear(true)
        self.navigationController?.isNavigationBarHidden = false
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        navigationItem.backBarButtonItem?.tintColor = .black
    }
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(true)
        self.navigationController?.isNavigationBarHidden = true
        tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidLoad() {
        super .viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.layer.borderWidth = 1
        collectionView.layer.borderColor = UIColor.lightGray.cgColor
        collectionView.layer.cornerRadius = 15
    }
}

extension CalendarViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isMonth {
            return 35
        } else {
            return 7
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dateCell", for: indexPath)
        cell.layer.borderWidth = 1
        cell.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1).cgColor
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let cell = collectionView.cellForItem(at: indexPath)
        print(indexPath)
        isMonth.toggle()
        collectionView.reloadData()
    }
}
extension CalendarViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var size = CGSize()
        if isMonth {
            size = CGSize(width: 53, height: 130)
            collectionView.frame = CGRect(x: 20, y: 141, width: 374, height: 650)
            weekView.frame = CGRect(x: 20, y: 900, width: 374, height: 459)
        } else {
            size = CGSize(width: 53, height: 53)
            collectionView.frame = CGRect(x: 20, y: 141, width: 374, height: 53)
            weekView.frame = CGRect(x: 20, y: 200, width: 374, height: 459)
        }
        return size
    }
}
