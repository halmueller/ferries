# ferries

Demonstration app to track Washington State Ferries, using a REST API and a JSON data feed, 
Core Data backing store, and MapKit. Also demonstrates AVFoundation speech generation for 
debugging, and ReplayKit for simple user video capture.

Of note:

Ferry positions are provided via web service by Washington State Ferries. The API is documented at
* http://www.wsdot.wa.gov/ferries/api/terminals/documentation/rest.html
* http://www.wsdot.wa.gov/ferries/api/vessels/documentation/rest.html
* http://www.wsdot.wa.gov/ferries/api/schedule/documentation/rest.html

A free access key is required; register for it at http://www.wsdot.wa.gov/traffic/api/.

AVSpeechUtterance is used from FerriesCoreDataStack to announce background network updates.

ReplayKit capture is triggered from the Debug view controller.

Slides: https://github.com/halmueller/ferriesAbusing%20Game%20Technologies%20for%20Testing%20and%20Debugging.pdf




