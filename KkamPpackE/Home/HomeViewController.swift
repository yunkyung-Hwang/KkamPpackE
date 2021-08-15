//
//  HomeViewController.swift
//  KkamPpackE
//
//  Created by 황윤경 on 2021/08/08.
//

import UIKit

class HomeViewController: UIViewController {
    @IBOutlet weak var titleDate: UILabel!
    @IBOutlet weak var listEdtiBtn: UIButton!
    @IBOutlet weak var homeCollectionView: UICollectionView!
    @IBOutlet weak var dailyCollectionView: UICollectionView!
    @IBOutlet weak var dailyTitle: UILabel!
    @IBOutlet weak var dailyTitleBottomAnchor: NSLayoutConstraint!
    @IBOutlet weak var dailyTitleTopAnchor: NSLayoutConstraint!
    
    var homeCVCnt = 0
    var dailyCVCnt = 0
    
    static var isEdit = false
    var isReorder = false
    var isRemove = false
    static var isHomeCollectionView = false
    
    public static var homeList = [
        HomeData("가스불", UIImage(named: "icon")!),
        HomeData("전등", UIImage(named: "icon")!),
        HomeData("마스크", UIImage(named: "icon")!),
        HomeData("지갑", UIImage(named: "icon")!),
        HomeData("창문", UIImage(named: "icon")!)
//        HomeData("창문", UIImage(named: "icon")!)
    ]
    
    public static var dailyList = [
        DailyData("운동", UIImage(named: "icon")!, [0,6], 0, "없음"),
        DailyData("약먹기", UIImage(named: "icon")!, [], 0, "없음"),
        DailyData("분리수거", UIImage(named: "icon")!, [], 0, "없음"),
        DailyData("장보기", UIImage(named: "icon")!, [], 0, "없음"),
        DailyData("세차", UIImage(named: "icon")!, [], 0, "없음"),
        DailyData("영어공부", UIImage(named: "icon")!, [], 0, "없음")
    ]
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
        
        setCollectionView()
    }
    override func viewDidLoad() {
        super .viewDidLoad()
//        print(view.frame.width, view.frame.height)
        
        let date = DateFormatter()
        date.dateFormat = "MM.dd.EEEE"
        date.locale = Locale(identifier: "ko-KR")
        titleDate.text = date.string(from: Date())
        
        setMenu()

        homeCollectionView.dataSource = self
        homeCollectionView.delegate = self
        dailyCollectionView.dataSource = self
        dailyCollectionView.delegate = self
        
        homeCollectionView.layer.borderWidth = 1
        homeCollectionView.layer.borderColor = UIColor.lightGray.cgColor
        homeCollectionView.layer.cornerRadius = 15
        homeCollectionView.isPagingEnabled = true
        homeCollectionView.isScrollEnabled = false

        
        dailyCollectionView.layer.borderWidth = 1
        dailyCollectionView.layer.borderColor = UIColor.lightGray.cgColor
        dailyCollectionView.layer.cornerRadius = 15
        dailyCollectionView.isPagingEnabled = true
        dailyCollectionView.isScrollEnabled = false
    }
    
    func setCollectionView() {
        var homeRowCnt = (HomeViewController.homeList.count + 1) / 3
        if (HomeViewController.homeList.count + 1) % 3 != 0 {
            homeRowCnt += 1
            homeCVCnt = homeRowCnt * 3
        }
        
        var dailyRowCnt = (HomeViewController.dailyList.count + 1) / 3
        if (HomeViewController.dailyList.count + 1) % 3 != 0 {
            dailyRowCnt += 1
            dailyCVCnt = dailyRowCnt * 3
        }
        
        homeCollectionView.frame = CGRect(x: 27, y: 61, width: 360, height: homeRowCnt * 120)

        // 일회성 title위치 홈바둑판 y좌표 + 홈바둑판 행 개수 * 120 + 두개 간격
        let dailyY = Int(homeCollectionView.frame.minY) + homeRowCnt * 120 + 40
        dailyTitle.frame = CGRect(x: 27, y: dailyY, width: 63, height: 29)
        
        dailyCollectionView.frame = CGRect(x: 27, y: dailyY + 14 + 29, width: 360, height: dailyRowCnt * 120)
        
        DispatchQueue.main.async {
            self.dailyTitleTopAnchor.constant = CGFloat(homeRowCnt * 120 + 54)
            self.dailyTitleBottomAnchor.constant = CGFloat(dailyRowCnt * 120 + 70)
        }
        dailyCollectionView.reloadData()
        homeCollectionView.reloadData()
    }
    
    func setMenu() {
//        print(dailyList[0].name!,dailyList[0].day,dailyList[0].dayCnt!,dailyList[0].alarmCnt!)
        var menuItems: [UIAction] {
            return [
                UIAction(title: "할 일 편집", image: UIImage(systemName: "pencil"), handler: {[self] _ in list(edit: "edit")}),
                UIAction(title: "순서 변경", image: UIImage(systemName: "arrow.up.arrow.down"),  handler: {[self] _ in list(edit: "order")}),
                UIAction(title: "삭제", image: UIImage(systemName: "trash"), attributes: .destructive, handler: {[self] _ in list(edit: "remove")})
            ]
        }
        var menu: UIMenu {
            return UIMenu(title: "", image: UIImage(systemName: "ellipsis"), identifier: nil, options: [], children: menuItems)
        }
        listEdtiBtn.menu = menu
        listEdtiBtn.showsMenuAsPrimaryAction = true
    }
    
    func list(edit:String) {
        if edit == "edit" {
            HomeViewController.isEdit = true
            titleDate.text = "할 일 편집"
        } else if edit == "order" {
            isReorder = true
            titleDate.text = "순서 변경"
        } else if edit == "remove" {
            isRemove = true
            titleDate.text = "삭제"
        }
        titleDate.font = UIFont.boldSystemFont(ofSize: 25)
        listEdtiBtn.setImage(UIImage(systemName: "checkmark"), for: .normal)
        listEdtiBtn.menu = nil
        homeCollectionView.reloadData()
        dailyCollectionView.reloadData()
        tabBarController?.tabBar.isHidden = true
    }

    @IBAction func saveList(_ sender: Any) {
        print("save")
        let date = DateFormatter()
        date.dateFormat = "MM.dd.EEEE"
        date.locale = Locale(identifier: "ko-KR")
        titleDate.text = date.string(from: Date())
        titleDate.font = UIFont.boldSystemFont(ofSize: 29)
        
        HomeViewController.isEdit = false
        isReorder = false
        isRemove = false
        homeCollectionView.reloadData()
        dailyCollectionView.reloadData()
        
        listEdtiBtn.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        setMenu()
        tabBarController?.tabBar.isHidden = false
    }
}

// MARK: extension
extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
     
        if collectionView == homeCollectionView {
            var homeRowCnt = (HomeViewController.homeList.count + 1) / 3
            if (HomeViewController.homeList.count + 1) % 3 != 0 {
                homeRowCnt += 1
                homeCVCnt = homeRowCnt * 3
            } else {
                homeCVCnt = HomeViewController.homeList.count + 1
            }
            return homeCVCnt
        }
        if collectionView == dailyCollectionView {
            var dailyRowCnt = (HomeViewController.dailyList.count + 1) / 3
            if (HomeViewController.dailyList.count + 1) % 3 != 0 {
                dailyRowCnt += 1
                dailyCVCnt = dailyRowCnt * 3
                
            } else {
                dailyCVCnt = HomeViewController.dailyList.count + 1
            }
            return dailyCVCnt
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = homeCollectionView.dequeueReusableCell(withReuseIdentifier: "homeCell", for: indexPath) as! HomeCell
        cell.layer.borderWidth = 1
        cell.layer.borderColor = #colorLiteral(red: 0.8517223001, green: 0.846660018, blue: 0.8556143045, alpha: 1).cgColor
        
        let addCell = homeCollectionView.dequeueReusableCell(withReuseIdentifier: "addCell", for: indexPath)
        addCell.layer.borderWidth = 1
        addCell.layer.borderColor = #colorLiteral(red: 0.8517223001, green: 0.846660018, blue: 0.8556143045, alpha: 1).cgColor
        
        let noneCell = homeCollectionView.dequeueReusableCell(withReuseIdentifier: "noneCell", for: indexPath)
        noneCell.layer.borderWidth = 1
        noneCell.layer.borderColor = #colorLiteral(red: 0.8517223001, green: 0.846660018, blue: 0.8556143045, alpha: 1).cgColor
        
        
        if collectionView == homeCollectionView {
            if indexPath.row < HomeViewController.homeList.count {
                cell.taskName.text = HomeViewController.homeList[indexPath.row].name
                if HomeViewController.isEdit {
                    cell.taskEdit.image = UIImage(named: "edit")
                } else if isReorder{
                    cell.taskEdit.image = UIImage(named: "move")
                } else if isRemove {
                    cell.taskEdit.image = UIImage(named: "delete")
                } else {
                    cell.taskEdit.image = nil
                }
                return cell
            } else if indexPath.row == homeCVCnt - 1 {
                print(indexPath.row,homeCVCnt)
                return addCell
            } else {
                return noneCell
            }
        } else { //if collectionView == dailyCollectionView
            if indexPath.row < HomeViewController.dailyList.count {
                cell.taskName.text = HomeViewController.dailyList[indexPath.row].name
                if HomeViewController.isEdit {
                    cell.taskEdit.image = UIImage(named: "edit")
                } else if isReorder{
                    cell.taskEdit.image = UIImage(named: "move")
                } else if isRemove {
                    cell.taskEdit.image = UIImage(named: "delete")
                } else {
                    cell.taskEdit.image = nil
                }
                return cell
            } else if indexPath.row == dailyCVCnt - 1 {
                return addCell
            } else {
                return noneCell
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        
        if cell?.reuseIdentifier == "addCell" {
            HomeViewController.isEdit = false
            isReorder = false
            isRemove = false
            
            if collectionView == homeCollectionView {
                HomeViewController.isHomeCollectionView = true
            } else {
                HomeViewController.isHomeCollectionView = false
            }
            guard let uvc = self.storyboard?.instantiateViewController(identifier: "addTaskView") else{
                return
            }
            self.navigationController?.pushViewController(uvc, animated: true)
        } else if cell?.reuseIdentifier != "noneCell"{
            if HomeViewController.isEdit {
                print("태스크 변경")
                guard let uvc = self.storyboard?.instantiateViewController(identifier: "addTaskView") else{
                    return
                }
                self.navigationController?.pushViewController(uvc, animated: true)
            }
            else if isReorder {
                print("순서 변경")
            }
            else if isRemove {
                print("목록 삭제")

                let actionSheetController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
                
                var title = ""
                if collectionView == homeCollectionView {
                    title = "'" + HomeViewController.homeList[indexPath.row].name + "' 삭제"
                } else {
                    title = "'" + HomeViewController.dailyList[indexPath.row].name + "' 삭제"
                }
                let removeTask = UIAlertAction(title: title, style: .destructive) { action -> Void in
                    if collectionView == self.homeCollectionView {
                        HomeViewController.homeList.remove(at: indexPath.row)
                        print("removed")
                        collectionView.reloadData()
                    } else if collectionView == self.dailyCollectionView {
                        HomeViewController.dailyList.remove(at: indexPath.row)
                        collectionView.reloadData()
                    }
                    self.setCollectionView()
                }

                let cancelAction = UIAlertAction(title: "취소", style: .cancel) { action -> Void in }

                // add actions
                actionSheetController.addAction(removeTask)
                actionSheetController.addAction(cancelAction)

                self.present(actionSheetController, animated: true, completion: nil)
            } else {
                var cnt = 0
                if collectionView == homeCollectionView {
                    cnt = HomeViewController.homeList.count
                } else if collectionView == dailyCollectionView {
                    cnt = HomeViewController.dailyList.count
                }
                
                if indexPath.row == cnt{ //더보기 버튼
                    print("더보기 Btn")
                } else {    // 나머지
                    let cell = collectionView.cellForItem(at: indexPath) as! HomeCell
                    print(cell.taskName.text!)
                    
                    if cell.tappedCnt == 0 {
                        cell.tappedCnt += 1
                        cell.backgroundColor = #colorLiteral(red: 0.9528681636, green: 0.9529822469, blue: 0.9528294206, alpha: 1)
                    } else {
                        cell.backgroundColor = .white
                        cell.tappedCnt -= 1
                    }
                }
            }
        }
    }
    
//    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
//        return true
//    }
//    func collectionView(_ collectionView: UICollectionView, canEditItemAt indexPath: IndexPath) -> Bool {
//        return true
//    }
//    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
//        let fromRow = sourceIndexPath.row
//        let toRow = destinationIndexPath.row
//        let data = HomeViewController.homeList[fromRow]
//        HomeViewController.homeList.remove(at: fromRow)
//        HomeViewController.homeList.insert(data, at: toRow)
//        
//        collectionView.reloadData()
//    }
//    func collectionview(_ collectionView: UICollectionView, canHandle session: UIDropSession) -> Bool {
//        return true
//    }
}
//extension HomeViewController: UICollectionViewDragDelegate{
//    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
//        <#code#>
//    }
//
//
//}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width/3
        let size = CGSize(width: width, height: width)
        return size
    }
}
