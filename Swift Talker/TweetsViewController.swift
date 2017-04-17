//
//  TweetsViewController.swift
//  Swift Talker
//
//  Created by Waghmare, Amol on 16/04/17.
//  Copyright © 2017 Waghmare, Amol. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, ComposeTweetViewControllerDelegate{
    
    var tweets: [Tweet] = []
    
    
    @IBOutlet weak var tableView: UITableView!
    
    let refreshTweetsControl = UIRefreshControl()
    
    @IBAction func onLogout(_ sender: Any) {
        TwitterClient.sharedInstance?.logout()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        getTweets(getMore: false)
        
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
                for tweet in tweets {
                    print("Tweet : \(tweet.text ?? "")")
                }
                
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell", for: indexPath) as! TweetCell
        
        cell.tweet = tweets[indexPath.row]
        return cell
    }
    
    func ComposeTweetViewController(ComposeTweetViewController: ComposeTweetViewController, didTweet tweet: Tweet) {
        tweets.insert(tweet, at: 0)
        tableView.reloadData()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
