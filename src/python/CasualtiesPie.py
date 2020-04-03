import MySQLdb
from jinja2 import Template
import os


python_dir: str = os.path.dirname(os.path.realpath(__file__))
src_dir: str = os.path.dirname(python_dir)
root_dir: str = os.path.dirname(src_dir)
data_dir: str = os.path.join(root_dir, 'data')
html_dir: str = os.path.join(src_dir, 'html')
plots_dir: str = os.path.join(root_dir, 'docs')

casualtiesHtmlTemplate: str = os.path.join(html_dir, 'CasualtiesPie.html')
casualtiesHtml: str = os.path.join(plots_dir, 'CasualtiesPie.html')


class CasualtiesPercent:

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

cp = CasualtiesPercent()

cur.callproc("KilledWoundedPercentage", [])

for row in cur.fetchall():
    cp.Civilian = row[0]
    cp.Friendly = row[1]
    cp.HostNation = row[2]
    cp.Enemy = row[3]

with open(casualtiesHtmlTemplate) as f:
    tmpl = Template(f.read())

    src = tmpl.render\
    (
        Civilian = cp.Civilian,
        Friendly = cp.Friendly,
        HostNation = cp.HostNation,
        Enemy = cp.Enemy
    )

    with open(casualtiesHtml, "w") as text_file:
        print(src, file=text_file)

db.close()
