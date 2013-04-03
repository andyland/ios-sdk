__Under Development!__

This SDK aims to help php developers get easier access to the [TuneWiki API](http://dev.tunewiki.com)

Supports iOS 5+

##Getting Started
Copy all the files under src into your project and define your API key and secret in TWAPI.h

Example usage:

    // Create a request
    TWAPIRequest *request = [TWAPIGetLyricsRequestgetLyricsRequestForArtist:@"Of Montreal"
                                                                      title:@"An Eluardian Instance"
                                                                   language:@"en-US"
                                                                   delegate:self];
    // Start it
    [request start];
    
    // If you need to cancel it
    [request cancel];
                                 
Your delegate should implmement the following methods:

    - (void) receivedResponse:(id)response;
    - (void) failedWithError:(NSError*)error;
    
A successful request will receive an instance of `TWAPILyrics` back.


**TODO**

1. OAuth Signed Requests
1. POST actions for editing / syncing lyrics

## License

Released under the [MIT License](http://www.opensource.org/licenses/MIT)