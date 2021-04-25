

import UIKit

class ActivityIndicatorView {
    let vc = (UIApplication.shared.connectedScenes
                .first!.delegate as! SceneDelegate).window?.rootViewController ?? UIViewController()
    var view: UIView!
    
    var activityIndicator: UIActivityIndicatorView!
    
    var title: String!
    
    init(title: String, width: CGFloat = 200.0, height: CGFloat = 50.0) {
        let center = vc.view.center
        self.title = title
        
        let x = center.x - width/2.0
        let y = center.y - height/2.0
        
        self.view = UIView(frame: CGRect(x: x, y: y, width: width, height: height))
        self.view.backgroundColor = UIColor(red: 247.0/255.0, green: 200.0/255.0, blue: 0.0/255.0, alpha: 0.5)
        self.view.layer.cornerRadius = 10
        
        self.activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        self.activityIndicator.color = UIColor.black
        self.activityIndicator.hidesWhenStopped = false
        
        let titleLabel = UILabel(frame: CGRect(x: 60, y: 0, width: 200, height: 50))
        titleLabel.text = title
        titleLabel.textColor = UIColor.black
        
        self.view.addSubview(self.activityIndicator)
        self.view.addSubview(titleLabel)
        self.view.tag = 12
        vc.view.addSubview(view)
    }
    
    func getViewActivityIndicator() -> UIView {
        return self.view
    }
    
    func startAnimating() {
        self.activityIndicator.startAnimating()
        self.vc.view.isUserInteractionEnabled = false
    }
    
    func stopAnimating() {
        self.activityIndicator.stopAnimating()
        self.vc.view.isUserInteractionEnabled = true
        self.view.removeFromSuperview()
        for vw in self.vc.view.subviews{
            if vw.tag == 12 {
                vw.removeFromSuperview()
            }
        }
    }
}
