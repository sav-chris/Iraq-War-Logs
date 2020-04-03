import MySQLdb
from jinja2 import Template
import os

python_dir: str = os.path.dirname(os.path.realpath(__file__))
src_dir: str = os.path.dirname(python_dir)
root_dir: str = os.path.dirname(src_dir)
data_dir: str = os.path.join(root_dir, 'data')
html_dir: str = os.path.join(src_dir, 'html')
plots_dir: str = os.path.join(root_dir, 'plots')

casualtiesBreakdownHtmlTemplate: str = os.path.join(html_dir, 'CasualtiesBreakdown.html')
casualtiesBreakdownHtml: str = os.path.join(plots_dir, 'CasualtiesBreakdown.html')


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

cur.callproc("WoundedBreakdown", [])

results = []

for row in cur.fetchall():
    theBreakdown = Breakdown()

    theBreakdown.type = row[0]
    theBreakdown.category = row[1]
    theBreakdown.affiliation = row[2]
    theBreakdown.AttackOn = row[3]
    theBreakdown.CivilianWIA = row[4]
    theBreakdown.FriendlyWIA = row[5]
    theBreakdown.HostNationWIA = row[6]
    theBreakdown.EnemyWIA = row[7]
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

with open(casualtiesBreakdownHtmlTemplate) as f:
    template = Template(f.read())

    src = template.render\
    (
        results=zip
        (
            [n.type for n in results],
            [n.category for n in results],
            [n.affiliation for n in results],
            [n.AttackOn for n in results],
            [n.CivilianWIA for n in results],
            [n.FriendlyWIA for n in results],
            [n.HostNationWIA for n in results],
            [n.EnemyWIA for n in results],
            [n.Total for n in results]
        )
    )

with open(casualtiesBreakdownHtml, "w") as text_file:
    print(src, file=text_file)



