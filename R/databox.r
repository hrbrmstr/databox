#' Initialize a databox client and return a databox client object (dco)
#'
#' @param api_key databox API key (automatically populated if in the environment)
#' @return databaox client object
#' @export
#' @examples \dontrun{
#' databox::client() %>%
#'   add_metric("sales", 83000, Sys.Date()) %>%
#'   add_metric("sales", 4000, unit="USD") %>%
#'   add_metric("expenses", 87500) %>%
#'   add_metric("sales", 123000,
#'              mattrs=c("channel"="in-person",
#'                       "cheese"="manchego")) %>%
#'   push()
#' }
client <- function(api_key=databox_api_key()) {

  ret <- list(
    api_key=api_key,
    data=list()
  )

  class(ret) <- c("dco", class(ret))

  ret

}

#' Add a metric to send to databox
#'
#' @param dco databaox client object created by \code{client()} or piped/passed
#'     from other \code{add_metric()} calls
#' @param key name of metric (without leading \code{$})
#' @param value value of metric (must be numeric)
#' @param date (optional) \code{Date} or \code{POSIXct} object which will be
#'     converted to the proper databox API format. NOTE: this auto-converts to UTC for the API
#' @param unit (optional) units description for the metric (e.g. \code{USD})
#' @param mattrs (optiona) named vector of attribute key/value pairs to add to the metric
#' @return \code{dco} updated with metrics values
#' @references \url{https://developers.databox.com/api/}
#' @export
#' @examples \dontrun{
#' databox::client() %>%
#'   add_metric("sales", 83000, Sys.Date()) %>%
#'   add_metric("sales", 4000, unit="USD") %>%
#'   add_metric("expenses", 87500) %>%
#'   add_metric("sales", 123000, mattrs=c("channel"="in-person", "cheese"="manchego")) %>%
#'   push()
#' }
add_metric <- function(dco, key, value, date=NULL, unit=NULL, mattrs=NULL) {

  tmp <- setNames(list(unbox(value)), sprintf("$%s", key))

  if (!is.null(date)) tmp$date <- unbox(format(date, "%Y-%m-%d %H:%M:%S", tz="UTC"))
  if (!is.null(unit)) tmp$unit <- unbox(unit)
  if (!is.null(mattrs)) tmp <- c(tmp, map(as.list(mattrs), unbox))

  dco$data[[length(dco$data)+1]] <- tmp

  dco

}

#' Push metrics to databox
#'
#' @param dco databaox client object created by \code{client()} or piped/passed
#'     from other \code{add_metric()} calls
#' @return \code{dco} with an empty \code{data} slot (i.e. you can use this for more
#'     pipes/calls without fear of duplicating values)
#' @references \url{https://developers.databox.com/api/}
#' @export
#' @examples \dontrun{
#' databox::client() %>%
#'   add_metric("sales", 83000, Sys.Date()) %>%
#'   add_metric("sales", 4000, unit="USD") %>%
#'   add_metric("expenses", 87500) %>%
#'   add_metric("sales", 123000,
#'              mattrs=c("channel"="in-person",
#'                       "cheese"="manchego")) %>%
#'   push()
#' }
push <- function(dco) {

  res <- POST("https://push.databox.com",
              authenticate(dco$api_key, ""),
              accept("application/vnd.databox.v2+json"),
              content_type_json(),
              body=list(data=dco$data),
              encode="json")

  stop_for_status(res)

  dco$data <- list()

  dco

}

#' Retrieve the metrics posted in the past push
#'
#' @param api_key databox API key (automatically populated if in the environment)
#' @references \url{https://developers.databox.com/api/}
#' @export
#' @examples \dontrun{
#' databox::last_push()
#' }
last_push <- function(api_key=databox_api_key()) {

  res <- GET("https://push.databox.com/lastpushes",
             authenticate(api_key, ""),
             accept("application/vnd.databox.v2+json"),
             content_type_json())

  fromJSON(content(res, as="text"), flatten=TRUE)

}

#' @export
print.dco <- function(x, ...) {
  cat(sprintf("databox object with %d metrics\n", length(x$data)))
}