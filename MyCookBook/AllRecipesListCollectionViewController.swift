//
//  AllRecipesListCollectionViewController.swift
//  MyCookBook
//
//  Created by SQLI51107 on 18/01/2016.
//  Copyright © 2016 MARQUET. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

private let reuseIdentifier = "Cell"
private let segueID = "RecipesListToRecipeDetail"

class AllRecipesListCollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    @IBOutlet weak var recipeCollectionView: UICollectionView!
    var titleViewController:String = String()
    var categorieFilter:String = String()
    var listRecipes:Array<Recipe> = Array<Recipe>()
    var recipeDetail:Recipe = Recipe()
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBarHidden = false
        IQKeyboardManager.sharedManager().canAdjustTextView = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.recipeCollectionView?.registerNib(UINib (nibName: "RecipeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
        navigationItem.title = titleViewController
        
        
        AlamofireManager.SharedInstance.getToken { (success) -> Void in
            AlamofireManager.SharedInstance.downloadOrderedRecipes(self.categorieFilter, completion: { (recipes) -> Void in
                RealmManager.SharedInstance.writeRecipesInDB(recipes, needUpdate: false, completion: { (bool) -> Void in
                    self.getRecipesfromDB(self.categorieFilter, completion: { (recipeArray) -> Void in
                        self.recipeCollectionView.reloadData()
                    })
                })
            })
        }
    }
    
    func getRecipesfromDB(category:String, completion: (recipeArray: Array<Recipe>) -> Void){
        if(self.categorieFilter != "0"){
            RealmManager.SharedInstance.getRecipesCategoryFromDB(self.categorieFilter, completion:{ (recipe) -> Void in
                self.listRecipes = recipe
                completion(recipeArray: self.listRecipes)
            })
        }
        else{
            RealmManager.SharedInstance.getAllRecipeFromDB { (recipe) -> Void in
                self.listRecipes = recipe
                completion(recipeArray: self.listRecipes)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backViewController(sender: UIBarButtonItem) {
        navigationController?.popViewControllerAnimated(true)
    }
    
    // MARK: UICollectionViewDataSource
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return listRecipes.count
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell:RecipeCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! RecipeCollectionViewCell
        cell.titleRecipe.text = listRecipes[indexPath.row].title
        //cell.imageRecipe.image = UIImage(named: listRecipes[indexPath.row].image)
        PhotoManager.sharedInstance.retrieveImageWithIdentifer(recipeDetail.image) { (image) -> Void in
            cell.imageRecipe.image = image
        }

        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if let cell = collectionView.cellForItemAtIndexPath(indexPath) {
            performSegueWithIdentifier(segueID, sender: cell)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let indexPath = self.recipeCollectionView?.indexPathForCell(sender as! UICollectionViewCell) {
            if segue.identifier == segueID
            {
                if let destinationVC = segue.destinationViewController as? RecipeViewController{
                    let objectData:Recipe = listRecipes[indexPath.row]
                    destinationVC.recipeDetail = objectData
                }
            }
        }
    }
}
