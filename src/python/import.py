import csv
import os

python_dir: str = os.path.dirname(os.path.realpath(__file__))
src_dir: str = os.path.dirname(python_dir)
root_dir: str = os.path.dirname(src_dir)
data_dir: str = os.path.join(root_dir, 'data')

processed_file: str = os.path.join(data_dir, 'processed.csv')
input_file: str = os.path.join(data_dir, 'iraq-war-diary-redacted.csv')

if os.path.exists(processed_file):
    os.remove(processed_file)

processed_file = open(processed_file, "w+")

# id,"url","reportkey","date","type","category","trackingnumber","title","summary","region","attackon","complexattack","reportingunit","unitname","typeofunit",friendlywia,friendlykia,hostnationwia,hostnationkia,civilianwia,civiliankia,enemywia,enemykia,enemydetained,"mgrs","latitude","longitude","originatorgroup","updatedbygroup","ccir","sigact","affiliation","dcolor","classification"
quoted_cols = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,24,25,26,27,28,29,30,31,32,33]

with open(input_file, newline='') as csvfile:
    logreader = csv.reader(csvfile, delimiter=',', quotechar='"', escapechar='\\')  
    for row in logreader:

        # apply quotes
        for f in range(0, len(row) - 1):
            if f in quoted_cols:
                row[f] = '"' + row[f] + '"'

        line = ','.join(row)
        line = line + '\n'
        processed_file.write(line)
        

processed_file.close()

