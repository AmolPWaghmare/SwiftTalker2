//
//  TweetsViewController.swift
//  Swift Talker
//
//  Created by Waghmare, Amol on 16/04/17.
//  Copyright © 2017 Waghmare, Amol. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController{
    
    var tweets: [Tweet] = []
    let refreshTweetsControl = UIRefreshControl()
    
    @IBOutlet weak var tableView: UITableView!

    @IBAction func onLogout(_ sender: Any) {
        TwitterClient.sharedInstance?.logout()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 240
        
        getTweets(getMore: false)
        
        //Refresh Control
        refreshTweetsControl.addTarget(self, action: #selector(TweetsViewController.getMoreTweets), for: .valueChanged)
        tableView.insertSubview(refreshTweetsControl, at: 0)
    }
    
    func getMoreTweets() {
        getTweets(getMore: true)
    }
    
    func getTweets(getMore: Bool) {
        
        var queryParams = [String: AnyObject]()
        queryParams["count"] = 20 as AnyObject
        
        TwitterClient.sharedInstance?.getHomeTimeline(parameters:queryParams,
            success: { (tweets : [Tweet]) in
                
                self.tweets += tweets
                
                print("Tweet Count: \(tweets.count )")
//                for tweet in tweets {
//                    print("Tweet : \(tweet.text ?? "")")
//                }
                
                self.tableView.reloadData()
                self.refreshTweetsControl.endRefreshing()
                
        }, failure: { (error: Error!) in
            print("error \(error.localizedDescription)")
        })
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let uiNavigationController = segue.destination as! UINavigationController

        if segue.identifier == "showDetailsSegue" {
            let selectedCell = sender as! TweetCell
            let selectedIndex = tableView.indexPath(for: selectedCell)
            let selectedTweet = tweets[(selectedIndex?.row)!]
            
            let tweetDetailsViewController = uiNavigationController.topViewController as! TweetDetailsViewController
            tweetDetailsViewController.tweet = selectedTweet
        }
        else if segue.identifier == "ComposeTweetSegue" {
            let composeTweetController = uiNavigationController.topViewController as! ComposeTweetViewController
            composeTweetController.delegate = self
        }
        
    }
}

//Extension for Table View functions
extension TweetsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell", for: indexPath) as! TweetCell
        
        cell.tweet = tweets[indexPath.row]
        return cell
    }
}


//Extension for Tweet View functions
extension TweetsViewController: ComposeTweetViewControllerDelegate {
    func composeTweetViewController(composeTweetViewController: ComposeTweetViewController, didTweet tweet: Tweet) {
        tweets.insert(tweet, at: 0)
        tableView.reloadData()
    }
}
