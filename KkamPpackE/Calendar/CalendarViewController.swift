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
    var days: [[Int]] = []
    var day_Max = 0 // 해당 월이 며칠까지 있는지
    var prevDayMax = 0
    var weekdayAdding = 0 // 시작일
    let today = DateFormatter()
    
    var selectedDate = [0,0]    // [월, 일]
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
        
        today.dateFormat = "dd"

        dateFormatter.dateFormat = "yyyy년 MM월" // 월 표시 포맷 설정
        components.year = cal.component(.year, from: now)
        components.month = cal.component(.month, from: now)
        components.day = 1
        self.calculation()
        
//        print("now: ",now, "\ncal:", cal, "\ndateFormatter:", dateFormatter, "\ncomponents: ", components)
    }
    
    private func calculation() { // 월 별 일 수 계산
        
        var firstDayOfMonth = cal.date(from: components)
        let firstWeekday = cal.component(.weekday, from: firstDayOfMonth!) // 해당 수로 반환. 1: 일요일 ~ 7: 토요일
        
        day_Max = cal.range(of: .day, in: .month, for: firstDayOfMonth!)!.count // 8월: 1..<32
        
        // 이전달 설정
        components.month = components.month! - 1
        firstDayOfMonth = cal.date(from: components)
        prevDayMax = cal.range(of: .day, in: .month, for: firstDayOfMonth!)!.count
        // 다시 이번달 기준
        components.month = components.month! + 1
        firstDayOfMonth = cal.date(from: components)
        
        // 요일
        weekdayAdding = 2 - firstWeekday
        
        self.yearMonthLabel.text = dateFormatter.string(from: firstDayOfMonth!)
        self.days.removeAll()
        for day in weekdayAdding...42 {
            if day < 1 { // 1보다 작을 경우는 비워줘야 하기 때문에 빈 값을 넣어준다.
                self.days.append([components.month! - 1, day + prevDayMax])
            } else if day <= day_Max {
                self.days.append([components.month!, day])
            } else {
                self.days.append([components.month! + 1, day - day_Max])
            }
        }
//        print(days)
    }
    @IBAction func nextMonthBtn(_ sender: Any) {
        components.month = components.month! + 1
        self.calculation()
        self.collectionView.reloadData()
    }
    @IBAction func prevMonthBtn(_ sender: Any) {
        components.month = components.month! - 1
        self.calculation()
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
                if days[indexPath.row - 7][1]/10 == 0 {
                    cell.dateLabel.text = "0"+String(days[indexPath.row - 7][1])
                } else {
                    cell.dateLabel.text = String(days[indexPath.row - 7][1])
                }
                
                // 이전달 남은 일자
                if indexPath.row - 7 < cal.component(.weekday, from: cal.date(from: components)!) - 1 {
                    cell.dateLabel.textColor = #colorLiteral(red: 0.768627451, green: 0.768627451, blue: 0.768627451, alpha: 1)
                    
                    cell.taskCnt.backgroundColor = .white
                    cell.taskCnt.textColor = .white
                }
                // 이번달 일자
                else if indexPath.row - 7 < day_Max + cal.component(.weekday, from: cal.date(from: components)!) - 1 {
                    cell.dateLabel.textColor = .black
                    // 오늘 날짜인 경우 색칠
                    if components.month == cal.component(.month, from: now) && String(days[indexPath.row - 7][1]) == today.string(from: Date()) {
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
                // 다음달 남은 일자
                else {
                    cell.dateLabel.textColor = #colorLiteral(red: 0.768627451, green: 0.768627451, blue: 0.768627451, alpha: 1)
                    
                    cell.taskCnt.backgroundColor = .white
                    cell.taskCnt.textColor = .white
                }
                
                return cell
            } else {    // 주간
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "weekdateCell", for: indexPath) as! WeekDateCell
                cell.layer.borderWidth = 1
                cell.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1).cgColor
                
//                cell.weekDateLabel.text = "\(days[selectedIndexPath][1])"
                
                if days[selectedIndexPath][0] < components.month! { // 이전달이면
                    components.month = days[selectedIndexPath][0]
                    print(components.month!)
                } else if days[selectedIndexPath][0] > components.month! {  // 다음달이면
                    components.month = days[selectedIndexPath][0]
                    print(components.month!)
                } else {    // 이번달이면
                    print(components.month!)
                }
                
//                if selectedIndexPath / 7 == 0 {
//                    cell.weekDateLabel.text = "\(days[selectedIndexPath][1] + indexPath.row)"
//                }
                
                // 선택된 셀의 날짜값이 존재하면 (""포함) 그거로 넣고 없으면 자동 ""
                // 선택된 셀의
//                if indexPath.row - 7 == selectedIndexPath {
//                    if selectedDate[1] < 10 {
//                        cell.weekDateLabel.text = "0\(selectedDate[1])"
//                    } else {
//                        cell.weekDateLabel.text = "\(selectedDate[1])"
//                    }
//                    cell.weekDateLabel.textColor = .black
//                    cell.backgroundColor = .lightGray
//                } else {
////                    components.month = components.month! - 1
////                    var firstDayOfMonth = cal.date(from: components)
////                    let lastDayOfPrevMonth = cal.range(of: .day, in: .month, for: firstDayOfMonth!)!.count
////
////                    components.month = components.month! + 1
////                    firstDayOfMonth = cal.date(from: components)
//
//                    let day = selectedDate[1] - selectedIndexPath + indexPath.row - 7
////                    print(day, day_Max)
////                    print("day", day)
////                    print(lastDayOfPrevMonth)
////                    print(prevDayMax)
//                    // MARK: 수정 필요
//                    // 이전달의 요일을 누른건지 이번 달의 요일을 누른건지 구분하기
//                    if day <= 0 {
//                        if prevDayMax + day < 10 {
//                            print(prevDayMax+day,day)
//                            cell.weekDateLabel.text = "0\(prevDayMax + day)"
//                        } else {
//                            cell.weekDateLabel.text = "\(prevDayMax + day)"
//                        }
//                        cell.weekDateLabel.textColor = #colorLiteral(red: 0.768627451, green: 0.768627451, blue: 0.768627451, alpha: 1)
////                        print("aaa ")
//                    } else if day > day_Max{
//                        if day - day_Max < 10 {
//                            cell.weekDateLabel.text = "0\(day - day_Max)"
//                        } else {
//                            cell.weekDateLabel.text = "\(day - day_Max)"
//                        }
////                        cell.weekDateLabel.text = "\(day - day_Max)"
//                        cell.weekDateLabel.textColor = #colorLiteral(red: 0.768627451, green: 0.768627451, blue: 0.768627451, alpha: 1)
////                        print("bbb ", cell.weekDateLabel.text!)
//                    } else {
//                        if day < 10 {
//                            cell.weekDateLabel.text = "0\(day)"
//                        } else {
//                            cell.weekDateLabel.text = "\(day)"
//                        }
//                        cell.weekDateLabel.textColor = .black
//                    }
//                    cell.backgroundColor = .white
//                }
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
            
            let cell = collectionView.cellForItem(at: indexPath) as! DateCell
//            selectedDate = days[indexPath.row]
            selectedDate[1] = Int(cell.dateLabel.text!)!
            
//            if selectedDate[0] < components.month! {    // 이전달
//                print("prevMonth")
//            } else if selectedDate[0] > components.month! { // 다음달
//                print("nextMonth")
//            } else {
//                print("thisMonth")
//            }
            // MARK: 수정 필요
            if indexPath.row > 35 && Int(cell.dateLabel.text!)! < 7 {   // 이번달 뷰에서 다음달 초를 눌렀을 때
                prevDayMax = day_Max
                print("aaa")
//                prevDayMax = cal.range(of: .day, in: .month, for: firstDayOfMonth!)!.count
//                prevDayMax = selectedDate[0]-1
            }else if indexPath.row - 7 < 7 && Int(cell.dateLabel.text!)! > 24 {   // 이번달 뷰에서 이전달 말을 눌렀을 때
                day_Max = prevDayMax
                print("bbb")
//                day_Max = selectedDate[0]
            } else {
                var firstDayOfMonth = cal.date(from: components)
                day_Max = cal.range(of: .day, in: .month, for: firstDayOfMonth!)!.count

                components.month = components.month! - 1
                firstDayOfMonth = cal.date(from: components)
                prevDayMax = cal.range(of: .day, in: .month, for: firstDayOfMonth!)!.count

                components.month = components.month! + 1
                firstDayOfMonth = cal.date(from: components)
            }
//            selectedIndexPath = indexPath.row % 7
            selectedIndexPath = indexPath.row - 7
            isMonth.toggle()
        } else {
//            let cell = collectionView.cellForItem(at: indexPath) as! WeekDateCell
//            print(cell.weekDateLabel.text!)
//            cell.backgroundColor = .lightGray
        }
        print(selectedIndexPath, days[selectedIndexPath][1])
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
