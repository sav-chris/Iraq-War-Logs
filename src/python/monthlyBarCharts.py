import MySQLdb
from jinja2 import Template
import os


python_dir: str = os.path.dirname(os.path.realpath(__file__))
src_dir: str = os.path.dirname(python_dir)
root_dir: str = os.path.dirname(src_dir)
data_dir: str = os.path.join(root_dir, 'data')
html_dir: str = os.path.join(src_dir, 'html')
plots_dir: str = os.path.join(root_dir, 'plots')

monthlyBarChartHtmlTemplate: str = os.path.join(html_dir, 'MonthlyBarChart.html')
monthlyBarChartHtml: str = os.path.join(plots_dir, 'MonthlyBarChart.html')


class Event(object):

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

cur.callproc("MonthlyCasualties", [])

events = []

for row in cur.fetchall():
    theEvent = Event()

    theEvent.TheYear = row[0]
    theEvent.TheMonth = row[1]
    theEvent.friendlyWia = row[2]
    theEvent.friendlyKia = row[3]
    theEvent.hostNationWia = row[4]
    theEvent.hostNationKia = row[5]
    theEvent.civilianWia = row[6]
    theEvent.civilianKia = row[7]
    theEvent.enemyWia = row[8]
    theEvent.enemyKia = row[9]
    theEvent.enemyDetained = row[10]

    events.append(theEvent)

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
        str(row[8]) + ", " +
        str(row[9]) + ", " +
        str(row[10])
    )

db.close()


with open(monthlyBarChartHtmlTemplate) as f:
    tmpl = Template(f.read())

    src = tmpl.render\
    (
        theDate=zip([n.TheYear for n in events], [n.TheMonth for n in events]),
        friendlyWia=[n.friendlyWia for n in events],
        friendlyKia=[n.friendlyKia for n in events],
        hostNationWia=[n.hostNationWia for n in events],
        hostNationKia=[n.hostNationKia for n in events],
        civilianWia=[n.civilianWia for n in events],
        civilianKia=[n.civilianKia for n in events],
        enemyWia=[n.enemyWia for n in events],
        enemyKia=[n.enemyKia for n in events],
        enemyDetained=[n.enemyDetained for n in events]
    )

    with open(monthlyBarChartHtml, "w") as text_file:
        print(src, file=text_file)

