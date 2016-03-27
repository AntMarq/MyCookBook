//
//  RecipeCollectionViewCell.swift
//  MyCookBook
//
//  Created by SQLI51107 on 18/01/2016.
//  Copyright © 2016 MARQUET. All rights reserved.
//

import UIKit
import Alamofire

class RecipeCollectionViewCell: UICollectionViewCell {
    
    var imagePath: String = ""
    var request: Request?
    let downladImageRecipe      = NetworkConstants.ip_server+NetworkConstants.downloadImage
    
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var titleRecipe: UILabel!
    @IBOutlet weak var imageRecipe: UIImageView!
    
    var recipe: Recipe!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupView()
    }
    
    func setupView(){
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.blackColor().CGColor
    }
    
    func configure(recipe: Recipe) {
        self.recipe = recipe
        reset()
        loadImage()
    }
    
    func reset(){
        imageRecipe.image = nil
        request?.cancel()
    }
    
    func loadImage() {
        loadingIndicator.hidden = false
        loadingIndicator.startAnimating()
        let urlString = titleRecipe.text! + ".jpg"
        AlamofireManager.SharedInstance.getNetworkImage(urlString) { (image) -> Void in
            self.populateCell(image)
        }
        
        
        /*request = AlamofireManager.SharedInstance.getNetworkImage(urlString) { image in
            self.populateCell(image!)
        }*/
        
       /* AlamofireManager.SharedInstance.getNetworkImage(urlString) { (image) -> Void in
            self.populateCell(image)
        }*/
    }
    
    func populateCell(image: UIImage) {
        loadingIndicator.stopAnimating()
        loadingIndicator.hidden = true
        imageRecipe.image = image
    }
    
    
    
    
}
