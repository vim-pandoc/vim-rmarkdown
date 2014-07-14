#!/usr/bin/env Rscript

args <- commandArgs(trailingOnly = TRUE)
rmarkdown_invocation <- paste(c(args[4:5], paste(c("'", args[6], "'"), collapse=""), '2>&1'), collapse=" ")
output <- system(rmarkdown_invocation, intern=TRUE)
# have we failed?
if (!is.null(attr(output, "status")))
{
    writeLines(output, 'rmarkdown.out')
}

servername <- args[2]
if (args[3] == "--open")
{
    should_open <- '1'
} else if (args[3] == "--noopen") 
{
    should_open <- '0'
}
func_call <- paste(c("'rmarkdown#command#Callback(", should_open, ")'"), collapse="")
vim_invocation <- paste(c("vim", "--servername", servername, "--remote-expr", func_call), collapse=" ")
system(vim_invocation)
