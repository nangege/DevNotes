import xlsxwriter
import os

workbook = xlsxwriter.Workbook('charts.xlsx')

dataPath = 'data/'
files = os.listdir(dataPath)

for file in files:
    worksheet = workbook.add_worksheet(file.strip('.txt'))
    path = os.path.join(dataPath,file)
    data = open(path)
    lines = data.readlines()
    worksheet.add_table('A1')

    lines = map(lambda x: x.strip('\n').split(':'), filter(lambda x: ':' in x ,lines))
    data_map = {}
    for line in lines:
        key = line[0]
        value = round(float(line[1]),2)
        if data_map.has_key(key):
            data_map[key].append(value)
        else:
            data_map[key] = [value]
    
    worksheet.write_row("A1",data_map.keys())
    index = 0
    column = ['A','B','C',"D",'E','F','G','H','I','J','K','L','M','N','O','P','Q']
    for key,value in data_map.iteritems():
        worksheet.write_column(column[index] + '2',value)
        index += 1
    
        
workbook.close()
