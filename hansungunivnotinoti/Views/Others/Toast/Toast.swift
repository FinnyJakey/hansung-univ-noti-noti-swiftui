//
//  Toast.swift
//  hansungunivnotinoti
//
//  Created by Finny Jakey on 2023/07/29.
//

import Foundation

struct Toast: Equatable {
  var style: ToastStyle
  var message: String
  var duration: Double = 2
  var width: Double = .infinity
}
