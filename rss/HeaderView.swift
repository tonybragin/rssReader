//
//  HeaderView.swift
//  rss
//
//  Created by TONY on 11/05/2019.
//  Copyright © 2019 TONY. All rights reserved.
//

import UIKit

class HeaderView: UIView, mySuperProtocol {
    
    var uiController: UITableViewController!
    var feedController: CoreDataHelper!
    var favorited: Bool = false
    
    private var feed: Feed!
    
    var titleLabel: UILabel!
    var editButton: UIButton!
    var deleteButton: UIButton!
    var favoriteButton: UIButton!
    
    init(for feed: Feed, width: CGFloat, height: CGFloat, sender: (ui: UITableViewController, feed: CoreDataHelper)) {
        super.init(frame: CGRect(x: 0, y: 0, width: width, height: height))
        self.backgroundColor = .purple
        
        self.uiController = sender.ui
        self.feedController = sender.feed
        self.feed = feed
        
        self.titleLabel = UILabel(frame: CGRect(x: 10, y: 0, width: width - 180, height: height))
        self.titleLabel.font = .preferredFont(forTextStyle: .title1)
        self.titleLabel.text = self.feed.name
        self.addSubview(self.titleLabel)
        
        self.deleteButton = UIButton(frame: CGRect(x: width - 60, y: 0, width: 60, height: height))
        self.deleteButton.setTitle("delete", for: .normal)
        self.deleteButton.backgroundColor = .red
        self.deleteButton.addTarget(self, action: #selector(deleteAction), for: .touchUpInside)
        self.addSubview(self.deleteButton)
        
        self.editButton = UIButton(frame: CGRect(x: width - 120, y: 0, width: 60, height: height))
        self.editButton.setTitle("edit", for: .normal)
        self.editButton.backgroundColor = .blue
        self.editButton.addTarget(self, action: #selector(editAction), for: .touchUpInside)
        self.addSubview(self.editButton)
        
        self.favoriteButton = UIButton(frame: CGRect(x: width - 180, y: 0, width: 60, height: height))
        self.favoriteButton.setTitle("fav", for: .normal)
        if feed.favorite {
            self.favoriteButton.backgroundColor = .yellow
        } else {
            self.favoriteButton.backgroundColor = .gray
        }
        self.favoriteButton.addTarget(self, action: #selector(favoriteAction), for: .touchUpInside)
        self.addSubview(self.favoriteButton)
        
    }
    
    @objc
    func editAction() {
        editFeedNameAlert(name: feed.name!, url: feed.url!)
        refresh()
    }
    
    @objc
    func deleteAction() {
        do {
            try feedController.delete(feed: feed)
            self.refresh()
        } catch {
            alert(title: "error", message: "error delete")
        }
    }
    
    @objc
    func favoriteAction() {
        performFavoriteChange(feed: feed)
        if feed.favorite {
            self.favoriteButton.backgroundColor = .gray
        } else {
            self.favoriteButton.backgroundColor = .yellow
        }
        refresh()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
