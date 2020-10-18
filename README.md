# Pixabay-Image-Search
 
 * TO BUILD THE APPLICATION: 
  1. Xcode Version: Xcode 12
  2. Swift Version:  Swift 5.3
  3. Deployment Target: iOS 14

* NOTE: 
1. Tested only on iOS 14 Simulators (iPhone/iPad)
2. Locked orientation to Portrait on iPhone and Landscape on iPad
 
 * Please find below details on Implementation:
 
1. Implemented the below functionality
    - Search images using keywords
    - Added Pagination Support
    - Handled empty response with displaying an alert
    - Display recent searches list when SearchTextField is focused (i.e. max recents count 10)
    - Handled Recent search selection action
    - Handled Image selection action with displaying full image view on Details Screen
    - Handled swipe left/right gesture on details screen to display previous/next image
    
2. Used MVVM Architecture with Reactive Bindings
    - Integrated Reactive Cocoa and Reactive Swift with the help of CocoaPods Dependancy Manager
    - Along with MVVM components, added one more component DAO for fetching data. 
        1. This ensures ViewModel doesn't become massive.
        2. It helps with Single Responsibility principle.
        3. In future, if we want to fetch data from Local DB or Mock Data for Unit test we can leverage this component
        
3. Used NSCache to store fetched images
    - Used Property dependency injection method for Supporting different data storages in future
    
4. Added provision for handling different API response type in Network Manager
    - We have used dependancy inversion principle and Open-Closed Principle
    
5. Added delegate handlers for each UI Component 
    - With the help of creating different delegate handlers, code is loosely coupled, maintainable and readable
    
6. Created a collection CustomArray which uses Generics
    - It saves data in reverse order 
    - It supports MAX size limit, after which removes oldest item
    - It checks for Duplicates and removes from the array and brings to Top
    
7. Added support for canceling request with the help of URLSessionTask

8. Marked all the classes as Final to improve runtime performance by avoiding Dynamic Dispatch

9. Grouped all files for ease of access such as Enums, Protocols and Structs.


* Design Patterns followed in Project:
1. Observer using Reactive bindings
2. Delegation for CollectionView, TableView and SearchBarView Delegates
3. Facade for Network Manager to hide the Api request implementation details
4. Singleton for Image Storage Manager
    

        
    
