## Target iOS Case Study

### Solution
#### Architecture
This implementation is based around MVVM. Closures are used to bind model changes to the presentaiton in the views.

#### UI
The Deals list is presented as a collection view using compositional layout to present items as a single section list.

The Product Detail page is a multi-section collection view, with styling separated out for each section. The detail view is extensible and allows for easy addition of new sections of content (e.g., a horizontal scrolling recommended products section). A basic section configuration object has been created to help facilitate the separation of section styling.

Both the list and detail views have three distinc states: loading content, displaying content, or displaying an error. Because multiple conditions must be met for each of these states to present correctly, they are managed by a `ViewState` enumeration to prevent the UI from showing inconsistent and/or mixed states.

#### Networking
All networking is performed via Swift async/await and thrown errors. The networking stack is broken up into two portions. The first is service that does the fetch and either returns a `Data` object for successful requests, or throws an error if the request cannot be completed. The second layer is a service which wraps this calls and is responsible for parsing the `Data` response and throwing any errors related to decoding.

In this solution, a DealsService wrapper has been written to wrap the two endpoints used for fetching data for the deals list and the product details. This service is also responsible for throwing a specific error when a product detail item is not found.

Ideally, a wrapper service would be created for each new set of related endpoints. New networking capabilities (e.g., file upload/download) would go into the Networking service.

#### Reusability
Shared views have been split out into their own UIView subclasses (e.g., LoadingView, ErrorView, etc). The Add to cart button is also contained within its own UIView subclass for use elsewhere within the app as it grows.

There is some overlap in the functionality of the list and detail view controllers, however, with only two instances it did not warrant combining these into a shared view controller. Future requirements would dictate the type of reuse we would gain from combining the controllers.

#### Testability
Unit tests have been written for the networking stack and the view models. Protocols were used to allow for easy mocking and dependency injection.

#### Third party libraries
This solution makes use of only one piece of open source code, KingFisher. This decision was made to allow for easy asynchronous image fetch for the list items and because the package supports caching of retrieved images out of the box with minimal setup needed. MIT license.

Swift Package Manager was used to manage this dependency.

#### Support for different screen sizes
The UI is completely arranged using AutoLayout for all container views. For the most part, it behaves as expected on multiple screen sizes with two exceptions:
1. The product thumbnail images on the list use two hardcoded values: one for modern phone screens (375pt or higher) and one for smaller screens. This allows the image to shrink enough to allow full content display within the list without truncating any content.
2. The Add to Cart view honors the safe area. On phones with a home indicator, the height of the view is changed so the button may sit above the home indicator. On phones with a home button, the view is positioned at the bottom of the screen. The view height is dynamically controlled by the use of safeAreaInsets.

---

### Description
You have been given control over an iOS project that was originally a proof-of-concept project. The original developer of the project has since moved on to a new team,
and Target has asked you to turn the project into an application that the company could release to the public.

The goal of the app is to display a list of deals currently offered by Target, and to provide information on those deals.
As a POC, the app has a few deals hardcoded in and the code is pretty rough. It is your job to turn this app into something useful!

#### Requirements
1. Fix up the list to match the item listing page design shown in the [mockups](https://www.figma.com/file/bJmbkTubmeeQCpD9c0RgjZ/iOS-Technical-Screener). Do your best to match the fonts, colors, and margins from the mockups. We don't expect your implementation to be pixel-perfect.
2. Present the item detail page when an item is tapped on the list screen. Again, match the design shown in the [mockups](https://www.figma.com/file/bJmbkTubmeeQCpD9c0RgjZ/iOS-Technical-Screener) as best you can.
3. The deals are currently hardcoded. Use the API at [https://api.target.com/mobile_case_study_deals/v1](https://api.target.com/mobile_case_study_deals/v1) to grab the real deals to display in the app. Your solution should make use of both of the API endpoints:
      * Product List Endpoint: 
        [https://api.target.com/mobile_case_study_deals/v1/deals](https://api.target.com/mobile_case_study_deals/v1/deals)
        
      * Product Details Endpoint:
        `https://api.target.com/mobile_case_study_deals/v1/deals/{productId}`
        
        [Test Product Details for Product 1](https://api.target.com/mobile_case_study_deals/v1/deals/1)

_Note: Please use UIKit at least for the deals list. While engineers are building SwiftUI experiences in the Target app today (and empowered to do so), UIKit will remain a part of the iOS landscape for some time._

#### Guidelines
- Feel free to use any open source software you wish. Be prepared to answer questions about why you chose any libraries that you add to the project.
- Treat this app as something you control technically. The way you chose to architect your solution will be a key aspect of the case study review.
- This project was only tested minimally during development.  There may be bugs in the current implementation.
- Do your best to follow modern iOS conventions.
- Imagine that this app will continue to grow after you are done. Consider and be ready to discuss how the following engineering values fit into your chosen solution:
	- Clean, well organized code
	- Modern UI patterns
	- Networking design
	- Error handling
	- Testability
	- Reusability
	- Support for different screen sizes
