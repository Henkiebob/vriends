//
//  PageViewController.swift
//  Vriends
//
//  Created by Geart Otten on 27/06/2018.
//  Copyright © 2018 Tjerk Dijkstra. All rights reserved.
//

import Foundation
import UIKit

class PageViewController: UIPageViewController {
    
    var pageControl = UIPageControl()
    var lastPageButton = UIButton()
    
    fileprivate lazy var pages: [UIViewController] = {
        return [
            self.getViewController(withIdentifier: "Page1"),
            self.getViewController(withIdentifier: "Page2"),
            self.getViewController(withIdentifier: "Page3"),
            self.getViewController(withIdentifier: "Page4"),
            self.getViewController(withIdentifier: "Page5")
        ]
    }()
    
    fileprivate func getViewController(withIdentifier identifier: String) -> UIViewController
    {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: identifier)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        self.delegate = self
        self.dataSource = self
        configurePageControl()
        
        if let firstVC = pages.first
        {
            setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
        }
        lastPageButton = UIButton(frame: CGRect(x: view.frame.width / 2 - 50, y: UIScreen.main.bounds.maxY - 50, width: 100, height: 50))
        lastPageButton.setTitle("Get started", for: .normal)
        lastPageButton.setTitleColor(UIColor(red: 0.15, green: 0.58, blue: 0.88, alpha: 1), for: .normal)
        
        
//        lastPageButton.setTitle("Get started", for: UIControlState.normal)
//
//        lastPageButton = UIButton(frame: CGRect(x: 0, y: UIScreen.main.bounds.maxY - 70, width: UIScreen.main.bounds.width, height: 50))
        
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.navigationController?.isNavigationBarHidden = false
    }
    @objc func buttonAction(_ sender: Any){
        performSegue(withIdentifier: "backToMainSegue", sender: nil)
    }
    
    func configurePageControl() {
        // The total number of pages that are available is based on how many available colors we have.
        pageControl = UIPageControl(frame: CGRect(x: 0,y: UIScreen.main.bounds.maxY - 50,width: UIScreen.main.bounds.width,height: 50))
        self.pageControl.numberOfPages = pages.count
        self.pageControl.currentPage = 0
        self.pageControl.tintColor = UIColor.black
        self.pageControl.pageIndicatorTintColor = UIColor(red: 0.43, green: 0.46, blue: 0.49, alpha: 0.25)
        self.pageControl.currentPageIndicatorTintColor = UIColor(red: 0.27, green: 0.66, blue: 0.95, alpha: 1)
        self.view.addSubview(pageControl)
       
    }
}
extension PageViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
    
        guard let viewControllerIndex = pages.index(of: viewController) else { return nil }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0
            else { return pages.last }
        
        guard pages.count > previousIndex
            else { return nil }
        
        return pages[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController?
    {
        guard let viewControllerIndex = pages.index(of: viewController) else { return nil }
        
        let nextIndex = viewControllerIndex + 1
        
        guard nextIndex < pages.count
            else { return pages.first }
        
        guard pages.count > nextIndex
            else {return nil }
        
        return pages[nextIndex]
    }
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        let pageContentViewController = pageViewController.viewControllers![0]
        self.pageControl.currentPage = pages.index(of: pageContentViewController)!
        if pageControl.currentPage == 4 {
            pageControl.removeFromSuperview()
            self.view.addSubview(lastPageButton)
            lastPageButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
            
        }
    }
}
