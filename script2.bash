#!/bin/bash
# Auteur : Yvan Laverdiere

# here, a grep can be used to sort the domains in the graph, example below.
#cat allqueriesFormatted.csv | grep microsoft | cut -d',' -f2 | sort | uniq -c | sort -nr | head -40 | sed -e 's/^ *//g' | sed -e 's/ /,/' > mashit.txt

# no grep to use all of the domains in the graph.
cat allqueriesFormatted.csv | cut -d',' -f2 | sort | uniq -c | sort -nr | head -40 | sed -e 's/^ *//g' | sed -e 's/ /,/' > mashit.txt

# Fichier de sortie --- Outfile
TEMP=/tmp/graphique.html
IFS=$'\n'
# Boucle sur le fichier top10.txt
for ligne in $(cat mashit.txt);
do
shit2=$(echo $ligne | sed -e "s/\(.*\),\(.*\)/\['\2', \1\]/")
echo $shit2
shit1=$shit1$shit2","
done;

shit3=$(echo "${shit1::-1}")
cat > $TEMP <<EOF
<html>
<head>
<!--API AJAX -->
<script type="text/javascript" src="https://www.google.com/jsapi"></script>
<script type="text/javascript">
// API Visualization et package piechart
google.load('visualization', '1.0', {'packages':['corechart']});
google.setOnLoadCallback(drawChart);
// Instanciation du graphique
function drawChart() {
// Cree la table des donnees
var data = new google.visualization.DataTable();
data.addColumn('string', 'Title');
data.addColumn('number', 'Value');
data.addRows([
$shit3
]);
# below is where you can change the title of the graph.
// Options
var options = {'title':'Hits par domaines',
'width':1200,
'height':800};
// Conception du graphique
var chart = new google.visualization.PieChart(document.getElementById('chart_div'));


chart.draw(data, options);
}
</script>
</head>
<body>
<!--Div qui contiendra le graphique-->
<div id="chart_div"></div>
</body>
</html>
EOF
echo $TEMP


