BEGIN {
		has_epub = system("test -d ./epub") == 0
		has_mobi = system("test -d ./mobi") == 0
		has_pdf  = system("test -d ./pdf")  == 0

		print "<!DOCTYPE html>"
		printf "<!--\ngenerated "
		system("date -u")
		print "-->"
		print "<title>marxists.xyz</title>"
		# print "<title>redtexts mirror " NAME "</title>"
		print "<meta name=\"viewport\" content=\"width=device-width\" />"
		print "<meta charset=\"utf-8\" />"
		print "<link rel=\"stylesheet\" href=\"./style.css\">"
		while ((getline < "./res/header.txt") > 0)
				print;
		print "<table><thead><tr><th>Title</th><th>Date</th>"
		if (has_epub)	print "<th>Epub</th>"
		if (has_mobi)	print "<th>Kindle</th>"
		if (has_pdf)	print "<th>PDF</th>"
		print "</tr></thead><tbody>"
		FS = "\t"
}

{
		if ($1 != la) 
				print "<tr><th colspan=5 id=\"" idauth($1) "\"><a href=\"#" idauth($1) "\">" $1 "</a></th></tr>"
		la = $1;
		print "<tr>"
		print "<td><a href=\"./html/" $4 ".html\"><em>" $2 "</em></a></td>"
		print "<td><time>" $3 "</time></td>"
}

has_epub {
	print !system("test -f ./epub/" $4 ".epub") ? "<td><a href=\"./epub/" $4 ".epub\">&#x2198;</a></td>" : "<td>&#x2297;</td>"
}

has_mobi {
	print !system("test -f ./mobi/" $4 ".mobi") ? "<td><a href=\"./mobi/" $4 ".mobi\">&#x2198;</a></td>" : "<td>&#x2297;</td>"
}	

has_pdf {
	print !system("test -f ./pdf/" $4 ".pdf") ? "<td><a href=\"./pdf/" $4 ".pdf\">&#x2198;</a></td>" : "<td>&#x2297;</td>"
}

{ print "</tr>" }

END {
		print "</tbody></table>"
		while ((getline < "./res/footer.txt") > 0)
				print;
		print "<footer>"
		print "<a href=\"https://github.com/neueleninlekture/mirror-tools\">mirror tools</a>"
		print "| <a href=\"keywords.html\">keywords</a>"
		if (WMAST)
			print "| <a href=\"" WMAST "\">web master</a>"
		print "</footer>"
}
