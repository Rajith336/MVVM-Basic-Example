

import UIKit

class FavouriteVC: UIViewController {
    // MARK: - Initialization
    @IBOutlet weak var tblFav: UITableView!
    lazy var viewModel : FavouriteViewModel = {
        return FavouriteViewModel()
    }()
    
    // MARK: - ViewLifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        initViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.fetchFavourite()
    }
    
    // MARK: - Local Method
    func initUI(){
        tblFav.tableFooterView = UIView()
        tblFav.layoutMargins = UIEdgeInsets.zero
        tblFav.separatorInset = UIEdgeInsets.zero
        
    }
    
    func initViewModel(){
        viewModel.listFetchClosure = { [weak self]() in
            DispatchQueue.main.async {
                self?.tblFav.reloadData()
            }
        }
        
    }
    
}

extension FavouriteVC:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if viewModel.numberOfRowsInSection(at: section) > 0{
            self.tblFav.backgroundView = nil
            self.tblFav.separatorStyle = .singleLine
            return  viewModel.numberOfRowsInSection(at: section)
        } else{
            
            let rect = CGRect(x: 0,y: 0,width: self.tblFav.bounds.size.width,height: self.tblFav.bounds.size.height)
            let noDataLabel: UILabel = UILabel(frame: rect)
            
            noDataLabel.text = "There is no data"
            noDataLabel.textColor = UIColor.darkText
            noDataLabel.textAlignment = NSTextAlignment.center
            self.tblFav.backgroundView = noDataLabel
            self.tblFav.separatorStyle = .none
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FavCell", for: indexPath) as? PostCell else { return UITableViewCell() }
        let model = viewModel.cellForRowAtIndexPath(at: indexPath)
        cell.lblBody.text = model.body ?? ""
        cell.lblTitle.text = model.title ?? ""
        cell.layoutMargins = UIEdgeInsets.zero
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        return cell
    }
}
