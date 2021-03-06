

KNITR_TAB_ENV = new.env()
KNITR_TAB_ENV$current_tab_index = 0
KNITR_TAB_ENV$current_div_index = 0
KNITR_TAB_ENV$header = NULL
KNITR_TAB_ENV$current_html = ""
KNITR_TAB_ENV$random_str = round(runif(1, min = 1, max = 1e8))
KNITR_TAB_ENV$css_added = FALSE

# == title
# Add one JavaScript tab in the report
#
# == param
# -code R code to execute
# -header header or the title for the tab
# -desc decription in the tab
# -opt options for knitr chunk
#
# == details
# This function in only for internal use.
#
# == author
# Zuguang Gu <z.gu@dkfz.de>
knitr_add_tab_item = function(code, header, desc = "", opt = NULL) {
	KNITR_TAB_ENV$current_tab_index = KNITR_TAB_ENV$current_tab_index + 1
	tab = qq("tab-@{KNITR_TAB_ENV$random_str}-@{KNITR_TAB_ENV$current_tab_index}")
	knitr_text = qq(
"@{strrep('`', 3)}{r @{tab}-opt, echo = FALSE}
options(width = 100)
@{strrep('`', 3)}

@{strrep('`', 3)}{r @{tab}@{ifelse(is.null(opt), '', paste0(', ', opt))}}
@{code}
@{strrep('`', 3)}

@{desc}
")	

	# while(dev.cur() > 1) dev.off()

	op1 = getOption("markdown.HTML.options")
	op2 = getOption("width")
	options(markdown.HTML.options = setdiff(op1, c("base64_images", "toc")))
	md = knit(text = knitr_text, quiet = TRUE, envir = parent.frame())
	html = markdownToHTML(text = md, fragment.only = TRUE)
	html = qq("<div id='@{tab}'>\n@{html}\n</div>\n")
	options(markdown.HTML.options = op1, width = op2)
	KNITR_TAB_ENV$header = c(KNITR_TAB_ENV$header, header)
	KNITR_TAB_ENV$current_html = paste0(KNITR_TAB_ENV$current_html, html)
	return(invisible(NULL))
}

# == title
# Generate the HTML code for the JavaScript tabs.
#
# == details
# This function is only for internal use.
#
# == author
# Zuguang Gu <z.gu@dkfz.de>
knitr_insert_tabs = function() {
	KNITR_TAB_ENV$current_div_index = KNITR_TAB_ENV$current_div_index + 1

	extdata_dir = system.file("extdata", package = "cola")

	if(!KNITR_TAB_ENV$css_added) {
		css = readLines(paste0(extdata_dir, "/jquery-ui.css"))
		cat("<style type='text/css'>\n")
		cat(css, sep = "\n")
		cat("</style>\n")
		cat("<script src='js/jquery-1.12.4.js'></script>\n")
		cat("<script src='js/jquery-ui.js'></script>\n")
	}
	qqcat("
<script>
$( function() {
	$( '#tabs@{KNITR_TAB_ENV$current_div_index}' ).tabs();
} );
</script>
")
	qqcat("<div id='tabs@{KNITR_TAB_ENV$current_div_index}'>\n")
	cat("<ul>\n")
	qqcat("<li><a href='#tab-@{KNITR_TAB_ENV$random_str}-@{seq_len(KNITR_TAB_ENV$current_tab_index)}'>@{KNITR_TAB_ENV$header}</a></li>\n")
	cat("</ul>\n")
	cat(KNITR_TAB_ENV$current_html)
	cat("</div>\n")

	KNITR_TAB_ENV$current_tab_index = 0
	KNITR_TAB_ENV$header = NULL
	KNITR_TAB_ENV$current_html = ""
	KNITR_TAB_ENV$random_str = round(runif(1, min = 1, max = 1e8))
	KNITR_TAB_ENV$css_added = TRUE
	
	return(invisible(NULL))
}

# == title
# Make report for the ConsensusPartitionList object
#
# == param
# -object a `ConsensusPartitionList-class` object
# -output_dir the output directory where put the report
# -env where the objects in the report are found, internally used
#
# == details
# The `ConsensusPartitionList-class` object contains results for all top methods and all partition methods.
# This function generates a HTML report which contains all plots for every combination
# of top method and partition method.
#
# == author
# Zuguang Gu <z.gu@dkfz.de>
#
setMethod(f = "cola_report",
	signature = "ConsensusPartitionList",
	definition = function(object, output_dir = getwd(), env = parent.frame()) {

	var_name = deparse(substitute(object, env = env))
	make_report(var_name, object, output_dir, class = "ConsensusPartitionList")

})


# == title
# Make report for the ConsensusPartition object
#
# == param
# -object a `ConsensusPartition-class` object
# -output_dir the output directory where put the report
#
# == details
# Please generate report on the `ConsensusPartitionList-class` object directly.
#
# == author
# Zuguang Gu <z.gu@dkfz.de>
#
setMethod(f = "cola_report",
	signature = "ConsensusPartition",
	definition = function(object, output_dir) {

	qqcat("Please call `cola_report()` on `ConsensusPartitionList` object directly.\n")
	return(invisible(NULL))
})


# == title
# Make report for the HierarchicalPartition object
#
# == param
# -object a `HierarchicalPartition-class` object
# -output_dir the output directory where put the report
# -env where the objects in the report are found, internally used
#
# == details
# This function generates a HTML report which contains all plots for all nodes
# in the partition hierarchy.
#
# == author
# Zuguang Gu <z.gu@dkfz.de>
#
setMethod(f = "cola_report",
	signature = "HierarchicalPartition",
	definition = function(object, output_dir, env = parent.frame()) {

	if(nrow(object@hierarchy) == 1) {
		cat("No hierarchy detected, won't generate the report.\n")
		return(invisible(NULL))
	}
	var_name = deparse(substitute(object, env = env))
	make_report(var_name, object, output_dir, class = "HierarchicalPartition")

})


make_report = function(var_name, object, output_dir, class) {

	template_file = c("HierarchicalPartition" = "cola_hc_template.Rmd",
		              "ConsensusPartitionList" = "cola_report_template.Rmd")
	html_file = c("HierarchicalPartition" = "cola_hc.html",
		          "ConsensusPartitionList" = "cola_report.html")

	# report_template = system.file("extdata", template_file[class], package = "cola")
	report_template = paste0("~/project/cola/inst/extdata/", template_file[class])

	if(file.exists(output_dir)) {
		fileinfo = file.info(output_dir)
		if(!fileinfo$isdir) {
			output_dir = dirname(output_dir)
		}
	}

	dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)

	tempfile = tempfile(tmpdir = output_dir, pattern = "cola_", fileext = ".Rmd")
	brew(report_template, output = tempfile)
	op = getOption("markdown.HTML.options")
	options(markdown.HTML.options = setdiff(op, "base64_images"))
	md_file = gsub("Rmd$", "md", tempfile)
	owd = getwd()
	setwd(output_dir)
	knit(tempfile, md_file)
	markdownToHTML(md_file, paste0(output_dir, "/", html_file[class]))
	# file.remove(c(tempfile, md_file))
	options(markdown.HTML.options = op)
	setwd(owd)

	dir.create(paste0(output_dir, "/js"), showWarnings = FALSE)
	file.copy(system.file("extdata", "jquery-ui.js", package = "cola"), paste0(output_dir, "/js/"))
	file.copy(system.file("extdata", "jquery-1.12.4.js", package = "cola"), paste0(output_dir, "/js/"))

	qqcat("report is at @{output_dir}/@{html_file[class]}\n")

	KNITR_TAB_ENV$current_tab_index = 0
	KNITR_TAB_ENV$current_div_index = 0
	KNITR_TAB_ENV$header = NULL
	KNITR_TAB_ENV$current_html = ""
	KNITR_TAB_ENV$random_str = round(runif(1, min = 1, max = 1e8))
	KNITR_TAB_ENV$css_added = FALSE

	return(invisible(NULL))
}
