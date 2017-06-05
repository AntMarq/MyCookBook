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
    
   
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let newRecipe = UIImage(named:"new_recipe")
        let apero = UIImage(named:"apero2")
        let entree = UIImage(named:"entree")
        let plat = UIImage(named:"plat")
        let dessert = UIImage(named:"dessert2")

        categoryList = [newRecipe!,apero!,entree!,plat!,dessert!]
        carousel.type = iCarouselType.rotary
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueID
        {
            if let destinationVC = segue.destination as? AllRecipesListCollectionViewController{

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
            if let destinationVC = segue.destination as? RecipeViewController{
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
        navigationController?.popViewController(animated: true)
    }
    
    func numberOfItems(in carousel: iCarousel) -> Int
    {
        return 5
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView
    {
        var itemView: UIImageView
        
        //create new view if no view is available for recycling
        if (view == nil)
        {
            //don't do anything specific to the index within
            //this `if (view == nil) {...}` statement because the view will be
            //recycled and used with other index values later
            itemView = UIImageView(frame:CGRect(x:0, y:0, width:500, height:500))
            itemView.image = self.categoryList[index]
            itemView.contentMode = .scaleAspectFit
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
    
    func carousel(_ carousel: iCarousel, valueFor option: iCarouselOption, withDefault value: CGFloat) -> CGFloat
    {
        if (option == .spacing)
        {
            return value * 1.1
        }
        return value
    }
    
    func carousel(_ carousel: iCarousel, didSelectItemAt index: Int) {
        imgID = index+1
        self.performSegue(withIdentifier: segueID, sender: self)
    }

    
    
}



