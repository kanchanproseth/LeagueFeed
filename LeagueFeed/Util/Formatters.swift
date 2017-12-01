//
//  Formatters.swift
//  LeagueFeed
//
//  Created by kanchanproseth on 11/13/17.
//  Copyright © 2017 kanchanproseth. All rights reserved.
//

import Foundation

protocol DateFormatable {

  func string(from date: Date) -> String
  func date(from string: String) -> Date?

}

extension DateFormatter: DateFormatable {}
extension ISO8601DateFormatter: DateFormatable {}

enum Formatters {

  private static var formatters: [String: DateFormatable] = [:]

  private struct Keys {
    static let isoFormatter = "isoFormatter"
    static let shortFormatter = "shortFormatter"
  }

  static var ISODateFormatter: DateFormatable {
    if let formatter = formatters[Keys.isoFormatter] {
      return formatter
    }

    let isoformatter = ISO8601DateFormatter()
    formatters[Keys.isoFormatter] = isoformatter
    return isoformatter
  }

  static var shortDateFormatter: DateFormatable {
    if let formatter = formatters[Keys.shortFormatter] {
      return formatter
    }

    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .short
    formatters[Keys.shortFormatter] = formatter
    return formatter
  }

}
