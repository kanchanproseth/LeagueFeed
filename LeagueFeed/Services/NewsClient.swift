//
//  NewsClient.swift
//  LeagueFeed
//
//  Created by kanchanproseth on 11/13/17.
//  Copyright © 2017 kanchanproseth. All rights reserved.
//


import Foundation

class NewsClient {

  struct Constants {

    static let apiKey = "2c8f42f8043f4aaaa6821788f212a2e3"
    static let baseURL = URL(string: "https://newsapi.org/v1")!

    struct Paths {

      static let article = "articles"

    }

    struct Keys {

      static let apiKey = "apiKey"
      static let source = "source"

    }

  }

  let urlSession: URLSession

  init() {
    let config = URLSessionConfiguration.default
    urlSession = URLSession(configuration: config)
  }

  typealias ArticlesCompletion = (([Article]?, Error?) -> Void)

  func articles(forSource source: NewsSource, completion: @escaping ArticlesCompletion) -> Cancellable {
    let articlesURL = Constants.baseURL.appendingPathComponent(Constants.Paths.article)
    var components = URLComponents(string: articlesURL.absoluteString)
    components?.queryItems = [
      URLQueryItem(name : Constants.Keys.apiKey, value: Constants.apiKey),
      URLQueryItem(name : Constants.Keys.source, value: source.rawValue)
    ]
    guard let url = components?.url else {
      fatalError("Could not create url")
    }

    let task = urlSession.dataTask(with: url) { (data, _, error) in
      DispatchQueue.main.async {
        if let error = error {
          completion(nil, error)
        } else {
          completion(ArticlesResponse.parseArticles(fromJSON: data), nil)
        }
      }
    }
    task.resume()
    return task
  }

}
