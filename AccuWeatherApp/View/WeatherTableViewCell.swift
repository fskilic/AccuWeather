//
//  WeatherTableViewCell.swift
//  AccuWeatherApp
//
//  Created by FS K on 27.01.2023.
//

import UIKit

class WeatherTableViewCell: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var nightImageView: UIImageView!
    @IBOutlet weak var dayImageView: UIImageView!
    @IBOutlet weak var nightAirConditionLabel: UILabel!
    @IBOutlet weak var dayAirConditionLabel: UILabel!
    @IBOutlet weak var nightHeatLabel: UILabel!
    @IBOutlet weak var dayHeatLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
