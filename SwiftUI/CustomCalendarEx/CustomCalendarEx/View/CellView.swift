//
//  CellView.swift
//  CustomCalendarEx
//
//  Created by jaewon Lee on 6/19/25.
//

import SwiftUI

struct Cell: View {
    
    var calendarDay: CalendarDay
    var isSelected: Bool
    @Bindable var viewModel: ContentsViewModel

    
    var body: some View {
        ZStack {
            if isSelected {
                Circle()
                    .fill(Color.yellow.opacity(0.6))
                    .frame(width: 26, height: 27)
                    .transition(.scale.combined(with: .opacity))
            }

            Text("\(calendarDay.day)")
                .font(.caption)
                .foregroundStyle(textColor)
                .animation(.easeInOut(duration: 0.2), value: viewModel.selectedDate)
        }
        .frame(height: 30)
        .onTapGesture {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.5, blendDuration: 0)) {
                viewModel.changeSelectedDate(calendarDay.date)
            }
        }
    }
    
    private var textColor: Color {
        if calendarDay.isHoliday && calendarDay.isCurrentMonth {
            return Color.red
        } else if calendarDay.isCurrentMonth {
            return Color.black
        } else {
            return Color.gray.opacity(0.7)
        }
    }
}

