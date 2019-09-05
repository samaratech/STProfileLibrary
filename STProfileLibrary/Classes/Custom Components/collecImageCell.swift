//
//  collecImageCell.swift
//  Alamofire
//
//  Created by HIPL-GLOBYLOG on 8/22/19.
//

import UIKit

class collecImageCell: UICollectionViewCell {
    @IBOutlet weak var crossBtn:UIButton!
    @IBOutlet weak var iconeImage:UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        let image1 = UIImage(named: "acount_cross_error")
        self.crossBtn.setImage(image1, for: .selected)
        self.crossBtn.setImage(image1, for: .normal)
        self.crossBtn.setImage(image1, for: .highlighted)
        self.iconeImage.layer.borderWidth = 1
        self.iconeImage.layer.borderColor = UIColor(red:222/255, green:225/255, blue:227/255, alpha: 1).cgColor
        
        // Initialization code
    }

}
