//
//  AlarmViewController.swift
//  KkamPpackE
//
//  Created by 황윤경 on 2021/08/09.
//

import UIKit

class AlarmViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewWillDisappear(_ animated: Bool) {
        super .viewWillDisappear(true)
        self.navigationController?.isNavigationBarHidden = false
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain,    target: self, action: nil)
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
    }
}
extension AlarmViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // 데베의 알람 개수 받아오기
//        let homeView = HomeViewController()
//        return homeView.dailyList.count + homeView.homeList.count
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "alarmCell", for: indexPath) as! AlarmCell
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor.lightGray.cgColor
        cell.layer.cornerRadius = 12
        
        return cell
    }
}
extension AlarmViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        15
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width - 30
        let size = CGSize(width: width, height: 90)
        return size
    }
}
