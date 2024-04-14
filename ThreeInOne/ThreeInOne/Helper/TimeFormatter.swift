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
    } else if minutes > 1 && minutes < 60 {
        return "\(minutes) minutes ago"
    } else if hours == 1 {
        return "1 hour ago"
    } else if minutes >= 60 && hours < 24 {
        return "\(hours) hours ago"
    } else if hours >= 24 && days < 1 {
        return "\(days) days ago"
    } else if days == 1 {
        return "1 day ago"
    } else if days >= 1 {
        return "\(days) days ago"
    }
    else {
        return "\(days) months ago"
    }
}
