# YAML parser for pandoc markdown

BEGIN {
    D = "$"
    nr = 0
}

# add field to current multi-value field
nr && /^[[:space:]]*-[[:space:]]+/ {
    val = $0
    gsub(/^[[:space:]]+*-[[:space:]]+/, "", val)
    gsub(/[[:space:]]*$/, "", val)
    if (md[cr]) md[cr] = md[cr] D val;
    else md[cr] = val;
}

# finish parsing multi-value field
nr && /^[[:space:]]*-[[:space:]]+/ { nr = 0 }

# add single-value field to metadata
!nr && /^[[:alpha:]]+:[[:space:]]+/ {
    val = $0
    gsub(/^[[:alpha:]]+:[[:space:]]+/, "", val)
    gsub(/:$/, "", $1)
    md[$1] = val
}

# start parsing multi-value field
!nr && /^[[:alpha:]]+:[[:space:]]*$/ {
    nr = 1
    cr = $1
    gsub(/:$/, "", cr)
}

# finish parsing after YAML data ends
$0 == "..." { exit }

# output medatada: author, title, date and filename w/o extention
END {
    sub(/^"/, "", md["title"]) # remove preceding quotation marks
    sub(/"$/, "", md["title"]) # remove trailing quotation marks
    gsub(/\\"/, "\"", md["title"]) # un-escape quotation marks
    sub(/^.*\//, "", FILENAME) # remove file path
    sub(/\.[[:alnum:]]*$/, "", FILENAME) # remove file extention
    
    OFS="\t";
    if (keywords == 1 && "keywords" in md) {
	split(md["keywords"], kw, D)
	split(md["author"], au, D)
	for (i in kw) # for each keyword...
	    for (j in au) # ... and each author print a row
		print au[j], md["title"], md["date"], FILENAME, kw[i];
    } else { # if no keywords...
	split(md["author"], au, D)
	for (i in au) # ... print a row for each author
	    print au[i], md["title"], md["date"], FILENAME;
    }
}
