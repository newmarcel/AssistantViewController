//
//  ViewController.swift
//  ExampleApp
//
//  Created by Marcel Dierkes on 31.07.16.
//  Copyright © 2016 Marcel Dierkes. All rights reserved.
//

import UIKit
import AssistantViewController

private enum Storyboard: String {
    case SetupHeaderViewController
    case FirstStepViewController
    case SecondStepViewController
    case ThirdStepViewController
    
    var storyboard: UIStoryboard {
        return UIStoryboard(name: "SetupSteps", bundle: nil)
    }
    
    var viewController: UIViewController {
        return self.storyboard.instantiateViewController(withIdentifier: self.rawValue)
    }
}

class ViewController: UIViewController {
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Actions
    @IBAction func showAssistantViewController(_ sender: UIButton?) {
        let viewController = Storyboard.SetupHeaderViewController.viewController
        let assistantViewController = AssistantViewController(primaryViewController: viewController)
        assistantViewController.dataSource = self
        assistantViewController.delegate = self
        
        self.present(assistantViewController, animated: true, completion: nil)
    }
    
    @IBAction func finishAssistant(_ segue: UIStoryboardSegue?) {
        segue?.source.dismiss(animated: true, completion: nil)
    }
}

extension ViewController: AssistantViewControllerDelegate {
    func assistantViewController(_ controller: AssistantViewController, willShow viewController: UIViewController, animated: Bool) {
        let header = (controller.primaryViewController as? UINavigationController)?.topViewController as? SetupHeaderViewController
        
        switch viewController.view.tag {
        case 1:
            header?.progress = 0.1
        case 2:
            header?.progress = 0.5
        case 3:
            header?.progress = 0.9
        default:
            header?.progress = 1.0
        }
    }
    
    func assistantViewController(_ controller: AssistantViewController, didShow viewController: UIViewController, animated: Bool) {}
}

extension ViewController: AssistantViewControllerDataSource {
    func assistantViewControllerViewControllerForNextStep(_ controller: AssistantViewController) -> UIViewController? {
        guard let tag = controller.currentStepViewController?.view.tag else {
            return Storyboard.FirstStepViewController.viewController
        }
        switch tag {
        case 1:
            return Storyboard.SecondStepViewController.viewController
        case 2:
            return Storyboard.ThirdStepViewController.viewController
        case 3:
            return nil
        default:
            return nil
        }
    }
}

