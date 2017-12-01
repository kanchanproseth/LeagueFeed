//
//  Article.swift
//  LeagueFeed
//
//  Created by kanchanproseth on 11/13/17.
//  Copyright © 2017 kanchanproseth. All rights reserved.
//

import Foundation

struct ArticlesResponse: Codable {

  let articles: [Article]

  static func parseArticles(fromJSON data: Data?) -> [Article]? {
    guard let data = data else {
        return nil
    }

    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .iso8601
    do {
      let articleResponse = try decoder.decode(ArticlesResponse.self, from: data)
      return articleResponse.articles
    } catch {
      NSLog("Error parsing articles: \(error.localizedDescription)")
    }
    return nil
  }

}

struct Article: Codable {

  let title: String
  let description: String?
  let url: String?
  let urlToImage: String?
  let publishedAt: Date?

  var articleURL: URL? {
    if let url = url {
      return URL(string: url)
    }
    return nil
  }

  var imageURL: URL? {
    if let url = urlToImage {
      return URL(string: url)
    }
    return nil
  }

}
