//
//  SeongBukView.swift
//  testproject
//
//  Created by Finny Jakey on 2023/06/25.
//

import SwiftUI

struct SeongBukView: View {
    @State private var selectedSide: SideOfSeongBuk = .Arrive
    @ObservedObject var busVM: BusViewModel

    var body: some View {
        VStack {
            Picker("Choose a Side", selection: $selectedSide) {
                ForEach(SideOfSeongBuk.allCases, id: \.self) {
                    Text($0.rawValue)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.vertical)
            
            Spacer()
            
            switch selectedSide {
            case .Arrive:
                SeongBukArriveView(busVM: busVM)
            case .Depart:
                SeongBukDepartView(busVM: busVM)
            }
            
            Spacer()
        }
    }
}

struct SeongBukView_Previews: PreviewProvider {
    static var previews: some View {
        SeongBukView(busVM: BusViewModel())
    }
}

enum SideOfSeongBuk: String, CaseIterable {
    case Arrive = "한성대정문 도착"
    case Depart = "한성대정문 출발"
}
