//
//  HomeData.swift
//  KkamPpackE
//
//  Created by 황윤경 on 2021/08/09.
//
import UIKit

struct HomeData {
    // task 이름, 아이콘
    var name:String!
    var icon:UIImage!
    
    init(_ name:String, _ icon:UIImage) {
        self.name = name
        self.icon = icon
    }
}
