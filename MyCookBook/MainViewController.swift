//
//  MainViewController.swift
//  MyCookBook
//
//  Created by Anthony MARQUET on 13/01/2016.
//  Copyright © 2016 MARQUET. All rights reserved.
//

import UIKit

private let segueID = "HomeToRecipesList"

class MainViewController: UIViewController, iCarouselDataSource, iCarouselDelegate {
    
    var imgID = 0
    let titleImgApero:String = "Mes Apéritifs"
    let titleImgEntree:String = "Mes Entrées"
    let titleImgPlat:String = "Mes Plats Principaux"
    let titleImgDessert:String = "Mes Desserts"
    var categoryList:[UIImage] = []
    let idCategoryApero:Int = 4
    let idCategoryEntree:Int = 1
    let idCategoryPlat:Int = 2
    let idCategoryDessert:Int = 3

    
    @IBOutlet weak var carousel: iCarousel!
    @IBOutlet weak var imgEntree: UIImageView!
    @IBOutlet weak var imgDessert: UIImageView!
    @IBOutlet weak var imgPlat: UIImageView!
    @IBOutlet weak var imgApero: UIImageView!
    
   
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBarHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        categoryList = [imgApero.image!,imgEntree.image!,imgPlat.image!,imgDessert.image!]
        carousel.type = iCarouselType.Rotary
        carousel.scrollSpeed = 0.4
        AlamofireManager.SharedInstance.getToken { (success) -> Void in
            if(!success){
                print("No token")
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == segueID
        {
            if let destinationVC = segue.destinationViewController as? AllRecipesListCollectionViewController{

                if imgID == 1{
                    destinationVC.titleViewController = self.titleImgApero
                    destinationVC.categorieFilter = String(self.idCategoryApero)
                }
                else if imgID == 2{
                    destinationVC.titleViewController = self.titleImgEntree
                    destinationVC.categorieFilter = String(self.idCategoryEntree)
                }
                else if imgID == 3{
                    destinationVC.titleViewController = self.titleImgPlat
                    destinationVC.categorieFilter = String(self.idCategoryPlat)
                }
                else{
                    destinationVC.titleViewController = self.titleImgDessert
                    destinationVC.categorieFilter = String(self.idCategoryDessert)
                }
            }
        }
        else if(segue.identifier == "newRecipe"){
            if let destinationVC = segue.destinationViewController as? RecipeViewController{
                destinationVC.recipeDetail = Recipe()
                destinationVC.newRecipe = true
            }
        }
    }
    
    
   /* func addGestureToImageView(img:UIImageView){
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:Selector("imageTapped:"))
        img.addGestureRecognizer(tapGestureRecognizer);
    }*/
    
    func backController(){
        navigationController?.popViewControllerAnimated(true)
    }
    
    func numberOfItemsInCarousel(carousel: iCarousel) -> Int
    {
        return 4
    }
    
    func carousel(carousel: iCarousel, viewForItemAtIndex index: Int, reusingView view: UIView?) -> UIView
    {
        var itemView: UIImageView
        
        //create new view if no view is available for recycling
        if (view == nil)
        {
            //don't do anything specific to the index within
            //this `if (view == nil) {...}` statement because the view will be
            //recycled and used with other index values later
            itemView = UIImageView(frame:CGRect(x:0, y:0, width:350, height:280))
            itemView.image = self.categoryList[index]
            itemView.contentMode = .ScaleToFill
            itemView.tag = index
        }
        else
        {
            //get a reference to the label in the recycled view
            itemView = view as! UIImageView;
        }
        
        //set item label
        //remember to always set any properties of your carousel item
        //views outside of the `if (view == nil) {...}` check otherwise
        //you'll get weird issues with carousel item content appearing
        //in the wrong place in the carousel
        
        return itemView
    }
    
    func carousel(carousel: iCarousel, valueForOption option: iCarouselOption, withDefault value: CGFloat) -> CGFloat
    {
        if (option == .Spacing)
        {
            return value * 3
        }
        return value
    }
    
    func carousel(carousel: iCarousel, didSelectItemAtIndex index: Int) {
        imgID = index+1
        self.performSegueWithIdentifier(segueID, sender: self)
    }

    
    
}



