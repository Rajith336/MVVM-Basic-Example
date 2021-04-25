

import UIKit
import RxSwift

class PostVC: UIViewController {
    // MARK: - Initialization
    @IBOutlet weak var tblPost: UITableView!
    let disposeBag = DisposeBag()
    lazy var viewModel : PostViewModel = {
        return PostViewModel()
    }()
    
    
    // MARK: - ViewLifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        initViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.fetchPostAPi()
    }
    
    // MARK: - Local Method
    func initUI(){
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        tblPost.tableFooterView = UIView()
        tblPost.layoutMargins = UIEdgeInsets.zero
        tblPost.separatorInset = UIEdgeInsets.zero
    }
    
    func initViewModel(){
        viewModel.isSuccess().subscribe { [weak self](isSuccess) in
            if isSuccess.element ?? false{
                DispatchQueue.main.async {
                    self?.tblPost.reloadData()
                }
            }
            
        }.disposed(by: disposeBag)
        
        viewModel.isFaliure().subscribe { [weak self](error) in
            if (error.element ?? "") != "" {
                DispatchQueue.main.async {
                    self?.showAlertAction(message: error.element ?? "")
                }
            }
            
        }.disposed(by: disposeBag)
        
    }
    
    //MARK:- ShowAlertAction
    func showAlertAction(message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: {(action:UIAlertAction!) in
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
}

// MARK: - TableView Delegatea
extension PostVC:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if viewModel.numberOfRowsInSection(at: section) > 0{
            self.tblPost.backgroundView = nil
            self.tblPost.separatorStyle = .singleLine
            return  viewModel.numberOfRowsInSection(at: section)
        } else{
            
            let rect = CGRect(x: 0,y: 0,width: self.tblPost.bounds.size.width,height: self.tblPost.bounds.size.height)
            let noDataLabel: UILabel = UILabel(frame: rect)
            
            noDataLabel.text = "There is no data"
            noDataLabel.textColor = UIColor.darkText
            noDataLabel.textAlignment = NSTextAlignment.center
            self.tblPost.backgroundView = noDataLabel
            self.tblPost.separatorStyle = .none
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as? PostCell else { return UITableViewCell() }
        let model = viewModel.cellForRowAtIndexPath(at: indexPath)
        cell.lblBody.text = model.body ?? ""
        cell.lblTitle.text = model.title ?? ""
        cell.layoutMargins = UIEdgeInsets.zero
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let refreshAlert = UIAlertController(title: "Post", message: "Set the post as your favourite one", preferredStyle: UIAlertController.Style.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            self.viewModel.selectFavourite(at: indexPath)
        }))
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
        }))
        
        present(refreshAlert, animated: true, completion: nil)
        
    }
}

