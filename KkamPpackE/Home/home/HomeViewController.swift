//
//  HomeViewController.swift
//  KkamPpackE
//
//  Created by 황윤경 on 2021/08/08.
//

import UIKit

class HomeViewController: UIViewController {
    @IBOutlet weak var closeBtn: UIButton!
    @IBOutlet weak var titleDate: UILabel!
    @IBOutlet weak var listEdtiBtn: UIButton!
    @IBOutlet weak var homeCollectionView: UICollectionView!
    @IBOutlet weak var dailyCollectionView: UICollectionView!
    @IBOutlet weak var dailyTitle: UILabel!
    @IBOutlet weak var dailyTitleBottomAnchor: NSLayoutConstraint!
    @IBOutlet weak var dailyTitleTopAnchor: NSLayoutConstraint!
    
    var isSaved = false
    static var selectedTaskIndexPath = 0
    
    var homeCVCnt = 0
    var dailyCVCnt = 0
    
    static var isEdit = false
    var isReorder = false
    var isChanged = false
    var isRemove = false
    static var isHomeCollectionView = false
    
    var gesture_home = UILongPressGestureRecognizer()
    var gesture_daily = UILongPressGestureRecognizer()
    
    public static var homeList = [
        HomeData("가스불", UIImage(named: "icon")!, [true,true,true,true,true,true,true], 1, 1, true),
        HomeData("전등", UIImage(named: "icon")!, [true,false,true,false,true,false,true], 2, 2, true),
        HomeData("마스크", UIImage(named: "icon")!, [true,true,true,true,true,true,true], 3, 3, true),
        HomeData("지갑", UIImage(named: "icon")!, [true,true,true,true,true,true,true], 2, 2, true),
        HomeData("창문", UIImage(named: "icon")!, [true,true,true,true,true,true,true], 1, 0, true)
    ]
    
    public static var dailyList = [
        DailyData("운동", UIImage(named: "icon")!, [true,true,true,true,true,true,true], 1, 1, true),
        DailyData("약먹기", UIImage(named: "icon")!, [true,true,true,true,true,true,true], 2, 2, true),
        DailyData("분리수거", UIImage(named: "icon")!, [true,true,true,true,true,true,true], 3, 3, true),
        DailyData("장보기", UIImage(named: "icon")!, [true,true,true,true,true,true,true], 2, 2, true),
        DailyData("세차", UIImage(named: "icon")!, [true,true,true,true,true,true,true], 1, 0, true)
    ]
    
    var dailyListTmp = dailyList
    var homeListTmp = homeList
    
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
        tabBarController?.tabBar.tintColor = .brown
        
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

        
        dailyCollectionView.layer.borderWidth = 1
        dailyCollectionView.layer.borderColor = UIColor.lightGray.cgColor
        dailyCollectionView.layer.cornerRadius = 15
        
        
        gesture_home = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPressGesture_home(_:)))
        gesture_home.minimumPressDuration = 0.01
        
        gesture_daily = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPressGesture_daily(_:)))
        gesture_daily.minimumPressDuration = 0.01
    }
    
    @objc func handleLongPressGesture_home(_ gesture: UILongPressGestureRecognizer) {
        guard let homeSelectedIndexPath = homeCollectionView.indexPathForItem(at: gesture.location(in: homeCollectionView)) else { return }
        let areaX = CGFloat(HomeViewController.homeList.count % 3 * 120)
        let areaY = CGFloat(HomeViewController.homeList.count / 3 * 120)
        
        switch(gesture.state) {
        case .began:
            if homeSelectedIndexPath[1] < HomeViewController.homeList.count {
                homeCollectionView.beginInteractiveMovementForItem(at: homeSelectedIndexPath)
            }
        case .changed:
            let location = gesture.location(in: homeCollectionView)
            if location.x > areaX && location.y > areaY {
                homeCollectionView.cancelInteractiveMovement()
            }
            homeCollectionView.updateInteractiveMovementTargetPosition(location)
//            homeCollectionView.updateInteractiveMovementTargetPosition(gesture.location(in: homeCollectionView))  // 자유 움직임
        case .ended:
            homeCollectionView.endInteractiveMovement()
        default:
            homeCollectionView.cancelInteractiveMovement()
        }
    }
    
    @objc func handleLongPressGesture_daily(_ gesture: UILongPressGestureRecognizer) {
        guard let dailySelectedIndexPath = dailyCollectionView.indexPathForItem(at: gesture.location(in: dailyCollectionView)) else { return }
        let areaX = CGFloat(HomeViewController.dailyList.count % 3 * 120)
        let areaY = CGFloat(HomeViewController.dailyList.count / 3 * 120)
        
        switch(gesture.state) {
        case .began:
            if dailySelectedIndexPath[1] < HomeViewController.dailyList.count {
                dailyCollectionView.beginInteractiveMovementForItem(at: dailySelectedIndexPath)
            }
        case .changed:
            let location = gesture.location(in: dailyCollectionView)
            if location.x > areaX && location.y > areaY {
                dailyCollectionView.cancelInteractiveMovement()
            }
            dailyCollectionView.updateInteractiveMovementTargetPosition(location)
        case .ended:
            dailyCollectionView.endInteractiveMovement()
        default:
            dailyCollectionView.cancelInteractiveMovement()
        }
    }
    
    func setCollectionView() {
        var homeHeight = 0
        var dailyHeight = 0
        
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
        
        if isReorder {
            homeHeight = (HomeViewController.homeList.count + 1) / 3 * 120
            dailyHeight = (HomeViewController.dailyList.count + 1) / 3 * 120
        } else {
            homeHeight = homeRowCnt * 120
            dailyHeight = dailyRowCnt * 120
        }
        
        homeCollectionView.frame = CGRect(x: 27, y: 61, width: 360, height: homeHeight)

        // 일회성 title위치 홈바둑판 y좌표 + 홈바둑판 행 개수 * 120 + 두개 간격
        let dailyY = Int(homeCollectionView.frame.minY) + homeHeight + 40
        dailyTitle.frame = CGRect(x: 27, y: dailyY, width: 63, height: 29)
        
        dailyCollectionView.frame = CGRect(x: 27, y: dailyY + 14 + 29, width: 360, height: dailyHeight)
        
        DispatchQueue.main.async {
            self.dailyTitleTopAnchor.constant = CGFloat(homeHeight + 54)
            self.dailyTitleBottomAnchor.constant = CGFloat(dailyHeight + 70)
        }
        dailyCollectionView.reloadData()
        homeCollectionView.reloadData()
    }
    
    func setMenu() {
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
            listEdtiBtn.setImage(nil, for: .normal)
            listEdtiBtn.isEnabled = false
        } else if edit == "order" {
            isReorder = true
            titleDate.text = "순서 변경"
            listEdtiBtn.setImage(UIImage(systemName: "checkmark"), for: .normal)
            
            homeCollectionView.addGestureRecognizer(gesture_home)
            dailyCollectionView.addGestureRecognizer(gesture_daily)
        } else if edit == "remove" {
            isRemove = true
            titleDate.text = "삭제"
            listEdtiBtn.setImage(nil, for: .normal)
            listEdtiBtn.isEnabled = false
        }
        titleDate.font = UIFont.boldSystemFont(ofSize: 25)
        listEdtiBtn.menu = nil
        closeBtn.setImage(UIImage(systemName: "xmark"), for: .normal)
        closeBtn.tintColor = .black
        homeCollectionView.reloadData()
        dailyCollectionView.reloadData()
        tabBarController?.tabBar.isHidden = true
    }

    func closeView() {
        // 타이틀 라벨 설정
        let date = DateFormatter()
        date.dateFormat = "MM.dd.EEEE"
        date.locale = Locale(identifier: "ko-KR")
        titleDate.text = date.string(from: Date())
        titleDate.font = UIFont.boldSystemFont(ofSize: 29)
        
        // 순서변경 제스처 삭제
        homeCollectionView.removeGestureRecognizer(gesture_home)
        dailyCollectionView.removeGestureRecognizer(gesture_daily)
        
        // 퍈집 변수 초기화
        HomeViewController.isEdit = false
        isReorder = false
        isRemove = false
        
        // 버튼 기능 및 이미지 변경
        listEdtiBtn.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        closeBtn.setImage(UIImage(named: "icon"), for: .normal)
        setMenu()
        
        // 탭바 활성화
        tabBarController?.tabBar.isHidden = false
        
        // 편집 이미지 삭제 //cell.taskEdit.image = nil
        homeCollectionView.reloadData()
        dailyCollectionView.reloadData()
        //setCollectionView()
        
        // 버튼 활성화
        listEdtiBtn.isEnabled = true
    }
    @IBAction func saveList(_ sender: Any) {
        isSaved = true
        homeListTmp = HomeViewController.homeList
        dailyListTmp = HomeViewController.dailyList
        
        closeView()
    }
    @IBAction func closeEdit(_ sender: Any) {
        // 도토리일 때 말고 x일 때만 동작
        if closeBtn.currentImage == UIImage(systemName: "xmark") {
            isSaved = false
            if isChanged {  // 변화 있으면 물어보고
                let actionSheetController = UIAlertController(title: "", message: "홈으로 이동하시겠습니까?\n편집한 내용은 저장되지 않습니다.", preferredStyle: .alert)
                let reset = UIAlertAction(title: "홈으로 이동", style: .default) { (action) in
                    HomeViewController.homeList = self.homeListTmp
                    HomeViewController.dailyList = self.dailyListTmp
                    self.closeView()
                }
                let cancelAction = UIAlertAction(title: "취소", style: .cancel) { action -> Void in }

                actionSheetController.addAction(reset)
                actionSheetController.addAction(cancelAction)

                self.present(actionSheetController, animated: true, completion: nil)
                self.isChanged = false
            } else {    // 변화 없으면 그냥 닫기
                closeView()
            }
        }
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
        cell.backgroundColor = .white
        
        let addCell = homeCollectionView.dequeueReusableCell(withReuseIdentifier: "addCell", for: indexPath) as! AddCell
        addCell.layer.borderWidth = 1
        addCell.layer.borderColor = #colorLiteral(red: 0.8517223001, green: 0.846660018, blue: 0.8556143045, alpha: 1).cgColor
        
        if HomeViewController.isEdit || isReorder || isRemove {
            addCell.plusImg.tintColor = .lightGray
        }
        
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
            if HomeViewController.isEdit || isReorder || isRemove {
                return
            }
            HomeViewController.isEdit = false
            isReorder = false
            isRemove = false
            
            if collectionView == homeCollectionView {
                HomeViewController.isHomeCollectionView = true
            } else {
                HomeViewController.isHomeCollectionView = false
            }
            guard let uvc = self.storyboard?.instantiateViewController(identifier: "addTaskView") else { return }
            self.navigationController?.pushViewController(uvc, animated: true)
        } else if cell?.reuseIdentifier != "noneCell"{
            let cell = collectionView.cellForItem(at: indexPath) as! HomeCell
            if HomeViewController.isEdit {
                print("태스크 변경")
                HomeViewController.selectedTaskIndexPath = indexPath.row
                guard let taskVC = self.storyboard?.instantiateViewController(identifier: "addTaskView") as? TaskViewController else{ return }
                
                if collectionView == homeCollectionView {
                    HomeViewController.isHomeCollectionView = true
                    taskVC.receivedImg = HomeViewController.homeList[indexPath.row].icon
                    taskVC.receivedName = HomeViewController.homeList[indexPath.row].name
                    taskVC.receivedChosedDay = HomeViewController.homeList[indexPath.row].day
                    taskVC.receivedDayCnt = HomeViewController.homeList[indexPath.row].dayCnt
                    taskVC.receivedAlarmCnt = HomeViewController.homeList[indexPath.row].alarmCnt
                    taskVC.receivedState = HomeViewController.homeList[indexPath.row].recordState
                } else {
                    HomeViewController.isHomeCollectionView = false
                    taskVC.receivedImg = HomeViewController.dailyList[indexPath.row].icon
                    taskVC.receivedName = HomeViewController.dailyList[indexPath.row].name
                    taskVC.receivedChosedDay = HomeViewController.dailyList[indexPath.row].day
                    taskVC.receivedDayCnt = HomeViewController.dailyList[indexPath.row].dayCnt
                    taskVC.receivedAlarmCnt = HomeViewController.dailyList[indexPath.row].alarmCnt
                    taskVC.receivedState = HomeViewController.dailyList[indexPath.row].recordState
                }
                
                self.navigationController?.pushViewController(taskVC, animated: true)
            } else if isRemove {
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
                    print(cell.taskName.text!)
                    
                    if cell.tappedCnt == 0 {
                        cell.tappedCnt += 1
                        cell.backgroundColor = #colorLiteral(red: 0.9528681636, green: 0.9529822469, blue: 0.9528294206, alpha: 1)
                    } else {
                        cell.tappedCnt -= 1
                        cell.backgroundColor = .white
                    }
                }
            }
        }
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate{
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

    // reorder collectionView
    func collectionView(_ collectionView: UICollectionView, canEditItemAt indexPath: IndexPath) -> Bool {
        if isReorder {
            return true
        } else {
            return false
        }
    }
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        if isReorder {
            return true
        } else {
            return false
        }
    }
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        if collectionView == homeCollectionView {
            let item = HomeViewController.homeList.remove(at: sourceIndexPath.row)
            HomeViewController.homeList.insert(item, at: destinationIndexPath.row)
        } else { // if collectionView == dailyCollectionView {
            let item = HomeViewController.dailyList.remove(at: sourceIndexPath.row)
            HomeViewController.dailyList.insert(item, at: destinationIndexPath.row)
        }
        isChanged = true
    }
}
