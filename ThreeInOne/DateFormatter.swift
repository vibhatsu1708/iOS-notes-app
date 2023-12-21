//
//  DateFormatter.swift
//  ThreeInOne
//
//  Created by Vedant Mistry on 21/12/23.
//

import Foundation

func formatDate(date: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "d.M.yyyy"
    let formattedDate = dateFormatter.string(from: date)
    
    return formattedDate
}
