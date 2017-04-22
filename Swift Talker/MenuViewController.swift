//
//  MenuViewController.swift
//  Swift Talker
//
//  Created by Waghmare, Amol on 22/04/17.
//  Copyright © 2017 Waghmare, Amol. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var hamburgerViewController : HamburgerViewController!
    var tweetsViewController : UIViewController!
    var viewControllersList : [UIViewController] = []
    
    var menuItems: [String] = ["Profile", "Timeline", "Mentions", "Accounts"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        
        let profileViewController = storyboard.instantiateViewController(withIdentifier: "ProfileNavigationController")
        viewControllersList.append(profileViewController)
        let timelineViewController = storyboard.instantiateViewController(withIdentifier: "TweetsNavigationController")
        viewControllersList.append(timelineViewController)
        let mentionsViewController = storyboard.instantiateViewController(withIdentifier: "MentionsNavigationController")
        viewControllersList.append(mentionsViewController)
        let accountsViewController = storyboard.instantiateViewController(withIdentifier: "AccountsNavigationController")
        viewControllersList.append(accountsViewController)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell") as! MenuCell
        
        cell.menuLable.text = menuItems[indexPath.row]
        return cell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        hamburgerViewController.contentViewController = viewControllersList[indexPath.row]
        
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
