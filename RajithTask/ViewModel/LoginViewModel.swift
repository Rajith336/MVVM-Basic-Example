

import UIKit
import RxSwift
import RxCocoa

class LoginViewModel {
    var email = BehaviorRelay<String>(value: "")
    var password = BehaviorRelay<String>(value: "")
    
    
    func isValidEmail(email:String) -> Bool {
        // here, `try!` will always succeed because the pattern is valid
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: email)
    }
    
    func isValid() -> Observable<Bool>{
        return Observable.combineLatest(email.asObservable(), password.asObservable()) { mail , pass in
            (self.isValidEmail(email:mail)) && ((pass).count < 16) && ((pass).count >= 8)
        }
    }
}

