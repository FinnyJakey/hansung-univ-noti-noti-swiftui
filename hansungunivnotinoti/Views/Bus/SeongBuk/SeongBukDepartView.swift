//
//  SeongBukDepartView.swift
//  testproject
//
//  Created by Finny Jakey on 2023/06/25.
//

import SwiftUI

struct SeongBukDepartView: View {
    @ObservedObject var busVM: BusViewModel

    var body: some View {
        ForEach(busVM.seongBukItems.prefix(19)) { busItem in
            VStack {
                HStack {
                    VStack(alignment: .leading) {
                        ForEach(busItem.stNm.components(separatedBy: "."), id: \.self) { busName in
                            Text(busName)
                        }
                    }
                    Spacer()
                    
                    Text(leftTimeConvert(busItem.exps1))
                        .foregroundColor(.red)
                    
                    if busItem.arrmsg1.contains("[") || busItem.arrmsg1.contains("]") {
                        Text("[\(String(busItem.arrmsg1.split(separator: "[")[1]))")
                            .foregroundColor(.secondary)
                    } else {
                        Text("[\(busItem.arrmsg1)]")
                            .foregroundColor(.secondary)
                    }
                }
                .font(.subheadline)
                Divider()
            }
            .padding(.vertical, 4)
        }
    }
}

struct SeongBukDepartView_Previews: PreviewProvider {
    static var previews: some View {
        SeongBukDepartView(busVM: BusViewModel())
    }
}
