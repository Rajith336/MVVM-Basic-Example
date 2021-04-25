

import UIKit


class FavouriteViewModel {
    public var listFetchClosure: (() -> ())?
    private var favList:[PostData] = []{
        didSet{
            self.listFetchClosure?()
        }
    }
    
    
    //MARK:- TableViewDataSource
    func numberOfRowsInSection(at section: Int) -> Int{
        return favList.count
    }
    
    func cellForRowAtIndexPath(at indexPath: IndexPath) -> PostData{
        return favList[indexPath.row]
    }
    
    func fetchFavourite(){
        if let modData = UserDefaults.standard.object(forKey: "postList") as? Data {
            let decoder = JSONDecoder()
            if let model = try? decoder.decode(Post.self, from: modData) {
                print(model)
                self.favList = model.filter({($0.isFavourite ?? false)})
            }}
    }
}
