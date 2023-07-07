//
//  JongNoView.swift
//  testproject
//
//  Created by Finny Jakey on 2023/06/25.
//

import SwiftUI

struct JongNoView: View {
    @State private var selectedSide: SideOfJongNo = .Arrive
    @ObservedObject var busVM: BusViewModel

    var body: some View {
        VStack {
            Picker("Choose a Side", selection: $selectedSide) {
                ForEach(SideOfJongNo.allCases, id: \.self) {
                    Text($0.rawValue)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.vertical)
            
            Spacer()
            
            switch selectedSide {
            case .Arrive:
                JongNoArriveView(busVM: busVM)
            case .Depart:
                JongNoDepartView(busVM: busVM)
            }
            
            Spacer()
        }
    }
}

struct JongNoView_Previews: PreviewProvider {
    static var previews: some View {
        JongNoView(busVM: BusViewModel())
    }
}

enum SideOfJongNo: String, CaseIterable {
    case Arrive = "한성대후문 도착"
    case Depart = "한성대후문 출발"
}
