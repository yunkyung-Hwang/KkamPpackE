//
//  MemoCell.swift
//  KkamPpackE
//
//  Created by 황윤경 on 2021/08/09.
//

import UIKit

class MemoCell: UICollectionViewCell {
    @IBOutlet weak var memoName: UILabel!
    @IBOutlet weak var memoContext: UILabel!
    @IBOutlet weak var memoEditBtn: UIButton!
    
    var menuItems: [UIAction] {
        return [
            UIAction(title: "일정 편집", image: UIImage(systemName: "doc.on.doc"), handler: {[self] _ in list(edit: "edit")}),

            UIAction(title: "삭제", image: UIImage(systemName: "trash"), attributes: .destructive, handler: {[self] _ in list(edit: "remove")})
        ]
    }
    var menu: UIMenu {
        return UIMenu(title: "", image: UIImage(systemName: "ellipsis"), identifier: nil, options: [], children: menuItems)
    }

    func list(edit:String) {
        if edit == "edit" {
        } else if edit == "order" {
        } else if edit == "remove" {
        }
    }
}
