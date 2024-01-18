# PDCollectionInfiteView
PDCollectionInfiteView is use for infinite scroll collection view.

import PDCollectionInfiteView in your file

        import PDCollectionInfiteView

create outlate for collectionview

        @IBOutlet weak var collectioView : MyCollectionView!

        override func viewDidLoad() {

        super.viewDidLoad()
        collectioView.myDelegate = self
        collectioView.myDataSource = self
        DispatchQueue.main.async {
            self.collectioView.startInfiteScrollToItem()
        }
      }
import DataSource in ViewController 

    extension ViewController : MyCollectionViewDataSource {

      func collectionView(_ collectionView: MyCollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
      }
      func collectionView(_ collectionView: MyCollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
          let cell = UICollectionViewCell()
          return cell
      }
    }

import Delegate in ViewController 

     extension ViewController: MyCollectionViewDelegate {

        func collectionView(_ collectionView: MyCollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
          return self.collectioView.bounds.size
        }
        func collectionView(_ collectionView: MyCollectionView, didSelectItemAt indexPath: IndexPath) {
          print(indexPath)
        }
    
     }





