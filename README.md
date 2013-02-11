soccer-scores
=============

A very basic proof-of-concept API wrapper for soccer scores and stats data scraped from a sports scores site.

The API provides the following interfaces:

    # All scores for the current day
    /api/scores
    
    # All scored for the specificed date (in yyyymmdd format)
    /api/scores/:date
    
    # All match statistical information for the specified matchId (provided from either scores list)
    /api/match/:match_id

The API is demo-ed at: http://polar-sands-8448.herokuapp.com/

There is also a rough-and-dirty SPA that utilizes the API at: http://polar-sands-8448.herokuapp.com/index.html

