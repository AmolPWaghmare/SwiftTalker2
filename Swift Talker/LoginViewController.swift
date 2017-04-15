//
//  LoginViewController.swift
//  Swift Talker
//
//  Created by Waghmare, Amol on 15/04/17.
//  Copyright © 2017 Waghmare, Amol. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func onLogin(_ sender: Any) {
        let twitterClient = BDBOAuth1SessionManager(baseURL: URL(string : "https://api.twitter.com")!, consumerKey: "GpN5HiZsdOpfM7fA0fsPXm9zy", consumerSecret: "dA5AxyPVQPkskaq2lZgx802Fw24MAeeYBmPDKo8EV5OmmO14hY")
        
        twitterClient?.deauthorize()
        
        twitterClient?.fetchRequestToken(withPath: "oauth/request_token", method: "GET", callbackURL: URL(string: "swifttalker://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential!) in
            print("Request Token: Success")
            
            let token = String(requestToken!.token)
            
            let authURL = URL(string:"https://api.twitter.com/oauth/authorize?oauth_token=" + token!)!
            UIApplication.shared.open(authURL, options: [:], completionHandler: { (opened: Bool) in
                print("Opened Safari")
            })
            
        }, failure: { (error: Error!) in
            print("error \(error!.localizedDescription)")
        })
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
