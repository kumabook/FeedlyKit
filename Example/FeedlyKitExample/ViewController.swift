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


class ViewController: UITableViewController {
    fileprivate let reuseIdentifier = "UITableViewCell"
    fileprivate let feedUrl         = "feed/https://news.ycombinator.com/rss"
    fileprivate let apiClient       = CloudAPIClient(target: .production)
    fileprivate var pagination      = PaginationParams()
    fileprivate var entries:[Entry] = []
    fileprivate let indicator       = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    fileprivate enum State {
        case `init`
        case fetching
        case normal
        case complete
    }
    fileprivate var state: State = .init
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        title = "Hacker News"
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.tableFooterView = indicator
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchEntries()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entries.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: reuseIdentifier)
        let entry = entries[indexPath.item]
        cell.textLabel?.text       = entry.title
        cell.detailTextLabel?.text = dateString(Date(timeIntervalSince1970: TimeInterval(Double(entry.published)/1000)))
        return cell
    }

    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let tv = tableView
        if (tv?.contentOffset.y)! >= (tv?.contentSize.height)! - (tv?.bounds.size.height)! && state == .normal {
            fetchEntries()
        }
    }

    fileprivate func fetchEntries() {
        if state == .fetching { return }
        indicator.startAnimating()
        state = .fetching
        let _ = apiClient.fetchContents(feedUrl, paginationParams: pagination) {
            if let es = $0.result.value {
                self.entries.append(contentsOf: es.items)
                
                self.tableView.reloadData()
                self.indicator.stopAnimating()
                if let c = es.continuation {
                    self.pagination.continuation = c
                    self.state = .normal
                } else {
                    self.state = .complete
                }
            }
        }
    }
    fileprivate func dateString(_ date: Date) -> String {
        let now           = Date()
        let passed        = now.timeIntervalSince(date)
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

