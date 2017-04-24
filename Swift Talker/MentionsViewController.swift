//
//  MentionsViewController.swift
//  Swift Talker
//
//  Created by Waghmare, Amol on 22/04/17.
//  Copyright © 2017 Waghmare, Amol. All rights reserved.
//

import UIKit

class MentionsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    let refreshTweetsControl = UIRefreshControl()

    var mentions: [Tweet] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 240

        let nib = UINib(nibName: "GenericTweetCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "GenericTweetCell")
        
        getMentions()
        
        //Refresh Control
        refreshTweetsControl.addTarget(self, action: #selector(MentionsViewController.getMentions), for: .valueChanged)
        tableView.insertSubview(refreshTweetsControl, at: 0)
    }
    
    func getMentions () {
        var queryParams = [String: AnyObject]()
        queryParams["count"] = 20 as AnyObject
        queryParams["include_entities"] = false as AnyObject
        
        TwitterClient.sharedInstance?.getMentionsTimeline(
            parameters:queryParams,
            success: { (tweets : [Tweet]) in
                self.mentions += tweets
                self.tableView.reloadData()
                self.refreshTweetsControl.endRefreshing()
                                                            
        }, failure: { (error: Error!) in
            print("error \(error.localizedDescription)")
        })
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let uiNavigationController = segue.destination as! UINavigationController
        
        if segue.identifier == "showDetailsSegue" {
                        let selectedTweet = sender as! Tweet
            
                        let tweetDetailsViewController = uiNavigationController.topViewController as! TweetDetailsViewController
                        tweetDetailsViewController.tweet = selectedTweet
        }
        else if segue.identifier == "ComposeTweetSegue" {
            let composeTweetController = uiNavigationController.topViewController as! ComposeTweetViewController
            composeTweetController.delegate = self
        } else if segue.identifier == "profileDetailsSegue" {
            print("profileDetailsSegue")
            let user = sender as! User
            let profileViewController = uiNavigationController.topViewController as! ProfileViewController
            profileViewController.user = user
            profileViewController.fromHamburger = false
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
extension MentionsViewController: ComposeTweetViewControllerDelegate {
    func composeTweetViewController(composeTweetViewController: ComposeTweetViewController, didTweet tweet: Tweet) {
        //        tweets.insert(tweet, at: 0)
        //        tableView.reloadData()
    }
}

//Extension for Tweet View functions
extension MentionsViewController: GenericTweetCellDelegate {
    func genericTweetCell(genericTweetCell: GenericTweetCell, selectImageInCell user: User) {
        self.performSegue(withIdentifier: "profileDetailsSegue", sender: user)
    }
}

//Extension for Tweet View functions
extension MentionsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mentions.count
    }
    
    func tableView (_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GenericTweetCell", for: indexPath) as! GenericTweetCell
        
        cell.tweet = mentions[indexPath.row]
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedTweet = mentions[(indexPath.row)]
        self.performSegue(withIdentifier: "showDetailsSegue", sender: selectedTweet)
    }
}
