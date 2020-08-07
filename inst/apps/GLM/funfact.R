#' Deviation-Coded Contrast Matrices
#'
#' Return a matrix of deviation-coded contrasts.
#'
#' @param n a vector of levels for a factor, or the number of levels.
#' @param base an integer specifying which group is considered the
#' baseline group. Ignored if 'contrasts' is \code{FALSE}.
#' @param contrasts a logical indicating whether contrasts should be computed.
#'
#' @export 
contr.dev <- function(n, base = 1, contrasts = TRUE) {
  if (length(n) <= 1L) {
    if (is.numeric(n) && (length(n) == 1L) && (n > 1L))
      levels <- seq_len(n)
    else stop("not enough degrees of freedom to define contrasts")
  } else {
    levels <- n
  }
                                        #mx <- apply(contr.treatment(n), 2, function(x) {x-mean(x)})
  ctreat <- contr.treatment(levels, base, contrasts)
  mx <- apply(ctreat, 2, scale, scale = FALSE)
  dimnames(mx) <- dimnames(ctreat)
  mx    
}

#' Calculate marginal and cell counts for factorially-designed data
#'
#' @param iv_names Names of independent variables in data.frame given by \code{dat}.
#' @param dat A data frame
#' @param unit_names Names of the fields containing sampling units (subjects, items)
#' @return a list, the elements of which have the marginal/cell counts for each factor in the design
#' @export
fac_counts <- function(iv_names, dat, unit_names = c("subj_id", "item_id")) {    
  fac_info <- attr(terms(as.formula(paste0("~", paste(iv_names, collapse = "*")))), "factors")
  rfx <- sapply(unit_names, function(this_unit) {
    ## figure out how many things are replicated by unit, how many times
    rep_mx <- xtabs(paste0("~", paste(iv_names, collapse = "+"), "+", this_unit), dat)
    lvec <- lapply(colnames(fac_info), function(cx) {
      x <- fac_info[, cx, drop = FALSE]
      ix <- seq_along(x)[as.logical(x)]
      ## create margin table
      marg_mx <- apply(rep_mx, c(ix, length(dim(rep_mx))), sum)
      mmx <- apply(marg_mx, length(dim(marg_mx)), c)
    })
    names(lvec) <- colnames(fac_info)
    return(lvec)
    ## lvec <- apply(fac_info, 2, function(x) {
    ##     ix <- seq_along(x)[as.logical(x)]
    ##     ## create margin table
    ##     marg_mx <- apply(rep_mx, c(ix, length(dim(rep_mx))), sum)
    ##     mmx <- apply(marg_mx, length(dim(marg_mx)), c)
    ## })
  }, simplify = FALSE)
  return(rfx)
}

#' Generate numerical deviation-coded predictors
#'
#' Add deviation-coded predictors to data frame.
#'
#' @param dat A data frame with columns containing factors to be converted.
#' @param iv_names Names of the variables to be converted.
#'
#' @return A data frame including additional deviation coded predictors.
#'
#' @examples
#' with_dev_pred(stim_lists(list(ivs = c(A = 3))), "A")
#' @export
with_dev_pred <- function(dat, iv_names = NULL) {
  if (is.null(iv_names)) {
    iv_names <- names(dat)
  } else {}
  mform <- as.formula(paste0("~", paste(iv_names, collapse = "+")))
  cont <- as.list(rep("contr.dev", length(iv_names)))
  names(cont) <- iv_names
  cbind(dat, model.matrix(mform, dat, contrasts.arg = cont)[, -1])
}

check_design_args <- function(design_args) {
  ## TODO check integrity of design args
  required_elements <- c("ivs")
  missing_elements <- setdiff(required_elements, names(design_args))
  if (length(missing_elements) > 0) {
    stop("'design_args' missing element(s): ",
         paste(missing_elements, collapse = ", "))
  } else {}
  return(TRUE)
}

#' Get names for predictors in factorial design
#'
#' Get the names for the numerical predictors corresponding to all
#' main effects and interactions of categorical IVs in a factorial
#' design.
#'
#' @param design_args A list with experimental design information (see \code{link{stim_lists}})
#' @param design_formula A formula (default NULL, constructs from \code{design_args})
#' @param contr_type Name of formula for generating contrasts (default "contr.dev")
#' @return A character vector with names of all the terms
#' @export 
term_names <- function(design_args,
                       design_formula = NULL,
                       contr_type = "contr.dev") {
  check_design_args(design_args)
  plists <- stim_lists(design_args)
  cont <- as.list(rep(contr_type, length(design_args[["ivs"]])))
  names(cont) <- names(design_args[["ivs"]])
  if (is.null(design_formula)) design_formula <- as.formula(paste0("~",
                                                                   paste(names(design_args[["ivs"]]),
                                                                         collapse = " * ")))
  suppressWarnings(mmx <- model.matrix(design_formula, plists, contrasts.arg = cont))
  return(colnames(mmx))
}

#' Get the GLM formula for a factorially-designed experiment
#'
#' Get the formula corresponding to the general linear model for a
#' factorially designed experiment, with maximal random effects.
#' 
#' @param design_args A list with experimental design information (see \code{link{stim_lists}})
#' @param n_subj Number of subjects
#' @param dv_name Name of dependent variable; \code{NULL} (default) for one-sided formula
#' @param lme4_format Do you want the results combined as the model formula for a \code{lme4} model? (default \code{TRUE})
#' @return A formula, character string, or list, depending
#' @export
design_formula <- function(design_args,
                           n_subj = NULL,
                           dv_name = NULL,
                           lme4_format = TRUE) {
  iv_names <- names(design_args[["ivs"]])

  fixed <- paste(iv_names, collapse = " * ")

  fac_cnts <- fac_counts(iv_names, trial_lists(design_args, subjects = n_subj))
  fac_info <- attr(terms(as.formula(paste0("~", paste(iv_names, collapse = "*")))), "factors")

  ## figure out whether data are multilevel
  is_unit_ml <- sapply(fac_cnts, function(lx) {
    is_multilevel <- FALSE
    ## first condition: more than one subject? (item?)
    ranfac_has_multiple_levels <- any(sapply(lx, ncol) > 1) 
    if (ranfac_has_multiple_levels) {
      is_fac_multilevel <- sapply(lx, function(fx) {
        any(apply(fx, 2, function(.x) any(.x > 1L)))
      })
      is_multilevel <- any(is_fac_multilevel)
    }
    is_multilevel
  })

  if (!any(is_unit_ml)) {
    ## data are not multilevel
    rfx <- NULL
  } else {
    ## data are multilevel  
    rfx <- lapply(fac_cnts[is_unit_ml], function(lx) {
      lvec <- sapply(lx, function(mx) {
        as.logical(prod(apply(mx, 2, function(xx) all(xx > 1))))
      })
      res <- fac_info[, lvec, drop = FALSE]        
      keep_term <- rep(TRUE, ncol(res))
      ## try to simplify the formula
      for (cx in rev(seq_len(ncol(res))[-1])) {
        drop_term <- sapply(seq_len(cx - 1), function(ccx) {
          identical(as.logical(res[, ccx, drop = FALSE]) | as.logical(res[, cx, drop = FALSE]),
                    as.logical(res[, cx, drop = FALSE]))
        })
        keep_term[seq_len(cx - 1)] <- keep_term[seq_len(cx - 1)] & (!drop_term)
      }
      fterms <- apply(res[, keep_term, drop = FALSE], 2, function(llx) {
        paste(names(llx)[as.logical(llx)], collapse = " * ")
      })
      need_int <- any(apply(lx[[1]], 2, sum) > 1)
      fterms2 <- if (need_int) c("1", fterms) else fterms
      paste(fterms2, collapse = " + ")
    })
  }

  form_list <- c(list(fixed = fixed), rfx)

  if (lme4_format) {
    form_str <- paste0(dv_name, " ~ ", form_list[["fixed"]])
    if (length(form_list) > 1L) {
      form_str <- paste0(form_str, " + ",
                         paste(sapply(names(form_list[-1]),
                                      function(nx) paste0("(", rfx[[nx]], " | ", nx, ")")),
                               collapse = " + "))
    }
    result <- as.formula(form_str)
  } else {
    result <- lapply(form_list, function(x) formula(paste0("~", x)))
  }
  
  return(result)
}
#' Generate population for data simulation
#'
#' @param design_args list specifying experimental design (see
#'   \code{\link{stim_lists}}); for best results, n_item should be
#'   2*minimum number of items needed for the design
#' @param n_subj number of subjects (for defining random effects
#'   structure; for best results, should be 2*number of stimulus lists
#' @param fixed_ranges list of 2-element vectors (min, max) defining
#'   ranges of fixed effect parameters
#' @param var_range 2-element vector defining range (min, max) of
#'   random effect variances
#' @param err_range 2-element vector defining range of error variance
#' @return list with parameters for data generation
#' @seealso \code{\link{sim_norm}}
#' @examples
#'
#' dargs <- list(ivs = c(A = 2, B = 2), n_item = 8)
#' gen_pop(dargs, 8)
#' @importFrom clusterGeneration genPositiveDefMat
#' @export
gen_pop <- function(design_args,
                    n_subj = NULL,
                    fixed_ranges = NULL,                    
                    var_range = c(0, 3),
                    err_range = c(0, 6)) {
    tdat <- trial_lists(design_args, n_subj)
    if ("n_rep" %in% colnames(tdat)) {
        design_args[["ivs"]] <- c(as.list(design_args[["ivs"]]), list(n_rep = unique(tdat[["n_rep"]])))
    } else {}
    forms <- design_formula(design_args, n_subj, lme4_format = FALSE)
    tnames <- lapply(forms, function(x) term_names(design_args, x))
    err_var <- runif(1, err_range[1], err_range[2])
    ## generate random effects
    rfx <- lapply(tnames[-1], function(x) {
        mx <- clusterGeneration::genPositiveDefMat(length(x),
                                                   covMethod = "onion",
                                                   rangeVar = var_range)$Sigma
        dimnames(mx) <- list(x, x)
        return(mx)
    })
    ## generate fixed effects
    if (!is.null(fixed_ranges)) {
        if (length(fixed_ranges) != length(tnames[["fixed"]])) {
            stop("fixed_ranges must have ", length(tnames[["fixed"]]),
                 " elements, corresponding to variables ",
                 paste(tnames[["fixed"]], collapse = ", "))
        } else {}
    } else {
        fixed_ranges <- lapply(seq_along(tnames[["fixed"]]), function(x) {c(0, 3)})
        names(fixed_ranges) <- tnames[["fixed"]]        
    }
    if (!is.null(names(fixed_ranges)) &&
            !identical(names(fixed_ranges), tnames[["fixed"]])) {
        warning("names of 'fixed_ranges' elements do not match variable names: ",
                paste(tnames[["fixed"]], collapse = ", "))
    } else {}
    return(list(fixed = sapply(fixed_ranges, function(x) runif(1, x[1], x[2])),
                subj_rfx = rfx[["subj_id"]],
                item_rfx = rfx[["item_id"]],
                err_var = err_var))
}

#' Sample data from population with normal error variance
#'
#' @param design_args experiment design (see
#'   \code{\link{stim_lists}}); must contain sub-element \code{n_item}
#'   defining the number of items.
#' @param n_subj number of subjects
#' @param params list with parameters defining population
#'   (\code{fixed}, \code{subj_rfx}, \code{item_rfx}), and
#'   \code{err_var}; normally generated by a call to
#'   \code{\link{gen_pop}}.
#' @param contr_type name of function defining IV contrast type; see
#'   \code{?contrasts}
#' @param verbose whether to return explicit information about
#'   individual random effects and residual error
#' 
#' @return A data frame with simulated data
#' @seealso \code{\link{gen_pop}}
#' @examples
#' design_args <- list(ivs = c(A = 2, B = 3), n_item = 18)
#' pop_params <- gen_pop(design_args, 12)
#' 
#' dat <- sim_norm(design_args, 12, pop_params)
#' @importFrom MASS mvrnorm
#' @export
sim_norm <- function(design_args,
                     n_subj,
                     params,
                     contr_type = "contr.dev",
                     verbose = FALSE) {
  required_elements <- c("fixed", "subj_rfx", "item_rfx", "err_var")
  missing_elements <- setdiff(required_elements, names(params))
  if (length(missing_elements) > 0) {
    stop("mcr.data was missing element(s): ",
         paste(missing_elements, collapse = ", "))
  } else {}
  if (is.null(design_args[["n_item"]])) {
    stop("'n_item' not specified in 'design_args'")
  } else {}
  rfx <- mapply(function(x, n) {
    if (!is.null(x)) {
      MASS::mvrnorm(n, mu = rep(0, ncol(x)), x)
    } else {
      n
    }
  }, params[c("subj_rfx", "item_rfx")],
  c(n_subj, design_args[["n_item"]]), SIMPLIFY = FALSE)
  dat <- compose_data(design_args,
                      fixed = params[["fixed"]],
                      subj_rmx = rfx[["subj_rfx"]],
                      item_rmx = rfx[["item_rfx"]],
                      contr_type = contr_type, verbose = verbose)
  dat[["err"]] <- rnorm(nrow(dat), sd = sqrt(params[["err_var"]]))
  dat[["Y"]] <- dat[["Y"]] + dat[["err"]]
  return(dat)
}
#' Generate stimulus presentation lists
#'
#' Generates counterbalanced presentation lists for factorially
#' designed experiments involving stimulus presentation
#'
#' @param design_args A list describing the experimental design, which
#' must have an element \code{ivs}, giving a named list of independent
#' variables, with each list element a vector giving the levels of
#' that IV, or a single number stating the number of desired levels.
#' If any IVs are administered between-subjects or between-items,
#' these should be named in list elements \code{between_subj} and
#' \code{between_item} respectively.  The argument \code{design_args}
#' also can optionally include the following two elements:
#' \code{n_item}, the desired number of stimulus items, which if
#' unspecified, will result in lists with the minimum possible number
#' of items; and \code{n_rep}, the number of repetitions of each
#' stimulus item for each participant (default 1).
#' @param as_one boolean (default \code{TRUE}) specifying whether the
#' presentation lists are to be returned as a single data frame or as
#' elements in a list object
#'
#' @return a single \code{data.frame} (default) with each list
#' identified by \code{list_id} or a \code{list} of dataframes,
#' depending on the value of \code{as_one}
#'
#' @examples
#' stim_lists(list(ivs = c(A = 2, B = 2))) # 2x2 within-subjects within-item
#' 
#' stim_lists(list(ivs = c(A = 2, B = 2, n_item = 16))) # same but w/more items
#'
#' stim_lists(list(ivs = c(A = 2, B = 2, n_item = 16, n_rep = 3)))
#'
#' # mixed by subject, fully within by item
#' stim_lists(list(ivs = list(group = c("adult", "child"),
#'                            task = c("easy", "hard")),
#'                 between_subj = "group",
#'                 n_item = 12))
#'
#' # mixed by subject, mixed by item
#' stim_lists(list(ivs = c(A = 2, B = 2),
#'            between_subj = "A",
#'            between_item = "B"))
#' @export
stim_lists <- function(design_args, 
                       as_one = TRUE) {
    fac_combine_levels <- function(vars, iv_list, dframe = TRUE) {
        row_indices <- rev(do.call("expand.grid",
                                   lapply(rev(vars),
                                          function(x) seq_along(iv_list[[x]]))))
        res <- mapply(function(x, y) x[y], iv_list[vars], row_indices)
        if (dframe) {
            as.data.frame(res, stringsAsFactors = FALSE)
        } else {
            res
        }
    }

    rotate_cells <- function(x, combine = FALSE) {
        res <- lapply(seq_len(nrow(x)),
                      function(ix) x[c(ix:nrow(x), seq_len(ix - 1)), , drop = FALSE])
        if (combine) {
            do.call("rbind", res)
        } else {
            res
        }
    }

    bs_combine <- function(dat, plists) {
        ## factorially combine across lists for between subject variables
        if (nrow(dat) == 0) {
            return(plists)
        } else {}
        res <- c(lapply(seq_len(nrow(dat)), function(rx) {
            if (length(plists) > 0) {
                lapply(plists, function(lx) {
                    cbind(dat[rep(rx, nrow(lx)), , drop = FALSE], lx)
                })
            } else {
                dat[rx, , drop = FALSE]
            }
        }))
        if (length(plists) > 0) {
            do.call("c", res)
        } else {
            res
        }
    }

    check_design_args(design_args)
    iv_names <- names(design_args[["ivs"]])
    ## check whether elements of 'ivs' are numbers and convert to char vector
    ivs2 <- lapply(iv_names, function(nx) {
        x <- design_args[["ivs"]][[nx]]
        if ((length(x) == 1) && is.numeric(x)) {
            paste0(nx, seq_len(x))
        } else {x}
    })
    names(ivs2) <- iv_names

    item_within <- setdiff(names(ivs2), design_args[["between_item"]])
    subj_within <- setdiff(names(ivs2), design_args[["between_subj"]])
    ## iv_levels <- sapply(ivs2, length) # IS THIS NEEDED?

    ww_fac <- intersect(item_within, subj_within)

    ww_chunks <- rotate_cells(fac_combine_levels(intersect(item_within, subj_within),
                                                 ivs2))

    wb_chunks <- fac_combine_levels(intersect(subj_within, design_args[["between_item"]]), ivs2)

    ## combine the WSWI and WSBI chunks to create the base presentation lists
    if (nrow(wb_chunks) > 0) {
        if (length(ww_chunks) > 0) {
            base_plists <- lapply(ww_chunks, function(ww) {
                cbind(wb_chunks[rep(seq_len(nrow(wb_chunks)), each = nrow(ww)), , drop = FALSE], ww)
            })
        } else {
            base_plists <- list(wb_chunks)
        }
    } else {
        base_plists <- ww_chunks
    }

    ## handle BSWI
    bswi <- fac_combine_levels(intersect(design_args[["between_subj"]],
                                         item_within), ivs2)
    bswi_lists <- bs_combine(bswi, base_plists)

    ## handle bsbi factors (if they exist)
    bsbi <- fac_combine_levels(intersect(design_args[["between_subj"]],
                                         design_args[["between_item"]]), ivs2)
    bsbi_lists <- bs_combine(bsbi, bswi_lists)
    div_fac <- if (nrow(bsbi)) nrow(bsbi) else 1
    n_item <- design_args[["n_item"]]
    if (is.null(design_args[["n_item"]])) { # dynamically choose minimum n_item
        if (length(bswi_lists) > 0) {
            n_item <- nrow(bswi_lists[[1]]) * div_fac
        } else {
            n_item <- div_fac
        }
    } else {}
    if (length(bswi_lists) > 0) {
        item_fac <- div_fac * nrow(bswi_lists[[1]])
        if ((n_item %% item_fac) != 0) {
            stop("n_item must be a factor of ", item_fac)
        } else {}
    } else {}

    if (length(bsbi_lists) == 0) {
        bsbi_lists <- bswi_lists
    } else {}

    if ((n_item %% div_fac) != 0) stop("n_item must be a multiple of ", div_fac)

    rep_times <- if (length(bswi_lists) > 0) length(bswi_lists) else 1
    it_chunks <- rep(seq_len(div_fac), each = rep_times)
    it_lists <- split(seq_len(n_item),
                      rep(seq_len(div_fac), each = n_item / div_fac))[it_chunks]

    plists <- mapply(function(x, y) {
        ix <- rep(seq_len(nrow(y)), each = length(x) / nrow(y))
        cbind(item_id = x, y[ix, , drop = FALSE])
    },
                     it_lists, bsbi_lists, SIMPLIFY = FALSE)

    n_rep <- design_args[["n_rep"]]
    if (is.null(design_args[["n_rep"]])) n_rep <- 1

    if (n_rep > 1) {
        plists <- lapply(plists, function(x) {
                             data.frame(n_rep = as.character(paste0("r", rep(seq_len(n_rep), each = nrow(x)))),
                                        x[rep(seq_len(nrow(x)), n_rep), , drop = FALSE],
                                        check.names = FALSE, stringsAsFactors = FALSE)
                         })
    } else {}

    if (as_one) {
        res <- mapply(function(x, y) {
            cbind(list_id = x, y)
        },
                      seq_along(plists), plists, SIMPLIFY = FALSE)
        final_lists <- do.call("rbind", res)
    } else {
        final_lists <- plists
    }
    rownames(final_lists) <- NULL
    return(final_lists)
}

#' Generate trial lists from a stimulus presentation lists
#'
#' Merge stimulus presentation lists with subject data to create a
#' trial list.
#'
#' @param design_args Stimulus presentation lists (see \code{\link{stim_lists}}).
#' @param subjects One of the following three: (1) an integer
#' specifying the desired number of subjects (must be a multiple of
#' number of stimulus lists); (2) a data frame with assignment
#' information (must include a column \code{subj_id}); or (3)
#' \code{NULL}, in which case there will be one subject per list.
#' @param seq_assign If TRUE, assignment of subjects to lists will
#' be sequential rather than random (default is FALSE)
#'
#' @return A data frame containing all trial information.
#' @export
trial_lists <- function(design_args,
                        subjects = NULL, seq_assign = FALSE) {
    sp_lists <- stim_lists(design_args)
    sp2 <- split(sp_lists, sp_lists[["list_id"]])
    if (is.null(subjects)) {
        subjects <- length(sp2)
    } else {}
    if (is.numeric(subjects)) {
        if ((subjects %% length(sp2)) != 0) {
            stop("'subjects' must be a multiple of number of lists (",
                 length(sp2), ")")
        } else {}
        list_ord = rep(seq_along(sp2), subjects / length(sp2))
        if (!seq_assign) {
            list_ord = sample(list_ord) # randomize assignment to lists
        } else {}
        subj_dat <- data.frame(subj_id = seq_len(subjects),
                               list_id = list_ord)
    } else {
        if (!is.data.frame(subjects)) {
            stop("'subjects' must be an integer, data.frame, or NULL")
        } else {}
        subj_dat <- subjects
        if (any(!("subj_id" %in% names(subj_dat)),
                !("list_id" %in% names(subj_dat)))) {
            stop("'subjects' must contain fields 'subj_id', 'list_id'")
        } else {}
    }
    res <- lapply(seq_len(nrow(subj_dat)), function(rx) {
               cbind(subj_id = subj_dat[rx, "subj_id"],
                     sp2[[subj_dat[rx, "list_id"]]])
           })
    res2 <- do.call("rbind", res)
    rownames(res2) <- NULL
    return(res2)
}

#' Compose response data from fixed and random effects
#'
#' @param design_args List containing information about the experiment
#' design; see \code{\link{stim_lists}}
#' @param fixed vector of fixed effects
#' @param subj_rmx matrix of by-subject random effects
#' @param item_rmx matrix of by-item random effects
#' @param verbose give debugging info (default = \code{FALSE})
#' @param contr_type contrast type (default "contr.dev"); see ?contrasts
#'
#' @details This will add together all of the fixed and random effects
#' according to the linear model specified by the design.  Note,
#' however, that it does not add in any residual noise; for that, use
#' the function \code{\link{sim_norm}}.
#' 
#' @return a data frame containing response variable \code{Y}, the
#' linear sum of all fixed and random effects.
#' @export
compose_data <- function(design_args,
                         fixed = NULL,
                         subj_rmx = NULL,
                         item_rmx = NULL,
                         verbose = FALSE,
                         contr_type = "contr.dev") {

  ## utility function for doing matrix multiplication
  multiply_mx <- function(des_mx, rfx, row_ix, design_args) {
    ## make sure all cols in rfx are represented in des_mx
    diff_cols <- setdiff(colnames(rfx), colnames(des_mx))
    if (length(diff_cols) != 0) {
      stop("column(s) '", paste(diff_cols, collapse = ", "),
           "' not represented in terms '",
           paste(term_names(design_args[["ivs"]],
                            design_args[["between_subj"]],
                            design_args[["between_item"]]),
                 collapse = ", "), "'")
    } else {}

    reduced_des <- des_mx[, colnames(rfx), drop = FALSE]

    t_rfx <- t(rfx)
    res_vec <- vector("numeric", length(row_ix))
    for (ix in unique(row_ix)) {
      lvec <- row_ix == ix
      res_vec[lvec] <- c(reduced_des[lvec, , drop = FALSE] %*%
                         t_rfx[, ix, drop = FALSE])
    }
    res_vec
  }

  ivs_nrep <- design_args[["ivs"]]
  if (!is.null(design_args[["n_rep"]])) {
    if (design_args[["n_rep"]] > 1) {
      ivs_nrep <- c(as.list(design_args[["ivs"]]),
                    list(n_rep = paste0("r", seq_len(design_args[["n_rep"]]))))
    } else {}
  } else {}
  iv_names <- names(ivs_nrep)
  if (is.matrix(subj_rmx)) {
    tlists <- trial_lists(design_args, subjects = nrow(subj_rmx))
  } else {
    tlists <- trial_lists(design_args, subjects = subj_rmx)
  }

  cont <- as.list(rep(contr_type, length(ivs_nrep)))
  names(cont) <- iv_names

  mmx <- model.matrix(as.formula(paste0("~", paste(iv_names, collapse = "*"))),
                      tlists,
                      contrasts.arg = cont)

  if (is.null(fixed)) {
    fixed <- runif(ncol(mmx), -3, 3)
    names(fixed) <- colnames(mmx)
  } else {}

  ## fixed component of Y
  fix_y <- c(mmx %*% fixed) # fixed component of Y

  if (is.matrix(subj_rmx)) {
    ## stop("Autogeneration of subj_rmx not implemented yet; please define 'subj_rmx'")
    if (nrow(subj_rmx) != length(unique(tlists[["subj_id"]]))) {
      stop("Argument 'subj_rmx' has ", nrow(subj_rmx), " rows; needs ",
           length(unique(tlists[["subj_id"]])))
    } else {}
    sre <- multiply_mx(mmx, subj_rmx, tlists[["subj_id"]], design_args)
  } else {
    sre <- NULL
  }

  if (is.matrix(item_rmx)) {
    ## stop("Autogeneration of item_rmx not implemented yet; please define 'item_rmx'")
    if (nrow(item_rmx) != length(unique(tlists[["item_id"]]))) {
      stop("Argument 'item_rmx' has ", nrow(item_rmx), " rows; needs ",
           length(unique(tlists[["item_id"]])))
    } else {}
    ire <- multiply_mx(mmx, item_rmx, tlists[["item_id"]], design_args)
  } else {
    ire <- NULL
  }
  
  comb_mx <- matrix(nrow = nrow(tlists), ncol = 0)
  if (verbose) {
    ## comb_mx <- cbind(fix_y = fix_y, sre = sre, ire = ire, err = err)
    comb_mx <- cbind(fix_y = fix_y, sre = sre, ire = ire)
  } else {}
  ## cbind(tlists, Y = fix_y + sre + ire + err, comb_mx)

  yvals <- fix_y
  if (!is.null(sre)) {
    yvals <- yvals + sre
  }
  if (!is.null(ire)) {
    yvals <- yvals + ire
  }
  cbind(tlists, Y = yvals, comb_mx)
}
