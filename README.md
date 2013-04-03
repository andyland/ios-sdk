__Under Development!__

This SDK aims to help php developers get easier access to the [TuneWiki API](http://dev.tunewiki.com)

Supports iOS 5+

##Getting Started
Copy all the files under src into your project

Example usage:

    //Set your api key and secret
    TWAPI *api = [TWAPI sharedApi];
    api.apiKey = @"YOUR_API_KEY";
    api.apiSecret = @"YOU_API_SECRET";

    //Get some lyrics
    [api getLyricsForArtist:@"Of Montreal"
                      title:@"An Eluardian Instance"
                   delegate:self];
                                 
Your delegate should implmement the following methods:

    - (void) receivedResponse:(id)response context:(TWAPIContext*)context;
    - (void) failedWithContext:(TWAPIContext*)context error:(NSError*)error;
    
A successful request will receive an instance of `TWAPILyrics` back.


**TODO**

1. OAuth Signed Requests
1. POST actions for editing / syncing lyrics

## License

Released under the [MIT License](http://www.opensource.org/licenses/MIT)