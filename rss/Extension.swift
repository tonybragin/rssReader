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

extension MainTableViewController {
    
    func editFeedNameAlert(name: String, url: String) {
        
        let alert = UIAlertController(title: "Feed", message: "Enter feed name and URL", preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.placeholder = "Feed name"
            textField.text! = name
            textField.keyboardType = .default
        }
        
        alert.addTextField { (textField) in
            textField.placeholder = "Feed URL"
            textField.text! = url
            textField.keyboardType = .URL
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive))
        alert.addAction(UIAlertAction(title: "Save", style: .default) { (action) in
            
            guard let feedNameText = alert.textFields?.first?.text else {
                self.alert(title: "Error", message: "Invalid feed name")
                return
            }
            guard let feedURLText = alert.textFields?.last?.text else {
                self.alert(title: "Error", message: "Invalid feed URL")
                return
            }
            if feedNameText == "" {
                self.alert(title: "Error", message: "Invalid feed name")
                return
            }
            if !self.feed.rssHelper.isValidURL(url: feedURLText) {
                self.alert(title: "Error", message: "Invalid feed URL")
                return
            }
            
            do {
                if name == "" && url == "" {
                    try self.feed.add(name: feedNameText, url: feedURLText)
                } else {
                    try self.feed.edit(oldName: name, newName: feedNameText, newURL: feedURLText)
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
        
        self.present(alert, animated: true)
    }
    
    func refresh() {
        do {
            try feed.load()
        } catch {
            self.alert(title: "Error", message: "error refresh")
        }
        self.tableView.reloadData()
    }
    
    func alert(title: String, message: String) -> Void {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(OKAction)
        self.present(alertController, animated: true)
    }
    
}
