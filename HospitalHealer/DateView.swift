//
//  DateView.swift
//  HospitalHealer
//
//  Created by Mac on 26.01.2022.
//

import SwiftUI
import ElegantCalendar


struct DateView: View {
    
    var body: some View {
        ExampleCalendarView(
            ascVisits: Visit.mocks(
                start: .daysFromToday(-30*36),
                end: .daysFromToday(30*36)),
            initialMonth: Date())
    }
}


struct DateView_Previews: PreviewProvider {
    static var previews: some View {
        DateView()
    }
}
