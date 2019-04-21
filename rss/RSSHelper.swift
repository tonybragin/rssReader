//
//  RSSHelper.swift
//  rss
//
//  Created by TONY on 20/04/2019.
//  Copyright © 2019 TONY. All rights reserved.
//

import Foundation
import FeedKit

enum RSSErrors: Error {
    case feedError
    case parserError
    case URLError
}

class RSSHelper {
    
    func isValidURL(url:String) -> Bool {
        if url == "" {
            return false
        }
        
        guard let feedURL = URL(string: url) else {
            return false
        }
        let parser = FeedParser(URL: feedURL)
        let result = parser.parse()// make asynchronously
        if result.isSuccess {
            parser.abortParsing()
            return true
        }
        
        return false
    }
    
    func getItemsList(url: String) throws -> [RSSFeedItem] {
        guard let feedURL = URL(string: url) else {
            throw RSSErrors.URLError
        }
        
        let parser = FeedParser(URL: feedURL)
        let result = parser.parse()
        if result.isSuccess {
            guard let finalResult = result.rssFeed?.items else {
                throw RSSErrors.feedError
            }
            parser.abortParsing()
            return finalResult
        } else {
            throw RSSErrors.parserError
        }
    }
}
