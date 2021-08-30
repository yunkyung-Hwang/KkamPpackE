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
                backgroundColor = #colorLiteral(red: 0.7450980392, green: 0.6078431373, blue: 0.4666666667, alpha: 1)
                dayLabel.textColor = .white
            } else {
                backgroundColor = .clear
                dayLabel.textColor = .black
            }
        }
    }
}
