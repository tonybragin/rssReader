//
//  CoreDataHelper.swift
//  rss
//
//  Created by TONY on 20/04/2019.
//  Copyright © 2019 TONY. All rights reserved.
//

import Foundation
import UIKit
import FeedKit
import CoreData

enum CoreDataErrors: Error {
    case loadError
    case addError
    case saveError
    case editError
}

class CoreDataHelper {
    
    let rssHelper = RSSHelper()
    
    var feedList: [Feed] = []
    var feedItemsList: [[RSSFeedItem]] = [[]]
    
    func load() throws {
        feedList = []
        feedItemsList = [[]]
        
        let context = getContext()
        
        let request = NSFetchRequest<Feed>(entityName: "Feed")
        request.returnsObjectsAsFaults = false
        request.sortDescriptors = [NSSortDescriptor(key: #keyPath(Feed.name), ascending: true)]
        
        let result = try context.fetch(request)
        feedList = result
        
        for feed in feedList {
            try feedItemsList.append(rssHelper.getItemsList(url: feed.url!))
        }
        
        feedItemsList.remove(at: 0)
    }
    
    func getContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    func save() throws {
        let context = getContext()
        do {
            try context.save()
        } catch {
            throw CoreDataErrors.saveError
        }
    }
    
    func add(name: String, url: String) throws {
        let context = getContext()
        
        let request = NSFetchRequest<Feed>(entityName: "Feed")
        request.predicate = NSPredicate(format: "name = %@", name)
        request.returnsObjectsAsFaults = false
        request.fetchLimit = 1
        
        let result = try? context.fetch(request)
        if (result?.first) != nil {
            throw CoreDataErrors.addError
        } else {
        
            let entity = NSEntityDescription.entity(forEntityName: "Feed", in: context)
            let newFeed = NSManagedObject(entity: entity!, insertInto: context)
        
            newFeed.setValue(name, forKey: "name")
            newFeed.setValue(url, forKey: "url")
        
            try save()
        }
    }
    
    func edit(oldName: String, newName: String, newURL: String) throws {
        let context = getContext()
        
        let request = NSFetchRequest<Feed>(entityName: "Feed")
        request.predicate = NSPredicate(format: "name = %@", oldName)
        request.returnsObjectsAsFaults = false
        request.fetchLimit = 1
        
        do {
            let result = try context.fetch(request)
            result.first?.name = newName
            result.first?.url = newURL
            try save()
        } catch CoreDataErrors.saveError {
            throw CoreDataErrors.saveError
        } catch {
            throw CoreDataErrors.editError
        }
    }
    
    func delete(feed:Feed) throws {
        let context = getContext()
        context.delete(feed)
        try save()
    }
}
