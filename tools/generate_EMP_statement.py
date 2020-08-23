from argparse import ArgumentParser
import os, re

parser = ArgumentParser()
parser.add_argument('--agents', type=str, default='')
parser.add_argument('--input', type=str, default='KEM_EMP.lst')
parser.add_argument('--output', type=str, default='EMP_statement.gms')
parser.add_argument('--models', type=str, default='integrated_model.info')
args = parser.parse_args()

# Getting the agents prefix and countries
input_file = args.input
output_file = args.output
models_file = args.models

# Loading the integrated sectors from the info file
myFile = open(models_file, 'r')
keys = [(line[:-1].split()[0], line[:-1].split()[1]) for line in myFile]
sectors = set([item[0] for item in keys])
myFile.close()

# removing the info file
os.remove(models_file)

list_of_e_dict = {key: [] for key in keys}
list_of_v_dict = {key: [] for key in keys}
myFile = open(input_file, 'r')
file_content = [line[:-1] for line in myFile]
myFile.close()

in_out = False
i = 0
# reading the list file and grepping the equations and variables
while i < len(file_content):
    if file_content[i][:5] == '---- ':
        in_out = True
    while in_out:
        i += 1
        line = file_content[i]
        if line == 'MODEL STATISTICS':
            in_out = False
            break
        if '..' in line:
            if 'objective' in line or re.match(r'([a-z]).*(_eqn)', line.lower()) is not None:
                continue
            line = line[0:line.find('..')]
            country = line[line.find('(')+1:line.find(')')].split(',')[-1]
            line = re.sub(r"\(", "(\'", line)
            line = re.sub(r"\)", "\')", line)
            line = re.sub(r",", "\',\'", line)
            key = (line[0:2], country)
            try:
                list_of_e_dict[key].append(line)
            except KeyError:
                continue
        elif re.match(r'([a-z]).*(\))', line.lower()) is not None and line[0] != 'D':
            country = line[line.find('(') + 1:line.find(')')].split(',')[-1]
            line = re.sub(r"\(", "(\'", line)
            line = re.sub(r"\)", "\')", line)
            line = re.sub(r",", "\',\'", line)
            key = (line[0:2], country)
            try:
                list_of_v_dict[key].append(line)
            except KeyError:
                continue

        if '---- ' in line:
            in_out = False
            i -= 1
    i += 1

# Writing the EMP file
with open(output_file, 'w') as f:
    print('put myinfo \'equilibrium\';', file=f)

    for sec, country in list_of_v_dict.keys():
        print("put / 'min', %sobjval('%s');" % (sec, country), file=f)
        print('    /* variables */', file=f)
        for item in list_of_v_dict[(sec, country)]:
            if 'objval' not in item:
                print('\tput %s;' % item, file=f)

        print('\n    /* Equations */', file=f)
        print("    put %sobjective('%s');" % (sec, country), file=f)
        for item in list_of_e_dict[(sec, country)]:
            print('\tput %s;' % item, file=f)
    for sec in sectors:
        if sec == 'EL':
            print('put \'dualvar D%ssup %ssup\';' % (sec, sec), file=f)
        else:
            print('put \'dualvar D%sdem %sdem\';' % (sec, sec), file=f)
    print('putclose myinfo;', file=f)
f.close()