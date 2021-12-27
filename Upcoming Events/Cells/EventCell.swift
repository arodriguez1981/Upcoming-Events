//
//  EventCell.swift
//  Upcoming Events
//
//  Created by Alex Rodriguez on 22/12/21.
//

import UIKit

class EventCell: UITableViewCell {
    
    @IBOutlet weak var eventDateTime: UILabel!
    @IBOutlet weak var eventName: UILabel!
    @IBOutlet weak var eventConflict: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
