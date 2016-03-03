//
//  ViewController.swift
//  FeedlyKitExample
//
//  Created by Hiroki Kumamoto on 3/3/16.
//  Copyright © 2016 kumabook. All rights reserved.
//

import UIKit
import Alamofire
import FeedlyKit
import Alamofire
import ReactiveCocoa


class ViewController: UITableViewController {
    private let reuseIdentifier = "UITableViewCell"
    private let feedUrl         = "feed/https://news.ycombinator.com/rss"
    private let apiClient       = CloudAPIClient(target: .Production)
    private var pagination      = PaginationParams()
    private var entries:[Entry] = []
    private let indicator       = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
    private enum State {
        case Init
        case Fetching
        case Normal
        case Complete
    }
    private var state: State = .Init
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        title = "Hacker News"
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.tableFooterView = indicator
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        fetchEntries()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entries.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .Subtitle, reuseIdentifier: reuseIdentifier)
        let entry = entries[indexPath.item]
        cell.textLabel?.text       = entry.title
        cell.detailTextLabel?.text = dateString(NSDate(timeIntervalSince1970: NSTimeInterval(Double(entry.published)/1000)))
        return cell
    }

    override func scrollViewDidScroll(scrollView: UIScrollView) {
        let tv = tableView
        if tv.contentOffset.y >= tv.contentSize.height - tv.bounds.size.height && state == .Normal {
            fetchEntries()
        }
    }

    private func fetchEntries() {
        if state == .Fetching { return }
        indicator.startAnimating()
        state = .Fetching
        apiClient.fetchContents(feedUrl, paginationParams: pagination) {
            if let es = $0.result.value {
                self.entries.appendContentsOf(es.items)
                
                self.tableView.reloadData()
                self.indicator.stopAnimating()
                if let c = es.continuation {
                    self.pagination.continuation = c
                    self.state = .Normal
                } else {
                    self.state = .Complete
                }
            }
        }
    }
    private func dateString(date: NSDate) -> String {
        let now           = NSDate()
        let passed        = now.timeIntervalSinceDate(date)
        let minute: Int   = Int(passed) / 60
        if minute <= 1 {
            return "1 minute ago"
        }
        if minute < 60 {
            return "\(minute)" + " minutes ago"
        }
        let hour = minute / 60;
        if hour <= 1 {
            return "\(hour)" + " hour ago"
        }
        if (hour < 24) {
            return "\(hour)" + " hours ago"
        }
        let day = hour / 24;
        if day <= 1 {
            return "\(day)" + " day ago"
        }
        return "\(day)" + " days ago"
    }
}

