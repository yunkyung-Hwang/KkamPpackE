//
//  WeekDateCell.swift
//  KkamPpackE
//
//  Created by 황윤경 on 2021/08/12.
//

import UIKit

class WeekDateCell: UICollectionViewCell {
    @IBOutlet weak var weekDateLabel: UILabel!
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                backgroundColor = .lightGray
            } else {
                backgroundColor = .clear
            }
        }
    }
}
