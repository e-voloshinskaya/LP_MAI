data = open("data.pl", "w", encoding="utf-8") # open "data.pl" with utf-8 encoding
data.write(":- encoding(utf8).\n\n")  # for russian lang in prolog

person = {}  # key - id, data - person name
parents = {}  # relations need to be saved (as the order of people is unknown) in form "child - (mum_id, dad_id)""
ID = 0

# list of constants for this gedcom format file
id_indi_start = 4  # after first @ there is useless I symbol
id_fam_start = 9
id_fam_end = -2  # the last one is line break symbol!
name_name_start = 7
surname_name_end = -2
count = 0
with open("royal_gen_20_11_2002.ged", "r", encoding="cp1251") as f: # open the source gedcom file (Windows 1251 encoding)
    for line in f:
        if count < 27:
            count += 1
            continue
        if "INDI" in line:  # find a person's id
            id_indi_end = line.index('@', id_indi_start)
            ID = line[id_indi_start : id_indi_end]
        elif "NAME" in line: # find a person's full name
            end_name = line.index('/')
            name = (line[name_name_start : end_name]).strip()
            surname = line[end_name + 1 : surname_name_end]
            string = (name + ' ' + surname).strip()
            full_name = string.replace('"', '\'')
            person[ID] = '"' + full_name + ' ' + str(ID) + '"' # strip deletes spaces if no surname
        elif "FAM" in line:  # resetting ids after family ends
            father_id = 0
            mother_id = 0
            child_id = 0
        # while "FAM" not in line, find family relations: father, mother, children ids
        elif "HUSB" in line:
            father_id = line[id_fam_start : id_fam_end]
        elif "WIFE" in line:
            mother_id = line[id_fam_start : id_fam_end]
        elif "CHIL" in line:
            child_id = line[id_fam_start : id_fam_end]
            parents[child_id] = (mother_id, father_id)
        count += 1

# write transformed data into it data.pl
for child in parents:
    if child != 0 and child in person:
        mother = parents[child][0]
        if mother != 0 and mother in person:
            data.write("mother(" + person[mother] + ", " + person[child] + ").\n")
for child in parents:
    if child != 0 and child in person:
        father = parents[child][1]
        if father != 0 and father in person:
            data.write("father(" + person[father] + ", " + person[child] + ").\n")

data.close()
