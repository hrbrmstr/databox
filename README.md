
`databox` : Tools to work with the ['databox' 'API'](https://databox.com/)

The following functions are implemented:

-   `add_metric`: Add a metric to send to databox
-   `client`: Initialize a databox client and return a databox client object (dco)
-   `databox_api_key`: Get or set `DATABOX_API_KEY` value
-   `last_push`: Retrieve the metrics posted in the past push
-   `push`: Push metrics to databox

The following data sets are included:

### Installation

``` r
devtools::install_github("hrbrmstr/databox")
```

### Usage

``` r
library(databox)
library(dplyr)

# current verison
packageVersion("databox")
```

    ## [1] '0.1.0'

We can send one or more metrics to databox. They can be combined in a pipe as well. Once they're "pushed" they are cleared from the client object:

``` r
databox::client() %>% 
  add_metric("sales", 83000, Sys.Date()) %>% 
  add_metric("sales", 4000, unit="USD") %>% 
  add_metric("expenses", 87500) %>% 
  add_metric("sales", 123000, mattrs=c("channel"="in-person", "cheese"="manchego")) %>% 
  push()
```

    ## databox object with 0 metrics

There's a `print()` method for `dco` objects as well:

``` r
databox::client() %>% 
  add_metric("sales", 83000, Sys.Date()) %>% 
  add_metric("sales", 4000, unit="USD") %>% 
  add_metric("expenses", 87500) %>% 
  add_metric("sales", 123000, mattrs=c("channel"="in-person", "cheese"="manchego")) %>% 
  print()
```

    ## databox object with 4 metrics

Also can validate the last push:

``` r
glimpse(last_push())
```

    ## Observations: 1
    ## Variables: 6
    ## $ metrics           <list> <"20725|sales", "20725|expenses", "20725|sales|channel", "20725|sales|cheese">
    ## $ request.date      <chr> "2016-08-01T16:57:09.509Z"
    ## $ request.errors    <list> []
    ## $ request.body.data <list> <c("83000", "4000", "NA", "123000"), c("2016-08-01 00:00:00", "NA", "NA", "NA"), c("NA",...
    ## $ response.date     <chr> "2016-08-01T16:57:09.512Z"
    ## $ response.body.id  <chr> "147000960073e7899ede594207ab70"

### Test Results

``` r
library(databox)
library(testthat)

date()
```

    ## [1] "Mon Aug  1 12:56:14 2016"

``` r
test_dir("tests/")
```

    ## testthat results ========================================================================================================
    ## OK: 0 SKIPPED: 0 FAILED: 0
    ## 
    ## DONE ===================================================================================================================
