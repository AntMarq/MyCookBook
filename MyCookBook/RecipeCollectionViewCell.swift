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
    }
    
    func downloadImage(){
        let urlString = titleRecipe.text! + ".jpg"
        AlamofireManager.SharedInstance.getNetworkImage(urlString) { (image,success) -> Void in
            if(success){
                self.populateCell(image)
            }
            else{
                self.loadingIndicator.hidden = true
            }
        }
    }
    
    func loadImage() {
        loadingIndicator.hidden = false
        if let image = AlamofireManager.SharedInstance.cachedImage(titleRecipe.text! + ".jpg") {
            populateCell(image)
            return
        }
        downloadImage()
    }
    
    func populateCell(image: UIImage) {
        loadingIndicator.stopAnimating()
        loadingIndicator.hidden = true
        imageRecipe.image = image
    }
}
