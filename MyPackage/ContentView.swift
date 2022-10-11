//
//  ContentView.swift
//  MyPackage
//
//  Created by Yu Takahashi on 10/9/22.
//

import SwiftUI
import ActivityKit

struct PackageActivityWidgetAttributes: ActivityAttributes {
    
    public struct ContentState: Codable, Hashable {
        var statusList: [StatusList]
        var date: Date
        var time: Date
    }

    var company: String
    var type: String
}

struct StatusList: Codable, Hashable {
    var placeName: String
    var placeCode: String
    var date: String
    var time: String
    var status: String
}

struct Response: Codable {
    var number: Int
    var itemType: String
    var companyName: String
    var companyNameJp: String
    var statusList: [StatusList]
}

struct ContentView: View {
    
    let notRegistered = "登録なし"
    let received = "受付"
    let shipping = "発送"
    let carrying = "配達"
    let delivered = "完了"
    
    @State private var items = [Response]()
    @State private var codes = ["394993519045"]
    @State private var isAddSheetShown = false
    @State private var isInvaildUrl = false
    @State private var newCode = ""
    
    var body: some View {
        NavigationView {
            List {
                ForEach(0 ..< items.count, id: \.self) { i in
                    Section("Tracking Number: \(codes[i])") {
                        VStack {
                            HStack {
                                Text(items[i].companyNameJp)
                                    .font(.title2)
                                    .fontWeight(.semibold)
                                Spacer()
                                Text(items[i].statusList.last?.status ?? notRegistered)
                                    .font(.title2)
                            }
                            .padding(.bottom)
                            
                            HStack {
                                if !items[i].statusList.contains(where: {$0.status.contains(received)}) {
                                    Waiting()
                                }
                                
                                // First Line
                                if items[i].statusList.contains(where: {$0.status.contains(shipping)}) {
                                    PassedWay()
                                    if !items[i].statusList.contains(where: {$0.status.contains(carrying)}) {
                                        Carrying()
                                    }
                                } else {
                                    FutureWay()
                                }
                                
                                // Second Line
                                if items[i].statusList.contains(where: {$0.status.contains(carrying)}) {
                                    PassedWay()
                                    if !items[i].statusList.contains(where: {$0.status.contains(delivered)}) {
                                        Carrying()
                                    }
                                } else {
                                    FutureWay()
                                }
                                
                                // Final Line
                                if items[i].statusList.contains(where: {$0.status.contains(delivered)}) {
                                    PassedWay()
                                } else {
                                    FutureWay()
                                }
                                
                                Image(systemName: "house.fill")
                                    .foregroundColor(Color(.systemOrange))
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Packages")
            .toolbar(content: {
                ToolbarItem(placement: .primaryAction) {
                    Button(action: {
                        isAddSheetShown.toggle()
                    }) {
                        Image(systemName: "plus")
                    }
                }
            })
            .sheet(isPresented: $isAddSheetShown) {
                NavigationView {
                    VStack(alignment: .leading) {
                        TextField("Tracking Number", text: $newCode)
                            .padding()
                            .background(Color(.secondarySystemBackground))
                            .cornerRadius(10)
                            .padding()
                            .keyboardType(.numberPad)
                        Spacer()
                    }
                    .navigationTitle("New Tracking Number")
                    .toolbar(content: {
                        ToolbarItem(placement: .primaryAction) {
                            Button(action: {
                                if newCode.isEmpty {
                                    isInvaildUrl = true
                                    return
                                }
                                Task {
                                    isAddSheetShown = false
                                    codes.append(newCode)
                                    await readStatusJson()
                                    print(codes)
                                    newCode = ""
                                }
                            }) {
                                Image(systemName: "plus")
                            }
                        }
                    })
                }
                .presentationDetents([.medium])
            }
            .alert(isPresented: $isInvaildUrl) {
                Alert(title: Text("Error"), message: Text("The tracking number is invaild.\nPlease check it again."), dismissButton: .default(Text("OK")))
            }
        }
        .onAppear() {
            Task {
                await readStatusJson()
                
                let packageActivityWidgetAttributes = PackageActivityWidgetAttributes(company: items[0].companyNameJp, type: items[0].itemType)

                let initialContentState = PackageActivityWidgetAttributes.ContentState(statusList: items[0].statusList, date: Date(), time: Date())

                do {
                    let deliveryActivity = try Activity<PackageActivityWidgetAttributes>.request(
                        attributes: packageActivityWidgetAttributes,
                        contentState: initialContentState,
                        pushType: nil
                    )
                    
                    print("Requested your package delivery Live Activity \(deliveryActivity.id)")
                } catch (let error) {
                    print("Error requesting your package delivery Live Activity \(error.localizedDescription)")
                }
            }
        }
    }
    
    func readStatusJson() async {
        items = []
        for code in codes {
            let urlStr = "https://trackingjp.work/api/v1/tracking/\(code)"
            
            guard let url = URL(string: urlStr) else {
                isInvaildUrl = true
                return
            }
            
            do {
                let (data, _) = try await URLSession.shared.data(from: url)

                if let decodedResponse = try? JSONDecoder().decode(Response.self, from: data) {
                    items.append(decodedResponse)
                }
            } catch {
                isInvaildUrl = true
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


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
