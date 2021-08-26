//
//  SelectDateViewController.swift
//  KkamPpackE
//
//  Created by 황윤경 on 2021/08/26.
//

import UIKit

class SelectDateViewController: UIViewController {
    @IBOutlet weak var nav: UINavigationBar!
    @IBOutlet weak var dateLabel: UILabel!
    let datePicker = UIDatePicker()
    
    var navTitle:String = ""
    
    override func viewDidLoad() {
        super .viewDidLoad()
        
        nav.setBackgroundImage(UIImage(), for: .default)
        nav.shadowImage = UIImage()
        nav.isTranslucent = true
        nav.backgroundColor = .clear
        
        nav.topItem?.title = navTitle

        
        let backBtn = UIButton(type: .system)
        backBtn.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        backBtn.setTitle("  취소", for: .normal)
        backBtn.titleLabel?.font = UIFont(name: "System", size: 20)
        backBtn.addTarget(self, action: #selector(closeModal), for: .touchUpInside)
        nav.topItem?.leftBarButtonItem = UIBarButtonItem(customView: backBtn)
        nav.topItem?.rightBarButtonItem = UIBarButtonItem(title: "다음", style: .plain, target: self, action: #selector(nextSelect))

        datePicker.preferredDatePickerStyle = .inline
        datePicker.datePickerMode = .date
        datePicker.tintColor = #colorLiteral(red: 1, green: 0, blue: 0, alpha: 1)
        
        datePicker.frame = CGRect(x: 0, y: 240, width: view.frame.width, height: 400)
        view.addSubview(datePicker)
        
        datePicker.addTarget(self, action: #selector(selectedDate(sender:)), for: .valueChanged)
    }
    @objc func nextSelect() {
        guard let selectVC = self.storyboard?.instantiateViewController(identifier: "timeSelectView") as? SelectTimeViewController else { return }
        
        selectVC.navTitle = navTitle
        
        present(selectVC, animated: true, completion: nil)
    }
    
    @objc func closeModal() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func selectedDate(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy년 MM월 dd일"
        
        let selectedDate = dateFormatter.string(from: sender.date)
        dateLabel.text = selectedDate
    }
}
