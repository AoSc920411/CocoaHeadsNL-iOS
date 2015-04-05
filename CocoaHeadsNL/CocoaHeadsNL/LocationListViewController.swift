//
//  LocationListViewController.swift
//  CocoaHeadsNL
//
//  Created by Bart Hoffman on 10/03/15.
//  Copyright (c) 2015 Stichting CocoaheadsNL. All rights reserved.
//

import Foundation

class LocationListViewController: PFQueryCollectionViewController, UICollectionViewDelegateFlowLayout {
    
    
    override func queryForCollection() -> PFQuery! {
        let query = Company.query()
        query.cachePolicy = PFCachePolicy.CacheThenNetwork
        return query
    }
    
    override func viewWillAppear(animated: Bool) {
        self.loadObjects()
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        
        coordinator.animateAlongsideTransition({ (context: UIViewControllerTransitionCoordinatorContext!) -> Void in
            self.collectionViewLayout.invalidateLayout()
            self.loadObjects()
            }, completion: { (context:UIViewControllerTransitionCoordinatorContext!) -> Void in
                
        })
    }
    
    override func didMoveToParentViewController(parent: UIViewController?) {
        // when presented by NavigationController through SplitViewController
        self.collectionViewLayout.invalidateLayout()
    }
    
    //MARK: - UICollectionViewDataSource methods
    override func collectionView(collectionView: UICollectionView!, cellForItemAtIndexPath indexPath: NSIndexPath!, object: PFObject!) -> PFCollectionViewCell! {
        let company = object as Company

        let cell = super.collectionView(collectionView, cellForItemAtIndexPath: indexPath, object: object)

        let logoWidth: CGFloat = 120.0
        let labelWidth = cell.bounds.width - logoWidth
        
        cell.textLabel.frame = CGRect(x: logoWidth, y: 5, width: labelWidth, height:20)
        cell.textLabel.text = company.name
        
        if let companyLogo = company.logo {
            cell.imageView.file = companyLogo
            cell.imageView.contentMode = .ScaleAspectFit
            cell.imageView.frame = CGRect(x:0.0, y:5.0, width:logoWidth, height:70.0)
            cell.imageView.image = UIImage(named: "CocoaHeadsNLLogo")
            cell.imageView.loadInBackground(nil)
        }
        
        cell.contentView.layer.borderWidth = 0.5
        cell.contentView.layer.borderColor = UIColor.grayColor().CGColor
        
        return cell
    }
    
    
    //MARK: - UICollectionViewDelegate methods
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let selectedObject = self.objectAtIndexPath(indexPath)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("detailTableViewController") as DetailTableViewController
        vc.selectedObject = selectedObject
        showDetailViewController(vc, sender: self)
    }
    
    //MARK: - UICollectionViewDelegateFlowLayout methods
    
    override func collectionView(collectionView : UICollectionView,layout collectionViewLayout:UICollectionViewLayout,sizeForItemAtIndexPath indexPath:NSIndexPath) -> CGSize
    {
        return CGSize(width: self.view.bounds.width - 15, height: 80)
    }
}
