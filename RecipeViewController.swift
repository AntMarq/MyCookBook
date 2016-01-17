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
    
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBarHidden = false
    }

    override func viewDidLoad() {
        super.viewDidLoad()

       navigationItem.title = titleViewController
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backController(sender: AnyObject) {
        navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func showRecipesList(sender: AnyObject) {
        
        self.performSegueWithIdentifier("showRecipesList", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showRecipesList" {
            let popoverViewController = segue.destinationViewController as! RecipeViewController
            popoverViewController.modalPresentationStyle = UIModalPresentationStyle.Popover
            popoverViewController.popoverPresentationController!.delegate = self
        }
    }
    /*
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
