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
    let refreshTweetsControl = UIRefreshControl()
    @IBOutlet weak var backButton: UIBarButtonItem!
    
    var fromHamburger : Bool = true
    var user : User!
    
    func setUserProps(user: User) {
        if (backgroudImage != nil) {
            backgroudImage.setImageWith((user.backgroundURL)!)
            profileImage.setImageWith((user.profileURL)!)
            nameLabel.text = user.name
            screenNameLabel.text = "@" + (user.screenName)!
            
            tweetsCount.text = String(user.statuses_count ?? 0)
            followers_count.text = String(user.followers_count ?? 0)
            following_count.text = String(user.following_count ?? 0)
            
            if (!fromHamburger) {
                backButton.style =  UIBarButtonItemStyle.done
                backButton.isEnabled = true;
                backButton.title = "Back";
            } else {
                backButton.style = UIBarButtonItemStyle.plain
                backButton.isEnabled = false;
                backButton.title = nil;
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 240

        if (user == nil) {
            user = User.currentUser
        }
        setUserProps(user: user)
        
        getTweets(getMore: false)
        
        //Refresh Control
        refreshTweetsControl.addTarget(self, action: #selector(ProfileViewController.getTweets), for: .valueChanged)
        tableView.insertSubview(refreshTweetsControl, at: 0)
    }
    
    func getMoreTweets() {
        getTweets(getMore: true)
    }
    
    func getTweets(getMore: Bool) {
        
        var queryParams = [String: AnyObject]()
        queryParams["count"] = 20 as AnyObject
        queryParams["user_id"] = user?.id_str as AnyObject
        queryParams["screen_name"] = user?.screenName as AnyObject

        TwitterClient.sharedInstance?.getUserTimeline(parameters:queryParams,
                                                      success: { (tweets : [Tweet]) in
                                                        
                                                        self.tweets += tweets
                                                        
                                                        print("Tweet Count: \(tweets.count )")
                                                        
                                                        self.tableView.reloadData()
                                                        self.refreshTweetsControl.endRefreshing()
                                                        
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

    @IBAction func onBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
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
