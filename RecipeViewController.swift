//
//  RecipeViewController.swift
//  MyCookBook
//
//  Created by SQLI51107 on 14/01/2016.
//  Copyright © 2016 MARQUET. All rights reserved.
//

import UIKit

class RecipeViewController: UIViewController, UIPopoverPresentationControllerDelegate {
    
    var titleViewController:String = String()    
    var recipeDetail:Recipe = Recipe()
    @IBOutlet weak var imageRecipe: UIImageView!
    @IBOutlet weak var ingredientsDetail: UITextView!
    @IBOutlet weak var titleRecipeDetail: UILabel!
    @IBOutlet weak var preparationRecipeDetail: UITextView!
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBarHidden = false
    }

    override func viewDidLoad() {
        super.viewDidLoad()

       navigationItem.title = recipeDetail.title
       imageRecipe.image = UIImage(named: recipeDetail.image)
       titleRecipeDetail.text = recipeDetail.title
        ingredientsDetail.text = recipeDetail.ingredients
        preparationRecipeDetail.text = recipeDetail.preparation
     
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backController(sender: AnyObject) {
        navigationController?.popViewControllerAnimated(true)
    }
    
   /* @IBAction func showRecipesList(sender: AnyObject) {
        
        self.performSegueWithIdentifier("showRecipesList", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showRecipesList" {
            let popoverViewController = segue.destinationViewController as! RecipeViewController
            popoverViewController.modalPresentationStyle = UIModalPresentationStyle.Popover
            popoverViewController.popoverPresentationController!.delegate = self
        }
    }
*/
}
