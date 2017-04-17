//
//  ComposeTweetViewController.swift
//  Swift Talker
//
//  Created by Waghmare, Amol on 16/04/17.
//  Copyright © 2017 Waghmare, Amol. All rights reserved.
//

import UIKit

@objc protocol ComposeTweetViewControllerDelegate {
    @objc optional func ComposeTweetViewController( ComposeTweetViewController : ComposeTweetViewController, didTweet tweet: Tweet)
}

class ComposeTweetViewController: UIViewController {

    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userScreenNameLabel: UILabel!
    @IBOutlet weak var tweetText: UITextView!
    @IBOutlet weak var onCancel: UIBarButtonItem!
    @IBOutlet weak var tweetBarButton: UIBarButtonItem!
    
    weak var delegate: ComposeTweetViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tweetText.becomeFirstResponder()
        
        let currentUser = User.currentUser
        
        userImageView.setImageWith((currentUser?.profileURL!)!)
        userNameLabel.text = currentUser?.name
        let fullScreenName = "@" + (currentUser?.screenName)!
        userScreenNameLabel.text = fullScreenName

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onTweet(_ sender: Any) {
        
        view.endEditing(true)
        
        if tweetText.text.characters.count > 0 && tweetText.text.characters.count < 140 {
            print(tweetText.text)
            
            TwitterClient.sharedInstance?.tweet(tweetText: tweetText.text, success: { (tweet: Tweet) in
                
                print("New Tweet: \(tweet)")
                //Let view know about the new tweet
                self.delegate?.ComposeTweetViewController!(ComposeTweetViewController: self, didTweet: tweet)
                
                //Now cleanup
                self.tweetText.text = ""
                self.dismiss(animated: true, completion: nil)
            }, failure: { (error: Error!) in
                print("error \(error.localizedDescription)")
            })
        }
    }
    
    @IBAction func onCancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
