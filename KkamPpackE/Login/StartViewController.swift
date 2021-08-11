//
//  LoginViewController.swift
//  KkamPpackE
//
//  Created by 황윤경 on 2021/08/08.
//

import UIKit

class StartViewController: UIViewController {
    @IBOutlet weak var basicLoginBtn: UIButton!
    @IBOutlet weak var kakaoLoginBtn: UIButton!
    
    override func viewDidLoad() {
        super .viewDidLoad()
        
        basicLoginBtn.layer.cornerRadius = basicLoginBtn.frame.height/2
        basicLoginBtn.backgroundColor = .lightGray
        
        kakaoLoginBtn.layer.cornerRadius = kakaoLoginBtn.frame.height/2
        kakaoLoginBtn.backgroundColor = .lightGray
    }
}
