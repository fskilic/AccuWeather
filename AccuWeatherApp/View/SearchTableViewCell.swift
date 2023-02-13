//
//  SearchTableViewCell.swift
//  AccuWeatherApp
//
//  Created by FS K on 28.01.2023.
//

import UIKit

class SearchTableViewCell: UITableViewCell {

    @IBOutlet weak var cityL: UILabel!
    @IBOutlet weak var regionL: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
