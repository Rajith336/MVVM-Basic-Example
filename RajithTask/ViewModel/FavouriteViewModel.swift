

import UIKit
import RxSwift
import RxCocoa


class FavouriteViewModel {
    private var favList = BehaviorRelay<[PostData]>(value: [])
    
    func isSuccess() -> Observable<Bool>{
        return favList.asObservable().map {  list in
            return list.count > 0
            
        }
    }
    
    //MARK:- TableViewDataSource
    func numberOfRowsInSection(at section: Int) -> Int{
        return favList.value.count
    }
    
    func cellForRowAtIndexPath(at indexPath: IndexPath) -> PostData{
        return favList.value[indexPath.row]
    }
    
    func fetchFavourite(){
        if let modData = UserDefaults.standard.object(forKey: "postList") as? Data {
            let decoder = JSONDecoder()
            if let model = try? decoder.decode(Post.self, from: modData) {
                //print(model)
                self.favList.accept(model.filter({($0.isFavourite ?? false)})) 
            }}
    }
}
