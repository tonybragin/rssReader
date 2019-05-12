//
//  Extentions.swift
//  rss
//
//  Created by TONY on 20/04/2019.
//  Copyright © 2019 TONY. All rights reserved.
//

import UIKit
import FeedKit
import CoreData

protocol mySuperProtocol {
    var uiController: UITableViewController! {get}
    var feedController: CoreDataHelper! {get}
    var favorited: Bool {get set}
    
    func alert(title: String, message: String)
    func refresh()
    func editFeedNameAlert(name: String, url: String)
    func performFavoriteChange(feed: Feed)
}

extension mySuperProtocol {
    
    func alert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(OKAction)
        uiController.present(alertController, animated: true)
    }
    
    func refresh() {
        do {
            try feedController.load(favorited: favorited)
        } catch {
            alert(title: "Error", message: "error refresh")
        }
        uiController.tableView.reloadData()
    }
    
    func editFeedNameAlert(name: String, url: String) {
        let editFeedAlert = UIAlertController(title: "Feed", message: "Enter feed name and URL", preferredStyle: .alert)

        editFeedAlert.addTextField { (textField) in
            textField.placeholder = "Feed name"
            textField.text! = name
            textField.keyboardType = .default
        }
        
        editFeedAlert.addTextField { (textField) in
            textField.placeholder = "Feed URL"
            textField.text! = url
            textField.keyboardType = .URL
        }
        
        editFeedAlert.addAction(UIAlertAction(title: "Cancel", style: .destructive))
        editFeedAlert.addAction(UIAlertAction(title: "Save", style: .default) { (action) in
            
            guard let feedNameText = editFeedAlert.textFields?.first?.text else {
                self.alert(title: "Error", message: "Invalid feed name")
                return
            }
            guard let feedURLText = editFeedAlert.textFields?.last?.text else {
                self.alert(title: "Error", message: "Invalid feed URL")
                return
            }
            if feedNameText == "" {
                self.alert(title: "Error", message: "Invalid feed name")
                return
            }
            if !self.feedController.rssHelper.isValidURL(url: feedURLText) {
                self.alert(title: "Error", message: "Invalid feed URL")
                return
            }
            
            do {
                if name == "" && url == "" {
                    try self.feedController.add(name: feedNameText, url: feedURLText)
                } else {
                    try self.feedController.edit(oldName: name, newName: feedNameText, newURL: feedURLText)
                }
            } catch CoreDataErrors.addError {
                self.alert(title: "Error", message: "error add")
                return
            } catch CoreDataErrors.editError {
                self.alert(title: "Error", message: "error edit")
                return
            } catch CoreDataErrors.saveError {
                self.alert(title: "Error", message: "error save")
                return
            } catch {
                self.alert(title: "Error", message: "unknown error")
                return
            }
        })
        
        uiController.present(editFeedAlert, animated: true)
    }
    
    func performFavoriteChange(feed: Feed) {
        do {
            try feedController.changeFavorite(feed: feed)
        } catch {
            self.alert(title: "Error", message: "error favorite change")
            return
        }
        
    }
    
}
