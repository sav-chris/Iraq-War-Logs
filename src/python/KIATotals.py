import MySQLdb
from jinja2 import Template
import os


python_dir: str = os.path.dirname(os.path.realpath(__file__))
src_dir: str = os.path.dirname(python_dir)
root_dir: str = os.path.dirname(src_dir)
data_dir: str = os.path.join(root_dir, 'data')
html_dir: str = os.path.join(src_dir, 'html')
plots_dir: str = os.path.join(root_dir, 'docs')

kiaTotalsHtmlTemplate: str = os.path.join(html_dir, 'KIATotals.html')
kiaTotalsHtml: str = os.path.join(plots_dir, 'KIATotals.html')


class KIATotal:

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

cp = KIATotal()

cur.callproc("KIATotals", [])

for row in cur.fetchall():
    cp.CivilianKIA = row[0] / row[4]
    cp.FriendlyKIA = row[1] / row[4]
    cp.HostNationKIA = row[2] / row[4]
    cp.EnemyKIA = row[3] / row[4]

with open(kiaTotalsHtmlTemplate) as f:
    tmpl = Template(f.read())

    src = tmpl.render\
    (
        CivilianKIA = cp.CivilianKIA,
        FriendlyKIA = cp.FriendlyKIA,
        HostNationKIA = cp.HostNationKIA,
        EnemyKIA = cp.EnemyKIA
    )

    with open(kiaTotalsHtml, "w") as text_file:
        print(src, file=text_file)


db.close()
