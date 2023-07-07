//
//  ScheduleView.dart.swift
//  hansunguivnotinoti
//
//  Created by Finny Jakey on 2023/06/22.
//

import SwiftUI

struct ScheduleView: View {
    @StateObject var scheduleVM = ScheduleViewModel()
    
    var body: some View {
        NavigationView {
            List {
                ForEach(Array(scheduleVM.schedule.enumerated()), id: \.element) { index, monthlySchedule in
                    VStack(alignment: .leading) {
                        Text("\(scheduleVM.currentYear).\(index + 1).")
                            .font(.title3)
                            .fontWeight(.bold)
                            .padding(.vertical, 4)
                        
                        ForEach(monthlySchedule, id: \.self) { schedule in
                            HStack {
                                RoundedRectangle(cornerRadius: 20.0)
                                    .fill(Color.yellow)
                                    .frame(width: 6.0)
                                VStack(alignment: .leading) {
                                    Text(schedule.content)
                                    Text(schedule.date)
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }
                            }
                            .fixedSize(horizontal: false, vertical: true)
                        }
                        .padding(.vertical, 6)
                        
                    }
                }
                
                if scheduleVM.state == .loading {
                    ProgressView().id(UUID())
                        .frame(maxWidth: .infinity)
                }
            }
            .navigationTitle("학사일정")
            .onAppear {
                Task {
                    if scheduleVM.state != .loaded {
                        await scheduleVM.fetchData()
                    }
                }
            }
        }
    }
}

struct ScheduleView_Previews: PreviewProvider {
    static var previews: some View {
        ScheduleView()
    }
}
