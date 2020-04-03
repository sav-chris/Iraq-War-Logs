import MySQLdb
from jinja2 import Template
import os


python_dir: str = os.path.dirname(os.path.realpath(__file__))
src_dir: str = os.path.dirname(python_dir)
root_dir: str = os.path.dirname(src_dir)
data_dir: str = os.path.join(root_dir, 'data')
html_dir: str = os.path.join(src_dir, 'html')
plots_dir: str = os.path.join(root_dir, 'docs')

deathsBreakdownHtmlTemplate: str = os.path.join(html_dir, 'DeathsBreakdown.html')
deathsBreakdownHtml: str = os.path.join(plots_dir, 'DeathsBreakdown.html')

class Breakdown:

    def __init__(self):
        pass


db = MySQLdb.connect\
(
    host="localhost",
    user="warlogger",
    passwd="warlogger",
    db="iraqwarlogs",
    port=3308
)

cur = db.cursor()

cur.callproc("KIABreakdown", [])

results = []

for row in cur.fetchall():
    theBreakdown = Breakdown()

    theBreakdown.type = row[0]
    theBreakdown.category = row[1]
    theBreakdown.affiliation = row[2]
    theBreakdown.AttackOn = row[3]
    theBreakdown.CivilianKIA = row[4]
    theBreakdown.FriendlyKIA = row[5]
    theBreakdown.HostNationKIA = row[6]
    theBreakdown.EnemyKIA = row[7]
    theBreakdown.Total = row[8]

    results.append(theBreakdown)

    print\
    (
        str(row[0]) + ", " +
        str(row[1]) + ", " +
        str(row[2]) + ", " +
        str(row[3]) + ", " +
        str(row[4]) + ", " +
        str(row[5]) + ", " +
        str(row[6]) + ", " +
        str(row[7]) + ", " +
        str(row[8])
    )

db.close()

with open(deathsBreakdownHtmlTemplate) as f:
    template = Template(f.read())

    src = template.render\
    (
        results=zip
        (
            [n.type for n in results],
            [n.category for n in results],
            [n.affiliation for n in results],
            [n.AttackOn for n in results],
            [n.CivilianKIA for n in results],
            [n.FriendlyKIA for n in results],
            [n.HostNationKIA for n in results],
            [n.EnemyKIA for n in results],
            [n.Total for n in results]
        )
    )

with open(deathsBreakdownHtml, "w") as text_file:
    print(src, file=text_file)



