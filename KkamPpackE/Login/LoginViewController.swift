//
//  LoginViewController.swift
//  KkamPpackE
//
//  Created by 황윤경 on 2021/08/08.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var idTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    
    override func viewDidLoad() {
        super .viewDidLoad()
        
        loginBtn.layer.cornerRadius = loginBtn.frame.height/2
        loginBtn.backgroundColor = .lightGray
        
        idTF.layer.borderWidth = 1
        idTF.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        idTF.layer.cornerRadius = idTF.frame.height/2
        idTF.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: idTF.frame.height))
        idTF.leftViewMode = .always
        
        passwordTF.layer.borderWidth = 1
        passwordTF.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        passwordTF.layer.cornerRadius = passwordTF.frame.height/2
        passwordTF.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: passwordTF.frame.height))
        passwordTF.leftViewMode = .always
        
        idTF.layer.cornerRadius = idTF.frame.height/2
    }
    @IBAction func login(_ sender: Any) {
        // 올바른 id인지 확인, 등록된 Id인지 확인, 다 맞으면 화면 전환
//        guard let id = idTF.text?.split(separator: "@") else return {}
        guard let homeBoard = self.storyboard?.instantiateViewController(identifier: "homeBoard") else { return }
        homeBoard.modalPresentationStyle = .fullScreen
        self.present(homeBoard, animated: true)
    }
}
