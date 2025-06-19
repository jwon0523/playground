//
//  ContentsViewModel.swift
//  CustomCalendarEx
//
//  Created by jaewon Lee on 6/19/25.
//

import SwiftUI
import Moya

@Observable
class ContentsViewModel {
    var provider =  MoyaProvider<HolidayAPITarget>(
        plugins: [NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))]
    )
    var currentMonth: Date // 현재 보고 있는 달의 기준 날짜
    var selectedDate: Date // 사용자가 현재 선택한 날짜
    var holidayDates: Set<Date> = [] // 공휴일 날짜들을 저장하는 집합, 특정 날짜가 공휴일인지 빠르게 판단할 수 있게 합니다.
    var calendar: Calendar // 날짜 계싼을 위한 Calendar 객체
    
    var currentMonthYear: Int { // 현재 보고 있는 연도를 계산해서 연도로 반환
        Calendar.current.component(.year, from: currentMonth)
    }
    
    private var lastRequestedYear: Int? // 이전 요청한 공휴일 연도를 저장하는 변수, API로 공휴일 가져올 때 같은 연도에 중복 요청하지 않기 위한 용도로 사용
    var isLoading: Bool = false // 공휴일 데이터 불러오고 있는 중인지 판단
    
    var getHolidaySwitch: Bool = true // 공휴일 API 요청 여부를 켜거나 끌 수 있는 스위치
    
    init(currentMonth: Date = Date(), selectedDate: Date = Date(), calendar: Calendar = Calendar.current) {
        self.currentMonth = currentMonth
        self.selectedDate = selectedDate
        self.calendar = calendar
    }
    
    
    /// 현재 보고 있는 월을 앞/뒤로 이동합니다
    /// - Parameter value: 양수면 다음 달, 음수면 이전 달로 이동해요!, currentMonth를 새로 계산된 월로 갱신합니다.
    func changeMonth(by value: Int) {
        let calendar = Calendar.current
        if let newMonth = calendar.date(byAdding: .month, value: value, to: currentMonth) {
            currentMonth = newMonth
        }
    }
    
    /// 달력 그리드를 구성하는 CalendarDay 배열을 생성합니다.
    /// - Returns: 달력에 표시할 날짜들을 CalendarDay 배열로 생성합니다. 뷰에서 LazyVGrid를 통해 달력 UI를 구성할거에요!
    func daysForCurrentGrid() -> [CalendarDay] {
        let calendar = Calendar.current
        /*
         현재 월의 정보를 계산합니다.
         이 달의 첫 날짜를 기준으로 시작 요일, 일 수 계산을 합니다.
        */
        let firstDay = firstDayOfMonth()
        let firstWeekDay = calendar.component(.weekday, from: firstDay)
        let daysInMonth = numberOfDays(in: currentMonth)
        
        var days: [CalendarDay] = []
        
        /*
         이번 달이 무슨 요일에 시작하는지에 따라, 앞에 몇 개의 셀을 이전 달의 날짜로 채울지 계산합니다.
         */
        let leadingDays = (firstWeekDay - calendar.firstWeekday + 7) % 7
        
        /*
         달력은 보통 7일 단위 그리드로 구성됩니다.
         어떤 달이 수요일에 시작한다면 앞의 일/월/화는 빈공간이 아닌 이전 달의 날짜로 미리보기로 보이도록 할 수 있죠!
         그래서 이 코드는 그 앞 부분 회색을 생성하는 부분입니다.
         실제 날짜를 추가하기 전, 외부 API로 미리 공휴일 정보를 가져오고 날짜를 구성하면서 공휴일 데이터를 넣어 구성합니다.
        */
        if leadingDays > 0, let previousMonth = calendar.date(byAdding: .month, value: -1, to: currentMonth) {
            let daysInPreviousMonth = numberOfDays(in: previousMonth)
            for i in 0..<leadingDays {
                let day = daysInPreviousMonth - leadingDays + 1 + i
                if let date = calendar.date(bySetting: .day, value: day, of: previousMonth) {
                    let isHoliday = calendar.isHoliday(date, in: holidayDates)
                    days.append(CalendarDay(day: day, date: date, isCurrentMonth: false, isHoliday: isHoliday))
                }
            }
        }
        
        /*
         이번 달 날짜를 추가합니다.
         현재 달에 속한 실제 날짜를 추가해요!
         실제 날짜를 추가하기 전, 외부 API로 미리 공휴일 정보를 가져오고 날짜를 구성하면서 공휴일 데이터를 넣어 구성합니다.
         */
        for day in 1...daysInMonth {
            var components = calendar.dateComponents([.year, .month], from: currentMonth)
            components.day = day
            components.hour = 0
            components.minute = 0
            components.second = 0
            
            if let date = calendar.date(from: components) {
                let isHoliday = calendar.isHoliday(date, in: holidayDates)
                days.append(CalendarDay(day: day, date: date, isCurrentMonth: true, isHoliday: isHoliday))
            }
        }
        
        /*
         전체 날짜 수가 7의 배수가 아니라면, 마지막 주를 채우기 위한 다음 달 날짜를 추가합니다.
         실제 날짜를 추가하기 전, 외부 API로 미리 공휴일 정보를 가져오고 날짜를 구성하면서 공휴일 데이터를 넣어 구성합니다.
         */
        let remaining = (7 - days.count % 7) % 7
        if remaining > 0,
           let nextMonth = calendar.date(byAdding: .month, value: 1, to: currentMonth) {
            
            let daysInNextMonth = numberOfDays(in: nextMonth)
            
            for day in 1...remaining {
                let validDay = min(day, daysInNextMonth)
                if let date = calendar.date(bySetting: .day, value: validDay, of: nextMonth) {
                    let isHoliday = calendar.isHoliday(date, in: holidayDates)
                    days.append(CalendarDay(day: validDay, date: date, isCurrentMonth: false, isHoliday: isHoliday))
                }
            }
        }
        
        return days
        
    }
    
    /// 입력된 date가 속한 해당 달의 총 일 수를 반환합니다.
    /// - Parameter date: date 입력
    /// - Returns: 총 일 수 반환
    func numberOfDays(in date: Date) -> Int {
        Calendar.current.range(of: .day, in: .month, for: date)?.count ?? 0
    }
    
    /// 입력된 date가 속한 달의 첫 번째 날짜가 무슨 요일에 시작하는지 구합니다.
    /// - Parameter date: date 입력
    /// - Returns: 요일 값을 반환합니다. 일요일 = 1, 월요일 = 2 ....
    private func firstWeekdayOfMonth(in date: Date) -> Int {
        let components = Calendar.current.dateComponents([.year, .month], from: date)
        let firstDay = Calendar.current.date(from: components)!
        return Calendar.current.component(.weekday, from: firstDay)
    }
    
    /// 주어진 date가 속한 일주일 범위의 Date 배열을 반환합니다. weekDay를 기준으로 그 주의 일요일부터 토요일까지 계산합니다.
    /// - Returns: 현재 보고 있는 달의 1일 날짜 반환합니다.
    func firstDayOfMonth() -> Date {
        let compoents = Calendar.current.dateComponents([.year, .month], from: currentMonth)
        return Calendar.current.date(from: compoents) ?? Date()
    }
    
    /// 공휴일 API 응답으로 받은 [Holiday] 배열에서 Date로 변환한 공휴일들을 Set<Date> 형식으로 저장하는 기능입니다.
    /// - Parameter holidays: 특정 날짜가 공휴일인지 빠르게 확인할 때 사용할 수 있어요!
    func updateHolidayDates(from holidays: [Holiday]) {
        var newHolidays: Set<Date> = []
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        
        for holiday in holidays {
            let dateString = String(holiday.locdate)
            if let date = formatter.date(from: dateString) {
                newHolidays.insert(Calendar.current.startOfDay(for: date))
            }
        }
        self.holidayDates = newHolidays
    }
    
    /// 사용자가 날짜를 선택했을 때, 기존 선택된 날짜와 비교하여 필요할 경우에만 선택 날짜를 갱신할 수 있도록 합니다. 달력 앱에서 불필요한 상태 업데이트를 방지하고, 성능을 높이기 위해 자주 사용하는 방식이에요!
    /// - Parameter date: 선택한 날짜 업데이트
    public func changeSelectedDate(_ date: Date) {
        if calendar.isDate(selectedDate, inSameDayAs: date) {
            return
        } else {
            selectedDate = date
        }
    }
    
    /// 외부 API로부터 공휴일 정보 가져오기
    /// - Parameter year: 달력으로 선택된 날짜
    private func getHoliday(year: Int) {
        guard getHolidaySwitch else { return }
        
        provider.request(.getHoliday(year: year), completion: { [weak self] result in
            switch result {
            case .success(let response):
                do {
                    let data = try JSONDecoder().decode(HolidayResponse.self, from: response.data)
                    self?.updateHolidayDates(from: data.response.body.items.item)
                    self?.getHolidaySwitch = false
                } catch {
                    print("decode Error: ", error)
                }
            case .failure(let failure):
                print("error:", failure)
            }
        })
    }
    
    /// 공휴일 정보 가져오기 뷰 실행 함수
    func getHolidayInView() {
        let year = currentMonthYear
        guard year != lastRequestedYear else { return }
        
        getHoliday(year: year)
        lastRequestedYear = year
    }
}

extension Calendar {
    /// 주어진 날짜가 공휴일 목록에 포함되어 있는지 확인하도록 합니다.
    /// - Parameters:
    ///   - date: 검사할 날짜
    ///   - holidays: 공휴일 목록을 빠른 탐색
    /// - Returns: 해당 날짜가 공휴일인가? 반환
    func isHoliday(_ date: Date, in holidays: Set<Date>) -> Bool {
        let normalized = self.startOfDay(for: date)
        return holidays.contains(normalized)
    }
}
