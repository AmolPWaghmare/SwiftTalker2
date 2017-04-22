//
//  ProfileViewController.swift
//  Swift Talker
//
//  Created by Waghmare, Amol on 22/04/17.
//  Copyright © 2017 Waghmare, Amol. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController{

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let uiNavigationController = segue.destination as! UINavigationController
        
        if segue.identifier == "showDetailsSegue" {
//            let selectedCell = sender as! TweetCell
//            let selectedIndex = tableView.indexPath(for: selectedCell)
//            let selectedTweet = tweets[(selectedIndex?.row)!]
//            
//            let tweetDetailsViewController = uiNavigationController.topViewController as! TweetDetailsViewController
//            tweetDetailsViewController.tweet = selectedTweet
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
