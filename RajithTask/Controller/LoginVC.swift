
import UIKit

class LoginVC: UIViewController {
    //MARK:- Initialization
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var btnLogin: UIButton!
    
    lazy var viewModel : LoginViewModel = {
        return LoginViewModel()
    }()
    //MARK:- ViewLifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        initViewModel()
        
    }
    
    
    //MARK:- Button Actions
    @IBAction func login(_ sender: UIButton) {
        print("Login Success")
    }
    
    //MARK:- Local Method
    func setupUI(){
        [txtEmail,txtPassword].forEach{ txt in
            txt?.layer.cornerRadius = 5
            txt?.layer.borderWidth = 1.5
            txt?.layer.borderColor = UIColor.darkGray.cgColor
        }
        
        btnLogin.layer.cornerRadius = 5
        btnLoginEnable(isEnable:false)
    }
    
    func initViewModel(){
        viewModel.validationSuccessClosure = { (isValid) in
            self.btnLoginEnable(isEnable:isValid)
        }
        
        viewModel.emailClosure = { (isValid) in
            self.txtEmail.layer.borderColor = isValid ? UIColor.darkGray.cgColor : UIColor.red.cgColor
        }
        
        viewModel.passwordClosure = { (isValid) in
            self.txtPassword.layer.borderColor = isValid ? UIColor.darkGray.cgColor : UIColor.red.cgColor
        }
    }
    
    func btnLoginEnable(isEnable:Bool){
        btnLogin.isEnabled = isEnable
        btnLogin.alpha = isEnable ? 1 : 0.5
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

//MARK:- TextField Delegate
extension LoginVC: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField == txtEmail {
            txtPassword.becomeFirstResponder()
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        viewModel.validation()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        btnLoginEnable(isEnable:false)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        
        if textField == txtPassword {
            viewModel.updatePasswordCredentials(password: updatedText)
            viewModel.validation()
            return updatedText.count <= 15
        } else{
            viewModel.updateEmailCredentials(email: updatedText)
            viewModel.validation()
            return true
        }
    }
}


