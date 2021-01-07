//
//  SettingsView.swift
//  Quotes
//
//  Created by FeedMyTummy on 12/5/20.
//

import SwiftUI

struct SettingsView: View {
    
    @Environment(\.presentationMode) private var presentationMode
    @ObservedObject private var tabSelected: SelectedTab
    @StateObject private var notificationSettings = NotificationSettings()
    @State private var saveButtonRotation            = 0.0
    @State private var selectedDate                  = Date()
    @State private var notifyDaily                   = false
    @State private var hasSelectionChanged           = false
    
    // MARK: Constants
    private let totalSpinDegrees = 360.0
    private let tabChangeDelay = 0.5
    private let spinDuration = 0.4
    
    var body: some View {
        VStack {
            TabNavigationView(icon: Image(systemName: "house.fill"), side: .left) {
                tabSelected.selection = .home
            }
            
            Spacer()
            makeDatePickingView()
            Spacer()
            makeSaveButton()
            
        }
        .onChange(of: selectedDate) { _ in
            if let time = notificationSettings.dailyNotificationTime {
                hasSelectionChanged = time != HourMinute(date: selectedDate)
                notifyDaily = true
            }
        }
        .onChange(of: notificationSettings.dailyNotificationTime) { _ in
            if let time = notificationSettings.dailyNotificationTime {
                hasSelectionChanged = time != HourMinute(date: selectedDate)
                notifyDaily = true
            }
        }
        .foregroundColor(.black)
        .background(Color.white)
        .onAppear {
//            if let time = notificationSettings.dailyNotificationTime {
//                selectedDate = time.toDate()
//                notifyDaily = true
//            }
//            else {
//                notificationSettings.loadDailyNotificationDate()
//            }
        }
    }
    
    init(selection: SelectedTab) {
        self.tabSelected = selection
    }
    
    @ViewBuilder private func makeDatePickingView() -> some View {
        VStack {
            VStack {
                Text("Pick daily notification time.")
                    .multilineTextAlignment(.center)
                
                HStack(spacing: 0) {
                    Text("Currently: ")
                    DatePicker("Pick notification time.", // FIXME: Causing performance hit
                               selection: $selectedDate,
                               displayedComponents: .hourAndMinute)
                        .labelsHidden()
                }
            }
            .opacity(notifyDaily ? 1 : 0)
            
            HStack {
                Button("Turn notification \(notifyDaily ? "off" : "on")") {
                    notifyDaily
                        ? turnOffDailyNotifications()
                        : turnOnDailyNotifications()
                    notifyDaily.toggle()
                }
                .foregroundColor(.blue)
            }
            .padding(.top, 10)
        }
    }
    
    private func turnOffDailyNotifications() {
        notificationSettings.removeDailyNotification()
    }
    
    private func turnOnDailyNotifications() {
        hasSelectionChanged = true
    }
    
    @ViewBuilder private func makeSaveButton() -> some View {
        ZStack {
            Circle()
                .foregroundColor(.orange)
                .frame(width: 100, height: 100)
                .onTapGesture { reschedule() }

            Text("Save")
                .foregroundColor(.black)
                .font(.system(size: 20))
        }
        .padding(.bottom, 60)
        .opacity(notifyDaily && hasSelectionChanged ? 1 : 0)
        .rotation3DEffect(
            .degrees(saveButtonRotation),
            axis: (x: 0.0, y: 1.0, z: 0.0)
        )
        .animation(.easeOut(duration: spinDuration))
    }
    
    private func removeDailyNotification() {
        notificationSettings.removeDailyNotification()
    }
    
    private func reschedule() {
        saveButtonRotation += totalSpinDegrees
        
        notificationSettings.rescheduleDailyNotificationWith(date: selectedDate) { result in
            switch result {
            case .success():
                DispatchQueue.main.asyncAfter(deadline: .now() + tabChangeDelay) {
                    hasSelectionChanged = false
                    tabSelected.selection = .home
                }
            case .failure(let error):
                // TODO:
                print(error)
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(selection: .init())
    }
}
