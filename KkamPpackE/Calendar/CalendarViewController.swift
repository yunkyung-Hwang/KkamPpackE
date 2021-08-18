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
    
    @IBOutlet weak var addAndMonthBtn: UIButton!
    @IBOutlet weak var yearMonthLabel: UILabel!
    
    var isMonth = true
    
    let now = Date()
    var cal = Calendar.current
    let dateFormatter = DateFormatter()
    var components = DateComponents()
    let daylist = ["일","월","화","수","목","금","토"]
    var days: [[Int]] = Array(repeating: Array(repeating: 0, count: 2), count: 42)  // 크기 42로 고정
    var weekDays: [[Int]] = [[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0]]
    var selectedDay = [0,0]
    
    var day_Max = 0 // 해당 월이 며칠까지 있는지
    var prevDayMax = 0
    var weekdayAdding = 0 // 시작일
    
    var selectedIndexPath = 0
    
    
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

        dateFormatter.dateFormat = "yyyy년 MM월" // 월 표시 포맷 설정
        components.year = cal.component(.year, from: now)
        components.month = cal.component(.month, from: now)
        components.day = 1
        
        self.calculation()
    }
    
    private func calculation() { // 월 별 일 수 계산
        
        let firstDayOfMonth = cal.date(from: components)
        let firstWeekday = cal.component(.weekday, from: firstDayOfMonth!) // 해당 수로 반환. 1: 일요일 ~ 7: 토요일
        
        components.month! -= 1
        prevDayMax = cal.range(of: .day, in: .month, for: cal.date(from: components)!)!.count
        
        components.month! += 1
        day_Max = cal.range(of: .day, in: .month, for: firstDayOfMonth!)!.count // 8월: 1..<32

        
        // 요일
        weekdayAdding = 2 - firstWeekday
        
        self.yearMonthLabel.text = dateFormatter.string(from: firstDayOfMonth!)
        
        for day in weekdayAdding...(42 + weekdayAdding - 1) {
            if day < 1 {
                days[day + firstWeekday - 2] = [components.month! - 1, day + prevDayMax]
            } else if day <= day_Max {
                days[day + firstWeekday - 2] = [components.month!, day]
            } else {
                days[day + firstWeekday - 2] = [components.month! + 1, day - day_Max]
            }
        }
    }
    @IBAction func nextMonthBtn(_ sender: Any) {
        components.month = components.month! + 1
        self.calculation()
        
        if !isMonth {
            for i in 0...6 {
                weekDays[i] = days[i]
            }
            selectedDay = weekDays[cal.component(.weekday, from: cal.date(from: components)!) - 1]
            print(selectedDay)
        }

        self.collectionView.reloadData()
    }
    @IBAction func prevMonthBtn(_ sender: Any) {
        components.month = components.month! - 1
        self.calculation()
        
        if !isMonth {
            for i in 0...6 {
                weekDays[i] = days[i]
            }
            selectedDay = weekDays[cal.component(.weekday, from: cal.date(from: components)!) - 1]
            print(selectedDay)
        }
        
        self.collectionView.reloadData()
    }
    @IBAction func addAndMonthBtn(_ sender: Any) {
        if isMonth {    // 월간 화면일때 눌리면
            guard let uvc = self.storyboard?.instantiateViewController(identifier: "addPlanView") else{
                return
            }
            self.navigationController?.pushViewController(uvc, animated: true)
        } else {        // 주간 화면일때 눌리면
            addAndMonthBtn.setImage(UIImage(systemName: "plus"), for: .normal)
            isMonth.toggle()
            collectionView.reloadData()
        }
    }
}

extension CalendarViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isMonth {
            return 7 + 42
        } else {
            return 7 + 7
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        calculation()
        if indexPath.row < 7 {  // 주 이름
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dayCell", for: indexPath) as! DayCell
            cell.dayLabel.text = daylist[indexPath.row]
            cell.layer.borderWidth = 1
            cell.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1).cgColor
            return cell
        } else {
            if isMonth {    // 월간
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dateCell", for: indexPath) as! DateCell
                cell.layer.borderWidth = 1
                cell.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1).cgColor
                
                // 1 to 01
                if days[indexPath.row - 7][1] / 10 == 0 {
                    cell.dateLabel.text = "0\(days[indexPath.row - 7][1])"
                } else {
                    cell.dateLabel.text = "\(days[indexPath.row - 7][1])"
                }
                
                // 이전달 or 다음달 이면
                if days[indexPath.row - 7][0] < components.month!
                || days[indexPath.row - 7][0] > components.month!{
                    cell.dateLabel.textColor = #colorLiteral(red: 0.768627451, green: 0.768627451, blue: 0.768627451, alpha: 1)
                    
                    cell.taskCnt.backgroundColor = .white
                    cell.taskCnt.textColor = .white
                } else {    // 이번달 이면
                    cell.dateLabel.textColor = .black
                    // 오늘 날짜인 경우 색칠
                    if components.month == cal.component(.month, from: now) && days[indexPath.row - 7][1] == cal.component(.day, from: now) {
                        cell.dateLabel.clipsToBounds = true
                        cell.dateLabel.backgroundColor = .lightGray
                        cell.dateLabel.layer.cornerRadius = cell.dateLabel.frame.height/2
                    } else {
                        cell.dateLabel.backgroundColor = .white
                    }
                    
                    // 태스크 개수 표시
//                    cell.taskCnt.clipsToBounds = true
//                    cell.taskCnt.layer.cornerRadius = cell.taskCnt.frame.height / 2
//                    cell.taskCnt.backgroundColor = #colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1)
                    cell.taskCnt.textColor = .white
                }
                
                return cell
            } else {    // 주간
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "weekdateCell", for: indexPath) as! WeekDateCell
                cell.layer.borderWidth = 1
                cell.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1).cgColor

                if weekDays[indexPath.row - 7][1] < 10 {
                    cell.weekDateLabel.text = "0\(weekDays[indexPath.row - 7][1])"
                } else {
                    cell.weekDateLabel.text = "\(weekDays[indexPath.row - 7][1])"
                }
                
                if weekDays[indexPath.row-7] == selectedDay {
                    cell.backgroundColor = .lightGray
                } else {
                    cell.backgroundColor = .white
                }
                
                if weekDays[indexPath.row - 7][0] < components.month!
                || weekDays[indexPath.row - 7][0] > components.month! {
                    cell.weekDateLabel.textColor = .lightGray
                } else {
                    cell.weekDateLabel.textColor = .black
                }
                
                return cell
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row < 7 {
            return
        }
        if isMonth {
            addAndMonthBtn.setImage(UIImage(systemName: "calendar"), for: .normal)
            
            // 주간 날짜 배열 초기화
            let week = (indexPath.row - 7) / 7  // 몇째주
            for i in 0...6 {
                weekDays[i] = days[i + week * 7]
            }
            // 선택된 셀의 인덱스 저장
            selectedIndexPath = indexPath.row - 7
            
            // 월 설정
            if days[selectedIndexPath][0] < components.month! { // 이전달이면
                components.month = days[selectedIndexPath][0]
            } else if days[selectedIndexPath][0] > components.month! {  // 다음달이면
                components.month = days[selectedIndexPath][0]
            }

            selectedDay = days[selectedIndexPath]
            isMonth.toggle()
        } else {    // 주간에서 날짜 선택 -> 밑에 뷰 바뀌기
            selectedIndexPath = indexPath.row - 7
            selectedDay = weekDays[selectedIndexPath]
            
            if components.month != selectedDay[0]{
                components.month = selectedDay[0]
            }
        }
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
        if indexPath.row < 7 {
            return CGSize(width: 53, height: 22)
        }
        
        var size = CGSize()
        if isMonth {    // 월간 달력
            size = CGSize(width: 53, height: 105)
            collectionView.frame = CGRect(x: 20, y: 130, width: 374, height: 652)
            weekView.frame = CGRect(x: 20, y: 900, width: 374, height: 459)
        } else {        // 주간 달력
            size = CGSize(width: 53, height: 53)
            collectionView.frame = CGRect(x: 20, y: 130, width: 374, height: 75)
            weekView.frame = CGRect(x: 20, y: 200, width: 374, height: 459)
        }
        return size
    }
}
