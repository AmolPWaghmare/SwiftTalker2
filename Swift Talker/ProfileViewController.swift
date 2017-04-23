//
//  ProfileViewController.swift
//  Swift Talker
//
//  Created by Waghmare, Amol on 22/04/17.
//  Copyright © 2017 Waghmare, Amol. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController{

    var tweets: [Tweet] = []
    
    @IBOutlet weak var backgroudImage: UIImageView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var tweetsCount: UILabel!
    @IBOutlet weak var followers_count: UILabel!
    @IBOutlet weak var following_count: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 240
        
        backgroudImage.setImageWith((User.currentUser?.backgroundURL)!)
        profileImage.setImageWith((User.currentUser?.profileURL)!)
        nameLabel.text = User.currentUser?.name
        screenNameLabel.text = "@" + (User.currentUser?.screenName)!
        
        tweetsCount.text = String(User.currentUser?.statuses_count ?? 0)
        followers_count.text = String(User.currentUser?.followers_count ?? 0)
        following_count.text = String(User.currentUser?.followers_count ?? 0)

        
        getTweets(getMore: false)
    }
    
    func getMoreTweets() {
        getTweets(getMore: true)
    }
    
    func getTweets(getMore: Bool) {
        
        var queryParams = [String: AnyObject]()
        queryParams["count"] = 20 as AnyObject
        //queryParams["user_id"] = User.currentUser?.screenName as AnyObject
        queryParams["screen_name"] = User.currentUser?.screenName as AnyObject

            
        TwitterClient.sharedInstance?.getUserTimeline(parameters:queryParams,
                                                      success: { (tweets : [Tweet]) in
                                                        
                                                        self.tweets += tweets
                                                        
                                                        print("Tweet Count: \(tweets.count )")
                                                        //                for tweet in tweets {
                                                        //                    print("Tweet : \(tweet.text ?? "")")
                                                        //                }
                                                        
                                                        self.tableView.reloadData()
                                                        //self.refreshTweetsControl.endRefreshing()
                                                        
        }, failure: { (error: Error!) in
            print("error \(error.localizedDescription)")
        })
        
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let uiNavigationController = segue.destination as! UINavigationController
        
        if segue.identifier == "showDetailsSegue" {
            let selectedCell = sender as! TweetProfileCell
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


    @IBAction func onLogout(_ sender: Any) {
        TwitterClient.sharedInstance?.logout()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

//Extension for Tweet View functions
extension ProfileViewController: ComposeTweetViewControllerDelegate {
    func composeTweetViewController(composeTweetViewController: ComposeTweetViewController, didTweet tweet: Tweet) {
//        tweets.insert(tweet, at: 0)
//        tableView.reloadData()
    }
}

extension ProfileViewController : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetProfileCell", for: indexPath) as! TweetProfileCell
        
        cell.tweet = tweets[indexPath.row]
        
        return cell
    }
    
}
