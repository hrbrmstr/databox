#' @importFrom magrittr %>%
#' @export
magrittr::`%>%`


#' Get or set DATABOX_API_KEY value
#'
#' The API wrapper functions in this package all rely on a databox API
#' key residing in the environment variable \code{DATABOX_API_KEY}. The
#' easiest way to accomplish this is to set it in the `.Renviron` file in your
#' home directory.
#'
#' @param force Force setting a new dataobx API key for the current environment?
#' @return atomic character vector containing the databox API key
#' @references \url{https://developers.databox.com/api/#get-your-token}
#' @export
databox_api_key <- function(force = FALSE) {

  env <- Sys.getenv('DATABOX_API_KEY')
  if (!identical(env, "") && !force) return(env)

  if (!interactive()) {
    stop("Please set env var DATABOX_API_KEY to your databox API key", call. = FALSE)
  }

  message("Couldn't find env var DATABOX_API_KEY See ?databox_api_key for more details.")
  message("Please enter your databox API key and press enter:")
  pat <- readline(": ")

  if (identical(pat, "")) {
    stop("databox API key entry failed", call. = FALSE)
  }

  message("Updating DATABOX_API_KEY env var to PAT")
  Sys.setenv(DATABOX_API_KEY = pat)

  pat

}
