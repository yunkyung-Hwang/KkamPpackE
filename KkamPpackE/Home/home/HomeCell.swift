//
//  HomeCell.swift
//  KkamPpackE
//
//  Created by 황윤경 on 2021/08/08.
//

import UIKit

class HomeCell: UICollectionViewCell {
    @IBOutlet weak var taskImg: UIImageView!
    @IBOutlet weak var taskName: UILabel!
    @IBOutlet weak var taskEdit: UIImageView!

    var tappedCnt: Int = 0
}
