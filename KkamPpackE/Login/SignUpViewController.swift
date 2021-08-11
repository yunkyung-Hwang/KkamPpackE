//
//  SignUpViewController.swift
//  KkamPpackE
//
//  Created by 황윤경 on 2021/08/08.
//

import UIKit

class SignUpViewController: UIViewController {
    @IBOutlet weak var idTF: UITextField!
    @IBOutlet weak var pwTF: UITextField!
    @IBOutlet weak var pwCheckTF: UITextField!
    @IBOutlet weak var nicknameTF: UITextField!
    @IBOutlet weak var signUpBtn: UIButton!
    
    override func viewDidLoad() {
        super .viewDidLoad()
        
        idTF.layer.borderWidth = 1
        idTF.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        idTF.layer.cornerRadius = idTF.frame.height/2
        idTF.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: idTF.frame.height))
        idTF.leftViewMode = .always
        
        pwTF.layer.borderWidth = 1
        pwTF.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        pwTF.layer.cornerRadius = pwTF.frame.height/2
        pwTF.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: pwTF.frame.height))
        pwTF.leftViewMode = .always
        
        pwCheckTF.layer.borderWidth = 1
        pwCheckTF.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        pwCheckTF.layer.cornerRadius = pwCheckTF.frame.height/2
        pwCheckTF.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: pwCheckTF.frame.height))
        pwCheckTF.leftViewMode = .always
        
        nicknameTF.layer.borderWidth = 1
        nicknameTF.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        nicknameTF.layer.cornerRadius = nicknameTF.frame.height/2
        nicknameTF.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: nicknameTF.frame.height))
        nicknameTF.leftViewMode = .always
        
        signUpBtn.layer.cornerRadius = signUpBtn.frame.height/2
        signUpBtn.backgroundColor = .lightGray
    }
    @IBAction func signUp(_ sender: Any) {
        // 조건 모두 충족하면 아이디비번 서버에 저장 & 화면 전환
    }
}
