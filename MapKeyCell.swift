//
//  MapKeyCell.swift
//  Slug_Route
//
//  Created by Jeff on 11/13/16.
//  Copyright © 2016 Jeff. All rights reserved.
//

import UIKit

class MapKeyCell: UITableViewCell {

    @IBOutlet weak var mapImage: UIImageView!
    @IBOutlet weak var mapName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
