//
//  ProgressIndicators.swift
//  MyPackage
//
//  Created by Yu Takahashi on 10/11/22.
//

import SwiftUI

struct PassedWay: View {
    var body: some View {
        VStack {
            Divider()
                .frame(height: 6)
                .overlay(.blue)
                .cornerRadius(5)
        }
    }
}

struct FutureWay: View {
    var body: some View {
        VStack {
            RoundedRectangle(cornerRadius: 5)
                .stroke(style: StrokeStyle(lineWidth: 1, dash: [5]))
                .frame(height: 6)
        }
    }
}

struct Carrying: View {
    var body: some View {
        Image(systemName: "box.truck.badge.clock.fill")
            .foregroundColor(.blue)
    }
}

struct Waiting: View {
    var body: some View {
        Image(systemName: "clock.badge.questionmark.fill")
            .foregroundColor(.blue)
    }
}
