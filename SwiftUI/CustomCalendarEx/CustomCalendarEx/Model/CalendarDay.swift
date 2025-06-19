//
//  CalendarDay.swift
//  CustomCalendarEx
//
//  Created by jaewon Lee on 6/19/25.
//

import Foundation

struct CalendarDay: Identifiable {
    var id: UUID = .init()
    let day: Int
    let date: Date
    let isCurrentMonth: Bool
    let isHoliday: Bool
}
