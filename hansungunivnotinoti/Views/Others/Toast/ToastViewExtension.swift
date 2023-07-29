//
//  ToastViewExtension.swift
//  hansungunivnotinoti
//
//  Created by Finny Jakey on 2023/07/29.
//

import Foundation
import SwiftUI

extension View {

  func toastView(toast: Binding<Toast?>) -> some View {
    self.modifier(ToastModifier(toast: toast))
  }
}
