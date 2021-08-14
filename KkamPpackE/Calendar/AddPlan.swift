//
//  AddPlan.swift
//  KkamPpackE
//
//  Created by 황윤경 on 2021/08/11.
//

import UIKit

class AddPlan: UIViewController {
    @IBOutlet weak var planTitle: UITextField!
    @IBOutlet weak var startDate: UIButton!
    @IBOutlet weak var endDate: UIButton!
    
    @IBOutlet weak var memoField: UITextView!
    override func viewDidLoad() {
        super .viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "checkmark"), style: .plain, target: self, action: #selector(self.saveTask))
        navigationItem.rightBarButtonItem?.tintColor = .black
        
        
        planTitle.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: planTitle.frame.height))
        planTitle.leftViewMode = .always
        planTitle.layer.borderWidth = 1
        planTitle.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        planTitle.layer.cornerRadius = planTitle.frame.height / 2
        
        let date = DateFormatter()
        date.dateFormat = "YYYY년 MM월 dd일"
        
        startDate.layer.borderWidth = 1
        startDate.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1).cgColor
        startDate.layer.cornerRadius = startDate.frame.height / 2
        startDate.backgroundColor = .white
        startDate.setTitle(date.string(from: Date()), for: .normal)
        startDate.setTitleColor(.black, for: .normal)
        
        endDate.layer.borderWidth = 1
        endDate.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1).cgColor
        endDate.layer.cornerRadius = startDate.frame.height / 2
        endDate.backgroundColor = .white
        endDate.setTitle(date.string(from: Date()), for: .normal)
        endDate.setTitleColor(.black, for: .normal)
        
        memoField.layer.borderWidth = 1
        memoField.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1).cgColor
        memoField.layer.cornerRadius = 10
    }
    @objc func saveTask(){
        print("저장됨")
        // 구조체 추가해서 서버에 전송
        navigationController?.popViewController(animated: true)
    }
}
