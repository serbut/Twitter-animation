//
//  ViewController.swift
//  Twitter Animation
//
//  Created by Сергей Буторин on 29/09/2017.
//  Copyright © 2017 Sergey Butorin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var LongView: UIView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var headerInfo: UIView!
    @IBOutlet weak var headerImage: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var categoryButtonsView: UIView!
    @IBOutlet weak var headerImageOverlay: UIView!
    
    let headerMinOffset: CGFloat = 50
    let offsetInfoHeader: CGFloat = 85.0
    let positionInfoHeader: CGFloat = 50.0
    let maxAlphaFactor: CGFloat = 0.8
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        headerView.clipsToBounds = true
        setupAvatarImage()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        updateCategoryButtons(scrollView.contentOffset.y)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func setupAvatarImage() {
        avatarImageView.layer.cornerRadius = avatarImageView.frame.height/2
        avatarImageView.layer.borderWidth = 4
        avatarImageView.layer.borderColor = UIColor.white.cgColor
    }

    override var preferredStatusBarStyle: UIStatusBarStyle{
        return UIStatusBarStyle.lightContent
    }
}

extension ViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let offset = scrollView.contentOffset.y
        
        updateHeader(offset)
        updateCategoryButtons(offset)
        if offset > 0 {
            updateAvatar(offset)
            updateHeaderPosition(offset)
        }
    }
    
    func updateHeader(_ offset: CGFloat) {
        var headerTransform = CATransform3DIdentity
        
        if offset < 0 {
            let headerScaleFactor:CGFloat = -(offset) / headerView.bounds.height
            let headerSizevariation = ((headerView.bounds.height * (1.0 + headerScaleFactor)) - headerView.bounds.height)/2.0
            headerTransform = CATransform3DTranslate(headerTransform, 0, headerSizevariation, 0)
            headerTransform = CATransform3DScale(headerTransform, 1.0 + headerScaleFactor, 1.0 + headerScaleFactor, 0)
            headerView.layer.transform = headerTransform
        } else {
            headerTransform = CATransform3DTranslate(headerTransform, 0, max(-headerMinOffset, -offset), 0)
            let headerInfoTransform = CATransform3DMakeTranslation(0, max(-positionInfoHeader, offsetInfoHeader - offset), 0)
            headerInfo.layer.transform = headerInfoTransform
        }
        
        headerImageOverlay.alpha = min(maxAlphaFactor, abs(offset/50))
        headerView.layer.transform = headerTransform
    }
    
    func updateCategoryButtons(_ offset: CGFloat) {
        let categoryButtonsOffset = profileView.frame.height - categoryButtonsView.frame.height - offset
        var categoryButtonsTransform = CATransform3DIdentity
        categoryButtonsTransform = CATransform3DTranslate(categoryButtonsTransform, 0, max(categoryButtonsOffset, -headerMinOffset), 0)
        categoryButtonsView.layer.transform = categoryButtonsTransform
    }
    
    func updateAvatar(_ offset: CGFloat) {
        var avatarTransform = CATransform3DIdentity

        let avatarScaleFactor = (min(headerMinOffset, offset)) / avatarImageView.bounds.height / 1.8
        let avatarSizeVariation = ((avatarImageView.bounds.height * (1.0 + avatarScaleFactor)) - avatarImageView.bounds.height) / 2.0
        avatarTransform = CATransform3DTranslate(avatarTransform, 0, avatarSizeVariation, 0)
        avatarTransform = CATransform3DScale(avatarTransform, 1.0 - avatarScaleFactor, 1.0 - avatarScaleFactor, 0)
        
        avatarImageView.layer.transform = avatarTransform
    }
    
    func updateHeaderPosition(_ offset: CGFloat) {
        if offset <= headerMinOffset {
            if avatarImageView.layer.zPosition < headerView.layer.zPosition{
                headerView.layer.zPosition = 0
            }
        } else if avatarImageView.layer.zPosition >= headerView.layer.zPosition{
            headerView.layer.zPosition = 1
        }
    }
}
