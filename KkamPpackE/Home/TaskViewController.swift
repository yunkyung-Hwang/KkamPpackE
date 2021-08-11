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
    
    let dayCount = ["1", "2", "3"]
    let alarmCount = ["없음","1", "2", "3"]
    
    let dayPicker = UIPickerView()
    let alarmPicker = UIPickerView()
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(true)
        tabBarController?.tabBar.isHidden = true
    }
    override func viewDidLoad() {
        super .viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "checkmark"), style: .plain, target: self, action: #selector(self.saveTask))
        navigationItem.rightBarButtonItem?.tintColor = .black
        
        
        taskImg.layer.cornerRadius = taskImg.frame.height / 2
        
        taskName.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: taskName.frame.height))
        taskName.leftViewMode = .always
        taskName.layer.borderWidth = 1
        taskName.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        taskName.layer.cornerRadius = taskName.frame.height / 2
        
        dayCnt.layer.borderWidth = 1
        dayCnt.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        dayCnt.layer.cornerRadius = taskName.frame.height / 2
        dayCnt.tintColor = .clear
        
        alarmCnt.layer.borderWidth = 1
        alarmCnt.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        alarmCnt.layer.cornerRadius = taskName.frame.height / 2
        alarmCnt.tintColor = .clear

        
        dayPicker.delegate = self
        alarmPicker.delegate = self
        dayPicker.dataSource = self
        alarmPicker.dataSource = self
        
        dayCnt.inputView = dayPicker
        alarmCnt.inputView = alarmPicker
        
        dismissPickerView()
    }
    
    @IBAction func selectIcon(_ sender: Any) {
        
    }
    
    @objc func saveTask(){
        print("저장됨")
        // 구조체 추가해서 서버에 전송
        // 연달아 추가 or 바로 나가지기 => 기획팀한테 물어보기
        // 나가면 생성되어있게
        HomeViewController.homeList.append(HomeData("창문", UIImage(named: "icon")!))
    }

    @objc func onPickDone() {
        dayCnt.resignFirstResponder()
        alarmCnt.resignFirstResponder()
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
