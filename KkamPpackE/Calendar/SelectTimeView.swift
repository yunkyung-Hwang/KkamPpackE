//
//  SelectTimeView.swift
//  KkamPpackE
//
//  Created by 황윤경 on 2021/08/27.
//

import UIKit

class SelectTimeViewController: UIViewController {
    @IBOutlet weak var nav: UINavigationBar!
    
    @IBOutlet weak var timePicker: UIDatePicker!
    @IBOutlet weak var timeLabel: UILabel!
    
    var navTitle = ""
    
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
        nav.topItem?.rightBarButtonItem = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(done))
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        timePicker.date = dateFormatter.date(from: "09:00 AM")!
        
        timePicker.addTarget(self, action: #selector(selectTime(sender:)), for: .valueChanged)
    }
    @objc func done() {
        var initialPresentingViewController = self.presentingViewController
        while let previousPresentingViewController = initialPresentingViewController?.presentingViewController {
            initialPresentingViewController = previousPresentingViewController
        }
        
        if let snapshot = view.snapshotView(afterScreenUpdates: true) {
            initialPresentingViewController?.presentedViewController?.view.addSubview(snapshot)
        }
        
        initialPresentingViewController?.dismiss(animated: true)
    }
    
    @objc func closeModal() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func selectTime(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        
        let selectedTime = dateFormatter.string(from: sender.date)
        timeLabel.text = selectedTime
    }
}

