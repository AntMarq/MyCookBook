//
//  ViewController.swift
//  MyCookBook
//
//  Created by Anthony MARQUET on 13/01/2016.
//  Copyright © 2016 MARQUET. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var imgEntree: UIImageView!
    @IBOutlet weak var imgDessert: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        addGestureToImageView(imgEntree)
        addGestureToImageView(imgDessert)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    func imageTapped(img: AnyObject)
    {
       self.performSegueWithIdentifier("HomeToRecipe", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "HomeToRecipe"
        {
      //      if let destinationVC = segue.destinationViewController as? RecipeViewController{
               // destinationVC.numberToDisplay = counter
        }
    }
    
    func addGestureToImageView(img:UIImageView){
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:Selector("imageTapped:"))
        img .addGestureRecognizer(tapGestureRecognizer);
    }
    
    func backController(){
        navigationController?.popViewControllerAnimated(true)
    }
   

}

