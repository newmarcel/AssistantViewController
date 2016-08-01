//
//  AssistantViewController.swift
//  AssistantViewController
//
//  Created by Marcel Dierkes on 31.07.16.
//  Copyright © 2016 Marcel Dierkes. All rights reserved.
//

import UIKit

private let defaultHeaderHeight: CGFloat = 104.0
private let animationDuration: NSTimeInterval = 0.3

public final class AssistantViewController: UIViewController {
    
    // MARK: - Properties
    public let primaryViewController: UIViewController
    
    public weak var delegate: AssistantViewControllerDelegate? = nil
    public weak var dataSource: AssistantViewControllerDataSource? = nil
    
    public var currentStepViewController: UIViewController? {
        return self.stepsNavigationController.topViewController
    }
    
    private var stepsNavigationController: UINavigationController!
    
    private var primaryViewControllerHeaderConstraint: NSLayoutConstraint!
    
    private var _preferredPrimaryViewControllerHeight: CGFloat = defaultHeaderHeight {
        didSet {
            self.primaryViewControllerHeaderConstraint.constant = _preferredPrimaryViewControllerHeight
        }
    }
    
    public var preferredPrimaryViewControllerHeight: CGFloat {
        get {
            return self._preferredPrimaryViewControllerHeight
        }
        set(newValue) {
            self._preferredPrimaryViewControllerHeight = newValue
        }
    }
    
    public func setPreferredPrimaryViewControllerHeight(height: CGFloat, animated: Bool) {
        UIView.animateWithDuration(animationDuration) {
            self._preferredPrimaryViewControllerHeight = height
            self.view.layoutIfNeeded()
        }
    }
    
    // MARK: - Life Cycle
    public init(primaryViewController: UIViewController) {
        self.primaryViewController = primaryViewController
        
        super.init(nibName: nil, bundle: nil)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        self.primaryViewController = aDecoder.decodeObjectForKey("PrimaryViewController") as! UIViewController
        super.init(coder: aDecoder)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.configureChildViewControllers()
    }
    
    public override func childViewControllerForStatusBarStyle() -> UIViewController? {
        return self.primaryViewController
    }
    
    public override func childViewControllerForStatusBarHidden() -> UIViewController? {
        return self.primaryViewController
    }
    
    // MARK: - Transitioning
    public func pushNextViewController(animated animated: Bool = true) -> UIViewController? {
        guard let nextViewController = self.dataSource?.assistantViewControllerViewControllerForNextStep(self) else {
            return nil
        }
        self.stepsNavigationController.pushViewController(nextViewController, animated: animated)
        return nextViewController
    }
    public func popToPreviousViewController(animated animated: Bool = true) -> UIViewController? {
        return self.stepsNavigationController.popViewControllerAnimated(animated)
    }
}

// MARK: - Child View Controllers
private extension AssistantViewController {
    func configureChildViewControllers() {
        let top = self.primaryViewController
        self.addChildViewController(top)
        self.view.addSubview(top.view)
        top.didMoveToParentViewController(self)
        
        let navController = UINavigationController(navigationBarClass: nil, toolbarClass: nil)
        self.addChildViewController(navController)
        navController.navigationBarHidden = true
        navController.toolbarHidden = true
        navController.delegate = self
        if let pop = navController.interactivePopGestureRecognizer {
            self.view.addGestureRecognizer(pop)
        }
        self.stepsNavigationController = navController
        self.view.addSubview(navController.view)
        navController.didMoveToParentViewController(self)
        
        self.configurePrimaryConstraints()
        self.configureFirstStepViewController()
    }
    
    func configurePrimaryConstraints() {
        let top = self.primaryViewController.view
        let bottom = self.stepsNavigationController.view
        
        top.translatesAutoresizingMaskIntoConstraints = false
        top.topAnchor.constraintEqualToAnchor(self.view.topAnchor).active = true
        top.leadingAnchor.constraintEqualToAnchor(self.view.leadingAnchor).active = true
        top.trailingAnchor.constraintEqualToAnchor(self.view.trailingAnchor).active = true
        top.bottomAnchor.constraintEqualToAnchor(bottom.topAnchor).active = true
        
        let heightConstraint = NSLayoutConstraint(
            item: top,
            attribute: .Height,
            relatedBy: .Equal,
            toItem: nil,
            attribute: .NotAnAttribute,
            multiplier: 1.0,
            constant: self.preferredPrimaryViewControllerHeight
        )
        heightConstraint.priority = UILayoutPriorityFittingSizeLevel
        self.primaryViewControllerHeaderConstraint = heightConstraint
        top.addConstraint(heightConstraint)
        
        bottom.translatesAutoresizingMaskIntoConstraints = false
        bottom.leadingAnchor.constraintEqualToAnchor(self.view.leadingAnchor).active = true
        bottom.trailingAnchor.constraintEqualToAnchor(self.view.trailingAnchor).active = true
        bottom.bottomAnchor.constraintEqualToAnchor(self.view.bottomAnchor).active = true
    }
    
    func configureFirstStepViewController() {
        guard let firstStep = self.dataSource?.assistantViewControllerViewControllerForNextStep(self) else {
            NSLog("Failed to retrieved first step view controller")
            return
        }
        
        self.stepsNavigationController.viewControllers = [firstStep]
    }
}

extension AssistantViewController: UINavigationControllerDelegate {
    public func navigationController(navigationController: UINavigationController, willShowViewController viewController: UIViewController, animated: Bool) {
        self.delegate?.assistantViewController(self, willShow: viewController, animated: animated)
    }
    
    public func navigationController(navigationController: UINavigationController, didShowViewController viewController: UIViewController, animated: Bool) {
        self.delegate?.assistantViewController(self, didShow: viewController, animated: animated)
    }
}
