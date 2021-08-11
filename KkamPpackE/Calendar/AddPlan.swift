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
        
        planTitle.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: planTitle.frame.height))
        planTitle.leftViewMode = .always
        planTitle.layer.borderWidth = 1
        planTitle.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        planTitle.layer.cornerRadius = planTitle.frame.height / 2
        
        memoField.layer.borderWidth = 1
        memoField.layer.borderColor = UIColor.black.cgColor
        memoField.layer.cornerRadius = 10
    }
}
