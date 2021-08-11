//
//  TaskViewController.swift
//  KkamPpackE
//
//  Created by 황윤경 on 2021/08/08.
//

import UIKit

class TaskViewController: UIViewController {
    @IBOutlet weak var taskImg: UIImageView!
    @IBOutlet weak var taskName: UITextField!
    @IBOutlet weak var dayCount: UIPickerView!
    @IBOutlet weak var alarmCnt: UIPickerView!
    
    var tmp = ""
    
    let dayCntData = ["1","2","3","4"]
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(true)
        
        tabBarController?.tabBar.isHidden = true
    }
    override func viewDidLoad() {
        super .viewDidLoad()
//        navigationController?.navigationBar.backgroundColor = .white
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "checkmark"), style: .plain, target: nil, action: #selector(save))
        navigationItem.rightBarButtonItem?.tintColor = .black
        
        
        taskImg.layer.cornerRadius = taskImg.frame.height / 2
        
        taskName.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: taskName.frame.height))
        taskName.leftViewMode = .always
        taskName.layer.borderWidth = 1
        taskName.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        taskName.layer.cornerRadius = taskName.frame.height / 2
        dayCount.delegate = self
        taskName.inputView = dayCount
        
//        let exitBtn = UIBarButtonItem()
//        exitBtn.title = "exit"
//        exitBtn.target = self
//        exitBtn.action = #selector(pickerExit)
//
//        let toolbar = UIToolbar()
//        toolbar.tintColor = .darkGray
//        /// toolbar는 높이만 정해주면 됨 (나머지는 고정된 값 할당) - 높이는 35가 적절
//        toolbar.frame = CGRect(x: 0, y: 0, width: 0, height: 35)
//        toolbar.setItems([exitBtn], animated: true)
//
//        taskName.inputAccessoryView = toolbar
        
    }
    @IBAction func asdf(_ sender: Any) {
        print(tmp)
    }
    //    @objc func pickerExit() {
//         self.view.endEditing(true)
//     }
    @objc func save(){
        print("저장됨")
    }
}
extension TaskViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dayCntData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        tmp = dayCntData[row]
        return dayCntData[row]
    }
    
}
