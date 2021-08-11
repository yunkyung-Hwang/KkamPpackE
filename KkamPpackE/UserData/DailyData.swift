//
//  DailyData.swift
//  KkamPpackE
//
//  Created by 황윤경 on 2021/08/09.
//
import UIKit

struct DailyData {
    // task 이름, 아이콘, 알람 개수,
    var name:String!
    var icon:UIImage!
    var day = [Bool](repeating: false, count: 7) // 일요일~토요일 : 0~6
    var dayCnt:Int!
    var alarmCnt:Int?
    
    // 이름, 아이콘, 요일, 하루 몇번, 알람 몇번, 선택 상태
    
    init(_ name:String, _ icon:UIImage, _ day:Array<Int>, _ dayCnt:Int, _ alarmCnt:Int) {
        self.name = name
        self.icon = icon
        
        for i in day {
            self.day[i] = true
        }
        
        self.dayCnt = dayCnt
        self.alarmCnt = alarmCnt
    }
}
