# RAIL API USING GOOGLE PLACES

Rails API making use of Google places API to search for locations

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for testing & production purposes.

### Prerequisites

The following are required to run the api

```
Ruby
Rails Version 5.1.6

```

### Installing

A step by step to get the application Up and running

Install Gems

```

$ bundle install

```
* Log in to Google console to generate a key for Google Place API
* Add the variable below to the *config/application.yml' file
* To deploy the api in production, use the command:

```
export GOOGLE_API_KEY=xxxxxxxxxxxxxxxx
```

```

GOOGLE_API_KEY = 'API KEY FROM GOOGLE CONSOLE'

```

### Run App

Navigate into the project Directory

```
$ rails server
```

### API URL
```
> http://localhost:3000/v1/places/
```


### Sample Parameters to Pass

Make a post request to the API using the parameters described below:

```
longitude=151.1957362 latitude=-33.8670522 provider="Google"

or

query="Supermarkets in Gbagada Lagos" provider="Google"

```

To use Google as the default provider, do not pass the provider parameter

## Built With

* [Rails] - Programming Language
* [Google Place API]


## Assumption
* Google place API doesn't return ```description``` as part of the response. Made use of attribue :"types", joined all the words in the returned array to form the description.


## Authors

* **Osegbemoh Dania ** 
