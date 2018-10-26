import xlsxwriter
import os
import sys

def process_layout_data(filename = "TextLayout.txt"):
    workbook = xlsxwriter.Workbook(filename.split('.')[0] + ".xlsx")
    worksheet = workbook.add_worksheet()
    worksheet.add_table('A1')
    data = open(filename)
    lines = data.readlines()
    
    lines = map(lambda x: x.strip('\n').split(':'), filter(lambda x: ':' in x ,lines))
    data_map = {}
    for line in lines:
        key = line[0].strip()
        value = round(float(line[1].strip()),2)
        if data_map.has_key(key):
            data_map[key].append(value)
        else:
            data_map[key] = [value]
    print data_map
    
    index = 1
    for (key,value) in data_map.iteritems():
        worksheet.write_row("A" + str(index),[key] + value)
        index += 1
    workbook.close()
    
if __name__ == '__main__':
    if len(sys.argv) == 2:
        process_layout_data(sys.argv[1])
    else:
        process_layout_data()
    


