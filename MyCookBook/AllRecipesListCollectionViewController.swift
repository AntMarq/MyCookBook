//
//  AllRecipesListCollectionViewController.swift
//  MyCookBook
//
//  Created by SQLI51107 on 18/01/2016.
//  Copyright © 2016 MARQUET. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class AllRecipesListCollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    @IBOutlet weak var recipeCollectionView: UICollectionView!
    var titleViewController:String = String()
    var listRecipes:Array<Recipe> = Array<Recipe>()
    var recipeDetail:Recipe = Recipe()
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBarHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.recipeCollectionView?.registerNib(UINib (nibName: "RecipeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
        navigationItem.title = titleViewController
        
        recipeDetail.title = "Risotto"
        recipeDetail.image = "miniature_recette_risotto"
        recipeDetail.tps_cuisson = "30 minutes"
        recipeDetail.tps_preparation = "30 minutes"
        recipeDetail.preparation = ""
        recipeDetail.nb_personne = ""
        recipeDetail.ingredients = " - huile d'olive de Toscane ou d'Italie \n - 250 g de riz à risotto \n - oignon hachésafran (1 dose ou quelques filaments) \n - bouillon de volaille \n - 1 verre de vin blanc sec \n - parmesan (facultatif)"
        
        
        listRecipes.append(recipeDetail)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func backViewController(sender: UIBarButtonItem) {
        navigationController?.popViewControllerAnimated(true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 1
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell:RecipeCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! RecipeCollectionViewCell
        cell.titleRecipe.text = listRecipes[indexPath.row].title
        cell.imageRecipe.image = UIImage(named: listRecipes[indexPath.row].image)
        
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if let cell = collectionView.cellForItemAtIndexPath(indexPath) {
            performSegueWithIdentifier("RecipesListToRecipeDetail", sender: cell)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let indexPath = self.recipeCollectionView?.indexPathForCell(sender as! UICollectionViewCell) {
            if segue.identifier == "RecipesListToRecipeDetail"
            {
                if let destinationVC = segue.destinationViewController as? RecipeViewController{
                    let objectData:Recipe = listRecipes[indexPath.row]
                    destinationVC.recipeDetail = objectData
                }
            }
        }
    }
}
