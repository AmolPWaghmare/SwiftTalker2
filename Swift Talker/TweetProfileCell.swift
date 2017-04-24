//
//  TweetProfileCell.swift
//  Swift Talker
//
//  Created by Waghmare, Amol on 23/04/17.
//  Copyright © 2017 Waghmare, Amol. All rights reserved.
//

import UIKit

@objc protocol TweetProfileCellDelegate {
    @objc optional func tweetProfileCell (tweetProfileCell: TweetProfileCell, selectImageInCell doSelect: Bool)
}

class TweetProfileCell: UITableViewCell {
    
    @IBOutlet weak var userScreenName: UILabel!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var timeTweet: UILabel!
    @IBOutlet weak var tweetText: UILabel!
    var user_id_str: String?
    
    weak var delegate : TweetProfileCellDelegate?
    
    var tweet : Tweet! {
        didSet {
            
            let tweetBy = tweet.tweetBy
            
            user_id_str = tweetBy?.id_str
            
            userImage.setImageWith((tweetBy?.profileURL!)!)
            
            let fullScreenName = "@" + (tweetBy?.screenName)!
            userScreenName.text = fullScreenName
            userName.text = tweetBy?.name
            
            tweetText.text = tweet.text
            timeTweet.text = tweet.timestampStr
        }
    }


    override func awakeFromNib() {
        super.awakeFromNib()
        userImage.layer.cornerRadius = 3
        userImage.clipsToBounds = true
        
        tweetText.preferredMaxLayoutWidth = tweetText.frame.size.width
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(onImageTap(sender:)))
        userImage.isUserInteractionEnabled = true
        userImage.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func onImageTap(sender: UITapGestureRecognizer) {
        self.delegate?.tweetProfileCell!(tweetProfileCell: self, selectImageInCell: true)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
