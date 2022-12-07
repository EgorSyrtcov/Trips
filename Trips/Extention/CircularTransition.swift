//
//  CircularTransition.swift
//  Trips
//
//  Created by Egor Syrtcov on 7.12.22.
//

import UIKit

enum CircularTransitionMode {
    case present, dismiss
}

final class CircularTransition: NSObject {
    
    private var circle = UIView()
    
    public var circleColor: UIColor = .gray
    public var duration = 0.3
    public var transitionMode: CircularTransitionMode = .present
    public var startingPoint = CGPoint.zero {
        didSet {
            circle.center = startingPoint
        }
    }
    
    private func frameForCircle(size: CGSize, startPoint: CGPoint) -> CGRect {
        let xLength = fmax(startPoint.x, size.width - startPoint.x)
        let yLength = fmax(startPoint.y, size.height - startPoint.y)
        let offSetVector = sqrt(xLength * xLength + yLength * yLength) * 2
        let size = CGSize(width: offSetVector, height: offSetVector)
        
        return CGRect(origin: .zero, size: size)
    }
}

extension CircularTransition: UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        
        if transitionMode == .present {
            guard let presentedView = transitionContext.view(forKey: .to) else {
                return
            }
            
            let viewCenter = presentedView.center
            let viewSize = presentedView.frame.size
            
            circle = UIView()
            circle.frame = frameForCircle(size: viewSize, startPoint: startingPoint)
            circle.layer.cornerRadius = circle.frame.width / 2
            circle.center = startingPoint
            circle.backgroundColor = circleColor
            circle.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
            containerView.addSubview(circle)
            
            presentedView.center = startingPoint
            presentedView.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
            presentedView.alpha = 0
            containerView.addSubview(presentedView)
            
            UIView.animate(withDuration: duration) { [weak self] in
                self?.circle.transform = CGAffineTransform.identity
                presentedView.transform = CGAffineTransform.identity
                presentedView.alpha = 1
                presentedView.center = viewCenter
            } completion: { success in
                transitionContext.completeTransition(success)
            }
            
        } else {
            guard let returnedView = transitionContext.view(forKey: .from) else {
                return
            }
            
            let viewSize = returnedView.frame.size
            circle.frame = frameForCircle(size: viewSize, startPoint: startingPoint)
            circle.layer.cornerRadius = circle.frame.width / 2
            circle.center = startingPoint
            
            guard let initialView = transitionContext.view(forKey: .to) else { return }
            containerView.insertSubview(initialView, belowSubview: circle)
            
            UIView.animate(withDuration: duration) { [weak self] in
                self?.circle.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
                returnedView.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
                returnedView.center = self?.startingPoint ?? .zero
                returnedView.alpha = 0
            } completion: { success in
                returnedView.removeFromSuperview()
                self.circle.removeFromSuperview()
                transitionContext.completeTransition(success)
            }
        }
    }
    
    
}
