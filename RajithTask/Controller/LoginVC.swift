
import UIKit
import RxSwift
import RxCocoa

class LoginVC: UIViewController {
    //MARK:- Initialization
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var btnLogin: UIButton!
    let disposeBag = DisposeBag()
    lazy var viewModel : LoginViewModel = {
        return LoginViewModel()
    }()
    //MARK:- ViewLifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        initViewModel()
        btnLogin.isEnabled = true
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
        txtEmail.rx.text.map{$0 ?? ""}.bind(to: viewModel.email).disposed(by: disposeBag)
        txtPassword.rx.text.map{$0 ?? ""}.bind(to: viewModel.password).disposed(by: disposeBag)
        
        viewModel.isValid().bind(to: btnLogin.rx.isEnabled).disposed(by: disposeBag)
        viewModel.isValid().map{$0 ? 1 : 0.5}.bind(to: btnLogin.rx.alpha).disposed(by: disposeBag)
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
        //viewModel.validation()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        btnLoginEnable(isEnable:false)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        
        if textField == txtPassword {
            return updatedText.count <= 15
        } else{
            return true
        }
    }
}


