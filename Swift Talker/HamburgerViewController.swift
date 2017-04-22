//
//  HamburgerViewController.swift
//  Swift Talker
//
//  Created by Waghmare, Amol on 22/04/17.
//  Copyright © 2017 Waghmare, Amol. All rights reserved.
//

import UIKit

class HamburgerViewController: UIViewController {

    @IBOutlet weak var leftMargineConstraints: NSLayoutConstraint!
    var originalLeftMargin: CGFloat!
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var contentView: UIView!
    
    var menuViewController : UIViewController! {
        didSet {
            view.layoutIfNeeded()
            
            menuViewController.willMove(toParentViewController: self)
            menuView.addSubview(menuViewController.view)
            menuViewController.didMove(toParentViewController: self)
        }
    }
    
    var contentViewController : UIViewController! {
        didSet (oldViewController) {
            view.layoutIfNeeded()
            
            if oldViewController != nil {
                oldViewController.willMove(toParentViewController: nil)
                oldViewController.view.removeFromSuperview()
                oldViewController.didMove(toParentViewController: nil)
            }
            
            contentViewController.willMove(toParentViewController: self)
            contentView.addSubview(contentViewController.view)
            contentViewController.didMove(toParentViewController: self)
            
            UIView.animate(withDuration: 0.5, animations: {
                self.leftMargineConstraints.constant = 0
                self.view.layoutIfNeeded()
            })
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        contentViewController = storyboard.instantiateViewController(withIdentifier: "TweetsNavigationController")
        
        // Do any additional setup after loading the view.
    }

    @IBAction func onPan(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        let velocity = sender.velocity(in: view)
        
        if sender.state == UIGestureRecognizerState.began {
            originalLeftMargin = leftMargineConstraints.constant
        } else if sender.state == UIGestureRecognizerState.changed {
            leftMargineConstraints.constant = originalLeftMargin + translation.x

        } else if sender.state == UIGestureRecognizerState.ended {
            
            UIView.animate(withDuration: 0.5, animations: {
                if velocity.x > 0 {
                    self.leftMargineConstraints.constant = self.view.frame.size.width * 0.6
                } else {
                    self.leftMargineConstraints.constant = 0
                }
                self.view.layoutIfNeeded()
            })
            
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
