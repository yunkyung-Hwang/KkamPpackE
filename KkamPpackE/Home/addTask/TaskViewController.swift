//
//  TaskViewController.swift
//  KkamPpackE
//
//  Created by 황윤경 on 2021/08/08.
//

import UIKit

class TaskViewController: UIViewController {
    @IBOutlet weak var taskImg: UIButton!
    @IBOutlet weak var taskName: UITextField!
    @IBOutlet weak var dayCnt: UITextField!
    @IBOutlet weak var alarmCnt: UITextField!
    @IBOutlet weak var recordState: UISwitch!
    
    @IBOutlet weak var daysCollectionView: UICollectionView!
    @IBOutlet weak var timeCollectionView: UICollectionView!
    
    @IBOutlet weak var recordLabelAnchor: NSLayoutConstraint!
    @IBOutlet weak var recordToggleAnchor: NSLayoutConstraint!
    
    
    var receivedImg = UIImage()
    var receivedName = ""
    var receivedChosedDay = [true, true, true, true, true, true, true]
    var receivedDayCnt = 1
    var receivedAlarmCnt = 1
    var receivedState = true
    
    let days = ["일","월","화","수","목","금","토"]
    let dayCount = ["1", "2", "3"]
    let alarmCount = ["없음","1", "2", "3"]
    var alarmTime = ["09:00"]
    var isAlarmTF = false
    
    let dateFormatter = DateFormatter()
    
    let dayPicker = UIPickerView()
    let alarmPicker = UIPickerView()
    let timePicker = UIDatePicker()
    let timePicker2 = UIDatePicker()
    let timePicker3 = UIDatePicker()
    
    // 전송용 변수
    var selectedDays = [false,false,false,false,false,false,false]
    
    override func viewWillDisappear(_ animated: Bool) {
        super .viewWillDisappear(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(true)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super .viewDidLoad()
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.view.backgroundColor = .clear
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.backward"), style: .plain, target: self, action: #selector(self.closeTask))
        navigationItem.leftBarButtonItem?.tintColor = .black
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "checkmark"), style: .plain, target: self, action: #selector(self.saveTask))
        navigationItem.rightBarButtonItem?.tintColor = .black
        
        taskImg.layer.cornerRadius = taskImg.frame.height / 2
        taskImg.layer.borderWidth = 1
        taskImg.layer.borderColor = #colorLiteral(red: 0.862745098, green: 0.8235294118, blue: 0.7843137255, alpha: 1)
        
        taskName.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: taskName.frame.height))
        taskName.leftViewMode = .always
        taskName.layer.borderWidth = 1
        taskName.layer.borderColor = #colorLiteral(red: 0.862745098, green: 0.8235294118, blue: 0.7843137255, alpha: 1)
        taskName.layer.cornerRadius = taskName.frame.height / 2
        taskName.backgroundColor = .white
        taskName.delegate = self
        
        daysCollectionView.dataSource = self
        daysCollectionView.delegate = self
        daysCollectionView.allowsMultipleSelection = true
        
        dayCnt.layer.borderWidth = 1
        dayCnt.layer.borderColor = #colorLiteral(red: 0.862745098, green: 0.8235294118, blue: 0.7843137255, alpha: 1)
        dayCnt.layer.cornerRadius = taskName.frame.height / 2
        dayCnt.tintColor = .clear
        dayCnt.backgroundColor = .white
        
        alarmCnt.layer.borderWidth = 1
        alarmCnt.layer.borderColor = #colorLiteral(red: 0.862745098, green: 0.8235294118, blue: 0.7843137255, alpha: 1)
        alarmCnt.layer.cornerRadius = taskName.frame.height / 2
        alarmCnt.tintColor = .clear
        alarmCnt.backgroundColor = .white
        alarmCnt.text = "1"
        alarmCnt.delegate = self
        
        
        timeCollectionView.dataSource = self
        timeCollectionView.delegate = self
        timeCollectionView.collectionViewLayout = UICollectionViewFlowLayout()
        if let layout = timeCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
        }
        
        dayPicker.delegate = self
        alarmPicker.delegate = self
        dayPicker.dataSource = self
        alarmPicker.dataSource = self
        
        dateFormatter.dateFormat = "hh:mm a"
        timePicker.preferredDatePickerStyle = .wheels
        timePicker.datePickerMode = .time
        timePicker2.preferredDatePickerStyle = .wheels
        timePicker2.datePickerMode = .time
        timePicker3.preferredDatePickerStyle = .wheels
        timePicker3.datePickerMode = .time
        
        dayCnt.inputView = dayPicker
        alarmCnt.inputView = alarmPicker
        
        dismissPickerView()
        
        
        // 초기값 설정
        if receivedImg == UIImage() {
            taskImg.setImage(iconImgList.randomElement()!, for: .normal)
//            taskImg.setImage(UIImage(named: "icon"), for: .normal)
        } else {
            taskImg.setImage(receivedImg, for: .normal)
        }
        taskName.text = self.receivedName

        for i in 0...6 {
            if receivedChosedDay[i] {
                daysCollectionView.selectItem(at: [0,i], animated: false, scrollPosition: .init())
            }
        }
        
        dayCnt.text = "\(receivedDayCnt)"
        
        if receivedAlarmCnt == 0{
            alarmCnt.text = "없음"
        } else {
            alarmCnt.text = "\(receivedAlarmCnt)"
        }
        
        onPickDone()
        
        recordState.isOn = receivedState

        funcaddObservser()
    }

    
    func funcaddObservser() {
        NotificationCenter.default.addObserver(self, selector: #selector(KeyBoardwillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(KeyBoardwillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func KeyBoardwillShow(_ noti : Notification ){
        if isAlarmTF {
            view.transform = CGAffineTransform(translationX: 0, y: -125)
        }
    }
    
    @objc func KeyBoardwillHide(_ noti : Notification ){
        view.transform = .identity
        isAlarmTF = false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.view.endEditing(true)
    }
    @objc func closeTask() {
        let actionSheetController = UIAlertController(title: "", message: "종료하시겠습니까?\n작성된 내용은 저장되지 않습니다.", preferredStyle: .alert)
        let reset = UIAlertAction(title: "종료", style: .default) { (action) in
            self.navigationController?.popViewController(animated: true)
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel) { action -> Void in }

        actionSheetController.addAction(reset)
        actionSheetController.addAction(cancelAction)

        self.present(actionSheetController, animated: true, completion: nil)
    }
    @objc func saveTask(){
        self.view.endEditing(true)
        // 요일 저장
        if let day = daysCollectionView.indexPathsForSelectedItems {
            for i in 0..<day.count {
                selectedDays[day[i].row] = true
            }
        }
        // 편집상태로 들어왔을 때
        if HomeViewController.isEdit {
            let indexPath = HomeViewController.selectedTaskIndexPath
            if HomeViewController.isHomeCollectionView {
                HomeViewController.homeList[indexPath].icon = taskImg.image(for: .normal)
                HomeViewController.homeList[indexPath].name = taskName.text
                HomeViewController.homeList[indexPath].day = selectedDays
                HomeViewController.homeList[indexPath].dayCnt = Int(dayCnt.text!)
                if alarmCnt.text == "없음" {
                    HomeViewController.homeList[indexPath].alarmCnt = 0
                } else {
                    HomeViewController.homeList[indexPath].alarmCnt = Int(alarmCnt.text!)
                }
                HomeViewController.homeList[indexPath].recordState = recordState.isOn
                
            } else {
                HomeViewController.dailyList[indexPath].icon = taskImg.image(for: .normal)
                HomeViewController.dailyList[indexPath].name = taskName.text
                HomeViewController.dailyList[indexPath].day = selectedDays
                HomeViewController.dailyList[indexPath].dayCnt = Int(dayCnt.text!)
                if alarmCnt.text == "없음" {
                    HomeViewController.dailyList[indexPath].alarmCnt = 0
                } else {
                    HomeViewController.dailyList[indexPath].alarmCnt = Int(alarmCnt.text!)
                }
                HomeViewController.dailyList[indexPath].recordState = recordState.isOn
            }
        }
        // 태스크 추가 상태로 들어왔을 떄
        else {
            // 값을 제대로 입력하지 않았을 때
            if taskName.text == "" || selectedDays.count == 0 || dayCnt.text == "" || alarmCnt.text == "" {
                
                let alert = UIAlertController(title: "제목을 입력해주세요", message: "", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "확인", style: .cancel, handler: nil))
                
                self.present(alert, animated: true, completion: nil)
            } else {    // 태스크 추가
                if HomeViewController.isHomeCollectionView {
                    HomeViewController.homeList.append(HomeData(taskName.text!, UIImage(named: "icon")!, selectedDays, Int(dayCnt.text!)!,Int(alarmCnt.text!)!, recordState.isOn))
                } else {
                    HomeViewController.dailyList.append(DailyData(taskName.text!, UIImage(named: "icon")!, selectedDays, Int(dayCnt.text!)!, Int(alarmCnt.text!)!, recordState.isOn))
                }
            }
        }
        navigationController?.popViewController(animated: true)
    }
    
    @objc func onPickDone() {
        if alarmCnt.text == "없음" {
            alarmTime.removeAll()
        } else if alarmCnt.text == "1" {
            alarmTime = ["09:00 AM"]
        } else if alarmCnt.text == "2" {
            alarmTime = ["09:00 AM", "12:00 PM"]
        } else {//if alarmCnt.text == "3" {
            alarmTime = ["09:00 AM", "12:00 PM", "06:00 PM"]
        }
        timeCollectionView.reloadData()
        
        dayCnt.resignFirstResponder()
        alarmCnt.resignFirstResponder()
    }
    
    @objc func onTimePickDone() {
        var selectedDate = dateFormatter.string(from: timePicker.date)
        alarmTime[0] = selectedDate
        
        if alarmTime.count == 2 {
            selectedDate = dateFormatter.string(from: timePicker2.date)
            alarmTime[1] = selectedDate
        } else if alarmTime.count == 3 {
            selectedDate = dateFormatter.string(from: timePicker2.date)
            alarmTime[1] = selectedDate
            
            selectedDate = dateFormatter.string(from: timePicker3.date)
            alarmTime[2] = selectedDate
        }
        print(alarmTime)
        timeCollectionView.reloadData()
    }

    func dismissPickerView() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let button = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(self.onPickDone))
        toolBar.setItems([space, button], animated: true)
        toolBar.isUserInteractionEnabled = true
        
        alarmCnt.inputAccessoryView = toolBar
        dayCnt.inputAccessoryView = toolBar
    }
}

extension TaskViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if pickerView == dayPicker {
            return dayCount.count
        } else {
            return alarmCount.count
        }

    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if pickerView == dayPicker {
            return dayCount[row]
        } else {
            return alarmCount[row]
        }
    }


    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == dayPicker {
            dayCnt.text = dayCount[row]
        } else {
            alarmCnt.text = alarmCount[row]
        }
    }
}

extension TaskViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == daysCollectionView {
            return 7
        } else {
            if alarmTime.count == 0 {
                recordLabelAnchor.constant = 108
                recordToggleAnchor.constant = 103
            } else {
                recordLabelAnchor.constant = 50
                recordToggleAnchor.constant = 45
            }
            return alarmTime.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == daysCollectionView {
            let cell = daysCollectionView.dequeueReusableCell(withReuseIdentifier: "dayCell", for: indexPath) as! WeekDayCell
            cell.layer.cornerRadius = cell.frame.height / 2
            
            cell.dayLabel.text = days[indexPath.row]
            if indexPath.row == 0 {
                cell.dayLabel.textColor = .red
            } else if indexPath.row == 6 {
                cell.dayLabel.textColor = .blue
            }
            return cell
        } else {
            let cell = timeCollectionView.dequeueReusableCell(withReuseIdentifier: "timeCell", for: indexPath) as! TimeCell
            cell.layer.borderWidth = 1
            cell.layer.borderColor = #colorLiteral(red: 0.862745098, green: 0.8235294118, blue: 0.7843137255, alpha: 1)
            cell.layer.cornerRadius = cell.frame.height / 2
            cell.backgroundColor = .white
            cell.timeTField.text = alarmTime[indexPath.row]
            
            let toolBar = UIToolbar()
            toolBar.sizeToFit()
            let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
            let button = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(self.onTimePickDone))
            toolBar.setItems([space, button], animated: true)
            toolBar.isUserInteractionEnabled = true
            cell.timeTField.inputAccessoryView = toolBar
            
            if indexPath.row == 0 {
                if let time = dateFormatter.date(from: alarmTime[indexPath.row]) {
                    cell.timeTField.inputView = timePicker
                    timePicker.date = time
                }
            } else if indexPath.row == 1 {
                if let time2 = dateFormatter.date(from: alarmTime[indexPath.row]) {
                    cell.timeTField.inputView = timePicker2
                    timePicker2.date = time2
                }
            } else {
                if let time3 = dateFormatter.date(from: alarmTime[indexPath.row]) {
                    cell.timeTField.inputView = timePicker3
                    timePicker3.date = time3
                }
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.view.endEditing(true)
        
        if collectionView == daysCollectionView {
            let cell = daysCollectionView.cellForItem(at: indexPath) as! WeekDayCell
            cell.isSelected.toggle()
        }
    }
}

extension TaskViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        if collectionView == daysCollectionView {
            return (collectionView.frame.width - 44 * 7) / 6
        } else {
            return 0
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        if collectionView == daysCollectionView {
            let width = 44
            let size = CGSize(width: width, height: width)
            return size
        } else {
            let size = CGSize(width: 113, height: 47)
            return size
        }
    }
}

extension TaskViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return false }
        
        if text.count >= 6 && range.length == 0 {
            return false
        }
        
        return true
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == alarmCnt {
            isAlarmTF = true
        }
        return true
    }
}
