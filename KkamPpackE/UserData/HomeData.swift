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
    var day = [Bool](repeating: false, count: 7) // 일요일~토요일 : 0~6
    var dayCnt:Int!
    var alarmCnt:Int!
    var recordState:Bool!
    
    init(_ name:String, _ icon:UIImage, _ day:Array<Bool>, _ dayCnt:Int, _ alarmCnt:Int, _ state:Bool) {
        self.name = name
        self.icon = icon
        for i in 0..<day.count {
            self.day[i] = day[i]
        }
        self.dayCnt = dayCnt
        self.alarmCnt = alarmCnt
        self.recordState = state
    }
}
