

import UIKit
import RxSwift
import Moya

class PostViewModel {
    let provider = MoyaProvider<Service>()
    let disposeBag = DisposeBag()
    public var postSuccessClosure: (() -> ())?
    public var postFaliureClosure:(() -> ())?
    
    
    private var postList:[PostData] = []{
        didSet{
            self.postSuccessClosure?()
        }
    }
    
    public var errorMessage: String?{
        didSet{
            self.postFaliureClosure?()
        }
    }
    
    //MARK:- TableViewDataSource
    func numberOfRowsInSection(at section: Int) -> Int{
        return postList.count
    }
    
    func cellForRowAtIndexPath(at indexPath: IndexPath) -> PostData{
        return postList[indexPath.row]
    }

    func fetchPostAPi(){
        if Reachability.isConnectedToNetwork() {
            provider.request(.postList) {
                result in
                
                do {
                    let response = try result.get()
                    self.processingJson(response)
                } catch {
                    self.errorMessage = "\(error as CustomStringConvertible)"
                    if let modData = UserDefaults.standard.object(forKey: "postList") as? Data {
                        let decoder = JSONDecoder()
                        if let model = try? decoder.decode(Post.self, from: modData) {
                            print(model)
                            self.postList = model
                            
                        }}
                    }
                
                }
        } else{
            self.errorMessage = "\("There is no network")"
            if let modData = UserDefaults.standard.object(forKey: "postList") as? Data {
                let decoder = JSONDecoder()
                if let model = try? decoder.decode(Post.self, from: modData) {
                    print(model)
                    self.postList = model
                    
                }}
        }
        
    }
    
    func selectFavourite(at indexPath: IndexPath){
        postList[indexPath.row].isFavourite = true
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(postList) {
            let defaults = UserDefaults.standard
            defaults.set(encoded, forKey: "postList")
            
            if let modData = UserDefaults.standard.object(forKey: "postList") as? Data {
                let decoder = JSONDecoder()
                if let model = try? decoder.decode(Post.self, from: modData) {
                    print(model)
                    
                }}
        }
        
    }
    
    fileprivate func processingJson(_ response: (PrimitiveSequence<SingleTrait, Response>.Element)) {
        let jsonDecoder = JSONDecoder()
        if let responseModel = try? jsonDecoder.decode(Post.self, from: response.data) {
            
            if let modData = UserDefaults.standard.object(forKey: "postList") as? Data {
                let decoder = JSONDecoder()
                if var model = try? decoder.decode(Post.self, from: modData) {
                    model = model.filter({$0.isFavourite ?? false})
                    print(model)
                    
                    for mod in model {
                        if let indexMod = responseModel.firstIndex(where: {$0.id == mod.id && $0.userID == mod.userID}) {
                            responseModel[indexMod].isFavourite = true
                        }
                    }
                }}
            
            self.postList = responseModel
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(responseModel) {
                let defaults = UserDefaults.standard
                defaults.set(encoded, forKey: "postList")
            }
        } else{
            self.errorMessage = "\("Issue in Api")"
        }
    }
    
}
