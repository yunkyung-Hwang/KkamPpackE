//
//  dayCell.swift
//  KkamPpackE
//
//  Created by 황윤경 on 2021/08/15.
//

import UIKit

class WeekDayCell: UICollectionViewCell {
    @IBOutlet weak var dayLabel: UILabel!
    
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
