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
    
    var isMemoField = true
    override func viewDidLoad() {
        super .viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "checkmark"), style: .plain, target: self, action: #selector(self.saveTask))
        navigationItem.rightBarButtonItem?.tintColor = .black
        
        
        planTitle.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: planTitle.frame.height))
        planTitle.leftViewMode = .always
        planTitle.layer.borderWidth = 1
        planTitle.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        planTitle.layer.cornerRadius = planTitle.frame.height / 2
        planTitle.delegate = self
        
        let date = DateFormatter()
        date.dateFormat = "YYYY년 MM월 dd일 hh:mm a"
        
        startDate.layer.borderWidth = 1
        startDate.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1).cgColor
        startDate.layer.cornerRadius = startDate.frame.height / 2
        startDate.backgroundColor = .white
        startDate.setTitle(date.string(from: Date()), for: .normal)
        startDate.titleLabel?.font = UIFont(name: "System", size: 16)
        startDate.setTitleColor(.black, for: .normal)
        
        endDate.layer.borderWidth = 1
        endDate.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1).cgColor
        endDate.layer.cornerRadius = startDate.frame.height / 2
        endDate.backgroundColor = .white
        endDate.setTitle(date.string(from: Date()), for: .normal)
        endDate.titleLabel?.font = UIFont(name: "System", size: 16)
        endDate.setTitleColor(.black, for: .normal)
        
        memoField.layer.borderWidth = 1
        memoField.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1).cgColor
        memoField.layer.cornerRadius = 10
        memoField.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        NotificationCenter.default.addObserver(self, selector: #selector(KeyBoardwillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(KeyBoardwillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    @objc func saveTask(){
        print("저장됨")
        // 구조체 추가해서 서버에 전송
        navigationController?.popViewController(animated: true)
    }
    @objc func KeyBoardwillShow(_ noti : Notification ){
        if isMemoField {
            view.transform = CGAffineTransform(translationX: 0, y: -250)
        }
    }
    
    @objc func KeyBoardwillHide(_ noti : Notification ){
        view.transform = .identity
        isMemoField = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.view.endEditing(true)
    }
    
    @IBAction func selectStartDate(_ sender: Any) {
        guard let selectVC = self.storyboard?.instantiateViewController(identifier: "dateSelectView") as? SelectDateViewController else { return }
        
        selectVC.navTitle = "시작일"
        
        present(selectVC, animated: true, completion: nil)
    }
    @IBAction func selectEndDate(_ sender: Any) {
        guard let selectVC = self.storyboard?.instantiateViewController(identifier: "dateSelectView") as? SelectDateViewController else { return }
        
        selectVC.navTitle = "종료일"
        
        present(selectVC, animated: true, completion: nil)
    }
}
extension AddPlan: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == planTitle {
            isMemoField = false
        }
        return true
    }
}
