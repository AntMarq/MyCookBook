//
//  MainViewController.swift
//  MyCookBook
//
//  Created by Anthony MARQUET on 13/01/2016.
//  Copyright © 2016 MARQUET. All rights reserved.
//

import UIKit

private var homeSegueId = "HomeToRecipesList"
private var newRecipeSegueId = "newRecipe"

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

    @IBOutlet weak var labelNewRecipe: UILabel!
    
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
        if(segue.identifier == homeSegueId)
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
        else if(segue.identifier == newRecipeSegueId){
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
        var label: UILabel
        let labelWidth = 240
        let labelHeight = 30
        
        //create new view if no view is available for recycling
        if (view == nil)
        {
            //don't do anything specific to the index within
            //this `if (view == nil) {...}` statement because the view will be
            //recycled and used with other index values later
            itemView = UIImageView(frame:CGRect(x:0, y:0, width:500, height:400))
            itemView.image = self.categoryList[index]
            itemView.contentMode = .scaleAspectFit
            itemView.tag = index
            //Center label in itemView
            let labelHeightPosition = (Float(itemView.frame.size.width/2))-(Float(labelWidth/2))
            let labelWidthPosition = (Float(itemView.frame.size.height/2))-(Float(labelHeight/2))
            label = UILabel(frame: CGRect(x:Int(labelHeightPosition),y:Int(labelWidthPosition),width:labelWidth,height:labelHeight))
            label.textColor = UIColor.black
            label.textAlignment = .center
            label.font = label.font.withSize(30)
            label.tag = 1
            itemView.addSubview(label)
        }
        else
        {
            //get a reference to the label in the recycled view
            itemView = view as! UIImageView;
            label = view?.viewWithTag(1) as! UILabel

        }
        label.text = "Nouvelle Recette"

        if(index == 0){
            label.isHidden = false
        }
        else{
            label.isHidden = true
        }

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
        var selectedSegueId = homeSegueId

        if(index==0){
            selectedSegueId = newRecipeSegueId
        }
       
        imgID = index
        self.performSegue(withIdentifier: selectedSegueId, sender: self)
    }

    
    
}



