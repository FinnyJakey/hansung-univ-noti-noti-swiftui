//
//  BusView.swift
//  hansunguivnotinoti
//
//  Created by Finny Jakey on 2023/06/22.
//

import SwiftUI

struct BusView: View {
    @State private var timer: Timer?

    @State private var selectedSide: SideOfBus = .SeongBuk
    @StateObject var busVM = BusViewModel()
    
    var body: some View {
        NavigationView {
            List {
                if busVM.state == .failed {
                    HStack(alignment: .center) {
                        Image(systemName: "x.circle")
                            .foregroundColor(.red)
                        Text(busVM.error)
                    }
                } else {
                    switch selectedSide {
                    case .SeongBuk:
                        SeongBukView(busVM: busVM)
                    case .JongNo:
                        JongNoView(busVM: busVM)
                    }
                }
            }
            .onAppear {
                Task {
                    await busVM.fetchData("107900003")
                    await busVM.fetchData("100900010")
                    startTimer()
                }
            }
            .onDisappear {
                stopTimer()
            }
            .navigationTitle("버스")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Picker("Choose a Side", selection: $selectedSide) {
                        ForEach(SideOfBus.allCases, id: \.self) {
                            Text($0.rawValue)
                        }
                    }
                    .pickerStyle(.menu)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        Task {
                            await busVM.fetchData("107900003")
                            await busVM.fetchData("100900010")
                        }
                    } label: {
                        Image(systemName: "arrow.clockwise")
                    }
                }
            }
        }
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            updateBusItems()
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    private func updateBusItems() {
        // busItems 배열을 업데이트하여 exps1 값을 1씩 감소시킴
        busVM.seongBukItems = busVM.seongBukItems.map { seongbukItem in
            var updatedItem = seongbukItem
            updatedItem.exps1 -= 1
            return updatedItem
        }
        
        busVM.jongNoItems = busVM.jongNoItems.map { jongnoItem in
            var updatedItem = jongnoItem
            updatedItem.exps1 -= 1
            return updatedItem
        }
    }
}

struct BusView_Previews: PreviewProvider {
    static var previews: some View {
        BusView()
    }
}

enum SideOfBus: String, CaseIterable {
    case SeongBuk = "성북02"
    case JongNo = "종로03"
}

func leftTimeConvert(_ time: Int) -> String {
    if (time <= 0) {
      return "";
    }
    if (time >= 60) {
      return "\(time / 60)분 \(time % 60)초"
    } else {
      return "\(time % 60)초"
    }
  }
