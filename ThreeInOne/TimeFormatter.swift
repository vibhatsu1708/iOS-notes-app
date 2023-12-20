//
//  TimeFormatter.swift
//  ThreeInOne
//
//  Created by Vedant Mistry on 17/12/23.
//

import Foundation

func calculateTime(date: Date) -> String {
    let minutes = Int(-date.timeIntervalSinceNow) / 60
    let hours = minutes / 60
    let days = hours / 24
    
    if minutes < 1 {
        return "Less than a minute ago"
    } else if minutes == 1 {
        return "1 minute ago"
    } else if minutes < 120 {
        return "\(minutes) minutes ago"
    } else if minutes >= 120 && hours < 48 {
        return "\(hours) hours ago"
    } else {
        return "\(days) days ago"
    }
}
