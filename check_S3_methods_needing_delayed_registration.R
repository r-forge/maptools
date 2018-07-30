.get_S3_generics_in_env <-
function(env) {
    nms <- sort(names(env))
    if(".no_S3_generics" %in% nms)
        character()
    else
        Filter(function(f) .is_S3_generic(f, envir = env), nms)
}

.get_S3_generics_in_ns_exports <-
function(ns)
{
    env <- asNamespace(ns)
    nms <- sort(intersect(names(env), getNamespaceExports(env)))
    if(".no_S3_generics" %in% nms)
        character()
    else
        Filter(function(f) .is_S3_generic(f, envir = env), nms)
}

check_S3_methods_needing_delayed_registration <-
function(package, lib.loc = NULL) {

    mat <- matrix(character(), 0L, 3L,
                  dimnames = list(NULL,
                                  c("Package", "Generic", "Method")))
    out <- list(mat = mat, bad = character())
    class(out) <- "S3_methods_needing_delayed_registration"
        
    if(length(package) != 1L)
        stop("argument 'package' must be of length 1")
    dir <- find.package(package, lib.loc)
    if(!dir.exists(file.path(dir, "R"))) return
    db <- .read_description(file.path(dir, "DESCRIPTION"))
    suggests <- unname(.get_requires_from_package_db(db, "Suggests"))
    
    if(!length(suggests)) return

    if(basename(package) != "base")
        .load_package_quietly(package, dirname(dir))
    ok <- vapply(suggests, requireNamespace, quietly = TRUE,
                 FUN.VALUE = NA)
    out$bad <- suggests[!ok]
   
    suggests <- suggests[ok]
    generics <- lapply(suggests, .get_S3_generics_in_ns_exports)

    packages <- rep.int(suggests, lengths(generics))
    generics <- unlist(generics, use.names = FALSE)

    code_env <- .package_env(package)
    objects_in_code <- sort(names(code_env))
    functions_in_code <-
        Filter(function(f) is.function(code_env[[f]]),
               objects_in_code)
    methods_stop_list <- nonS3methods(basename(dir))
    methods <- lapply(generics,
                      function(g) {
                          i <- startsWith(functions_in_code,
                                          paste0(g, "."))
                          setdiff(functions_in_code[i],
                                  methods_stop_list)
                      })
    len <- lengths(methods)
    ind <- (len > 0L)

    if(!any(ind)) return(out)

    len <- len[ind]

    out$mat <-
        cbind(Package = rep.int(packages[ind], len),
              Generic = rep.int(generics[ind], len),
              Method = unlist(methods[ind], use.names = FALSE))
    
    out
}

format.S3_methods_needing_delayed_registration <- 
function(x, ...)
{
    c(character(),
      if(length(bad <- x$bad)) {
          c("Suggested packages not available for checking:",
            strwrap(paste(bad, collapse = " "), indent = 2L))
      },
      if(length(mat <- x$mat)) {
          c("Apparent S3 methods needing delayed registration:",
            sprintf("  %s %s %s",
                    format(c("Package", mat[, 1L])),
                    format(c("Generic", mat[, 2L])),
                    format(c("Method", mat[, 3L])))
            )
      })
}

print.S3_methods_needing_delayed_registration <-
function(x, ...)
    writeLines(format(x))

if(FALSE) {
    attach(asNamespace("tools"))
    check_S3_methods_needing_delayed_registration("maptools")
}

    
    
    
