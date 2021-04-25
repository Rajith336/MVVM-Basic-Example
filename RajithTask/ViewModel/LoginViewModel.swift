

import UIKit


class LoginViewModel {
    
    public var validationSuccessClosure: ((Bool) -> ())?
    public var emailClosure:((Bool) -> ())?
    public var passwordClosure:((Bool) -> ())?
    
    private var email = ""
    private var password = ""
    
    private var credentials = LoginCredentials(){
        didSet{
            email = credentials.email
            password = credentials.password
        }
    }
    
    func updateEmailCredentials(email: String) {
        credentials.email = email
        self.emailClosure?(self.isValidEmail(email: credentials.email))
        validation()
    }
    
    func updatePasswordCredentials(password: String) {
        credentials.password = password
        self.passwordClosure?(self.password.count >= 8)
        validation()
    }
    
    func validation(){
        if (isValidEmail(email:email)) && ((self.password).count < 16) && ((self.password).count >= 8) {
            self.validationSuccessClosure?(true)
        } else{
            self.validationSuccessClosure?(false)
        }
    }
    
    func isValidEmail(email:String) -> Bool {
        // here, `try!` will always succeed because the pattern is valid
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: email)
    }
    
}

