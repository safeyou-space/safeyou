//
//  Helper.swift
//  SafeYou
//
//  Created by Edgar on 09.05.22.
//  Copyright © 2022 Garnik Simonyan. All rights reserved.
//

import Foundation

class Helper: NSObject {
    @objc static func isUserAdult(birthday: String, isRegisteration: Bool) -> Bool {
        let dateFormatter = DateFormatter()
        if isRegisteration {
            dateFormatter.dateFormat = "dd/MM/yyyy"
        } else {
            dateFormatter.dateFormat = "MM/dd/yyyy"
        }
        if let birthDate = dateFormatter.date(from: birthday) {
            let calendar = Calendar.current
            let components = calendar.dateComponents([.year], from: birthDate, to: Date())
            if let year = components.year {
                return year >= 18
            }
        }
        return false;
    }

    @objc static func formatDateToShow(initialDateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.ssssZ"
        dateFormatter.locale = .current

        var formatedDateString = ""
        if let receivedDate = dateFormatter.date(from: initialDateString) {
            dateFormatter.dateFormat = "dd/MM/yyyy, HH:mm"
            formatedDateString = dateFormatter.string(from: receivedDate)
        }

        return formatedDateString
    }
}
