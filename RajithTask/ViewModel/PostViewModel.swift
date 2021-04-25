

import UIKit
import RxSwift
import RxCocoa




class PostViewModel {
    
    
    private var postList = BehaviorRelay<[PostData]>(value: [])
    public var errorMessage = BehaviorRelay<String>(value: "")
    
    
    ///Rx Swift
    func isSuccess() -> Observable<Bool>{
        return postList.asObservable().map {  list in
            return list.count > 0
            
        }
    }
    
    func isFaliure() -> Observable<String>{
        return errorMessage.asObservable().map {  error in
            return error
            
        }
    }
    //MARK:- TableViewDataSource
    func numberOfRowsInSection(at section: Int) -> Int{
        return  postList.value.count
    }
    
    func cellForRowAtIndexPath(at indexPath: IndexPath) -> PostData{
        return  postList.value[indexPath.row]
    }
    
    
    func fetchPostAPi(){
        if Reachability.isConnectedToNetwork() {
            ActivityIndicatorView(title: "Loading").startAnimating()
            var request = URLRequest(url: URL(string: "https://jsonplaceholder.typicode.com/posts")!)
            
            let session = URLSession.shared
            let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
                //print(response)
                DispatchQueue.main.async {
                    ActivityIndicatorView(title: "Loading").stopAnimating()
                }
                
                if error == nil {
                    self.processingJson(response: data ?? Data())
                } else {
                    self.errorMessage.accept("\(String(describing: error))")
                    if let modData = UserDefaults.standard.object(forKey: "postList") as? Data {
                        let decoder = JSONDecoder()
                        if let model = try? decoder.decode(Post.self, from: modData) {
                            //print(model)
                            self.postList.accept(model)
                            
                        }}
                }
                
            })
            
            task.resume()
        } else{
            self.errorMessage.accept("\("There is no network")")
            if let modData = UserDefaults.standard.object(forKey: "postList") as? Data {
                let decoder = JSONDecoder()
                if let model = try? decoder.decode(Post.self, from: modData) {
                    //print(model)
                    self.postList.accept(model)
                    
                }}
        }
    }
    
    
    func selectFavourite(at indexPath: IndexPath){
        postList.value[indexPath.row].isFavourite = true
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(postList.value) {
            let defaults = UserDefaults.standard
            defaults.set(encoded, forKey: "postList")
            
            if let modData = UserDefaults.standard.object(forKey: "postList") as? Data {
                let decoder = JSONDecoder()
                if let model = try? decoder.decode(Post.self, from: modData) {
                    //print(model)
                    
                }}
        }
        
    }
    
    fileprivate func processingJson(response:Data) {
        let jsonDecoder = JSONDecoder()
        if let responseModel = try? jsonDecoder.decode(Post.self, from: response) {
            
            if let modData = UserDefaults.standard.object(forKey: "postList") as? Data {
                let decoder = JSONDecoder()
                if var model = try? decoder.decode(Post.self, from: modData) {
                    model = model.filter({$0.isFavourite ?? false})
                    //print(model)
                    
                    for mod in model {
                        if let indexMod = responseModel.firstIndex(where: {$0.id == mod.id && $0.userID == mod.userID}) {
                            responseModel[indexMod].isFavourite = true
                        }
                    }
                }}
            
            self.postList.accept(responseModel)
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(responseModel) {
                let defaults = UserDefaults.standard
                defaults.set(encoded, forKey: "postList")
            }
        } else{
            self.errorMessage.accept("\("Issue in Api")")
        }
    }
    
}
