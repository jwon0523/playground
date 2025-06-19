//
//  ContentView.swift
//  CustomCalendarEx
//
//  Created by jaewon Lee on 6/19/25.
//

import SwiftUI

struct ContentView: View {
    
    @Bindable var viewModel: ContentsViewModel = .init()
    
    var body: some View {
        VStack(spacing: 24, content: {
            hedarController // 상단 월 변경 컨트롤러
            
            calendarView // 달력 본체
        })
        .padding(.vertical, 30)
        .padding(.horizontal, 16)
        .background(Color.white)
        
        /* 뷰가 로드될 때 한 번만 실행한다 */
        .task {
            viewModel.getHolidayInView()
        }
        
        /* 월이 바뀔 때마다 공휴일 다시 불러오기 */
        .onChange(of: viewModel.currentMonthYear, { _, _ in
            viewModel.getHolidayInView()
        })
    }
    
    
    /// 상단 월 변경 컨틀롤러 뷰
    private var hedarController: some View {
        HStack(spacing: 47, content: {
            Button(action: {
                viewModel.changeMonth(by: -1)
            }, label: {
                Image(systemName: "chevron.left")
            })
            
            Text(viewModel.currentMonth, formatter: calendarHeaderDateFormatter)
                .font(.title3)
                .foregroundStyle(Color.black)
            
            
            Button(action: {
                viewModel.changeMonth(by: 1)
            }, label: {
                Image(systemName: "chevron.right")
            })
        })
    }
    
    /// 달력 본체 뷰
    private var calendarView: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 0), count: 7), spacing: 5, content: {
            /// 요일 헤더 (일 ~ 토)
            ForEach(localizedWeekdaySymbols.indices, id: \.self) { index in
                Text(localizedWeekdaySymbols[index])
                    .foregroundStyle(index == 0 ? Color.red : index == 6 ? Color.blue : Color.gray) // 일요일, 토요일, 평일 색 따로 두기
                    .frame(maxWidth: .infinity)
                    .font(.caption)
            }
            .padding(.bottom, 30) // 요일 아래 여백
            
            ForEach(viewModel.daysForCurrentGrid(), id: \.id) { calendarDay in
                let isSelectedDate = viewModel.calendar.isDate(calendarDay.date, inSameDayAs: viewModel.selectedDate)
                Cell(calendarDay: calendarDay, isSelected: isSelectedDate, viewModel: viewModel)

            }
        })
        .frame(height: 250, alignment: .top)
    }
    
    /// 요일 이름 한글로 가져오기
    let localizedWeekdaySymbols: [String] = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.shortWeekdaySymbols ?? []
    }()
    
    /// 헤더 날짜 표시 포맷터
    let calendarHeaderDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM"
        return formatter
    }()
}

#Preview {
    ContentView()
}

