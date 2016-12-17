//
//  AssistantViewController.swift
//  AssistantViewController
//
//  Created by Marcel Dierkes on 31.07.16.
//  Copyright © 2016 Marcel Dierkes. All rights reserved.
//

import UIKit

private let defaultHeaderHeight: CGFloat = 104.0
private let animationDuration: TimeInterval = 0.3

public final class AssistantViewController: UIViewController {
    
    // MARK: - Properties
    public let primaryViewController: UIViewController
    
    public weak var delegate: AssistantViewControllerDelegate? = nil
    public weak var dataSource: AssistantViewControllerDataSource? = nil
    
    public var currentStepViewController: UIViewController? {
        return self.stepsNavigationController.topViewController
    }
    
    fileprivate var stepsNavigationController: UINavigationController!
    
    fileprivate var primaryViewControllerHeaderConstraint: NSLayoutConstraint!
    
    fileprivate var _preferredPrimaryViewControllerHeight: CGFloat = defaultHeaderHeight {
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
    
    public func setPreferredPrimaryViewControllerHeight(_ height: CGFloat, animated: Bool) {
        UIView.animate(withDuration: animationDuration, animations: {
            self._preferredPrimaryViewControllerHeight = height
            self.view.layoutIfNeeded()
        }) 
    }
    
    // MARK: - Life Cycle
    public init(primaryViewController: UIViewController) {
        self.primaryViewController = primaryViewController
        
        super.init(nibName: nil, bundle: nil)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        self.primaryViewController = aDecoder.decodeObject(forKey: "PrimaryViewController") as! UIViewController
        super.init(coder: aDecoder)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.configureChildViewControllers()
    }
    
    public override var childViewControllerForStatusBarStyle: UIViewController? {
        return self.primaryViewController
    }
    
    public override var childViewControllerForStatusBarHidden: UIViewController? {
        return self.primaryViewController
    }
    
    // MARK: - Transitioning
    @discardableResult
    public func pushNextViewController(animated: Bool = true) -> UIViewController? {
        guard let nextViewController = self.dataSource?.assistantViewControllerViewControllerForNextStep(self) else {
            return nil
        }
        self.stepsNavigationController.pushViewController(nextViewController, animated: animated)
        return nextViewController
    }
    
    @discardableResult
    public func popToPreviousViewController(animated: Bool = true) -> UIViewController? {
        return self.stepsNavigationController.popViewController(animated: animated)
    }
}

// MARK: - Child View Controllers
private extension AssistantViewController {
    func configureChildViewControllers() {
        let top = self.primaryViewController
        self.addChildViewController(top)
        self.view.addSubview(top.view)
        top.didMove(toParentViewController: self)
        
        let navController = UINavigationController(navigationBarClass: nil, toolbarClass: nil)
        self.addChildViewController(navController)
        navController.isNavigationBarHidden = true
        navController.isToolbarHidden = true
        navController.delegate = self
        if let pop = navController.interactivePopGestureRecognizer {
            self.view.addGestureRecognizer(pop)
        }
        self.stepsNavigationController = navController
        self.view.addSubview(navController.view)
        navController.didMove(toParentViewController: self)
        
        self.configurePrimaryConstraints()
        self.configureFirstStepViewController()
    }
    
    func configurePrimaryConstraints() {
        let top = self.primaryViewController.view
        let bottom = self.stepsNavigationController.view
        
        top?.translatesAutoresizingMaskIntoConstraints = false
        top?.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        top?.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        top?.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        top?.bottomAnchor.constraint(equalTo: (bottom?.topAnchor)!).isActive = true
        
        let heightConstraint = NSLayoutConstraint(
            item: top as Any,
            attribute: .height,
            relatedBy: .equal,
            toItem: nil,
            attribute: .notAnAttribute,
            multiplier: 1.0,
            constant: self.preferredPrimaryViewControllerHeight
        )
        heightConstraint.priority = UILayoutPriorityFittingSizeLevel
        self.primaryViewControllerHeaderConstraint = heightConstraint
        top?.addConstraint(heightConstraint)
        
        bottom?.translatesAutoresizingMaskIntoConstraints = false
        bottom?.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        bottom?.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        bottom?.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
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
    public func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        self.delegate?.assistantViewController(self, willShow: viewController, animated: animated)
    }
    
    public func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        self.delegate?.assistantViewController(self, didShow: viewController, animated: animated)
    }
}
