import os

directory = "UNI"
files = os.listdir(directory)

t = "Unicode = {\n"

for uni in files:
    u = uni[3:]
    u = u[:5]
    u = int(u)
    t = t+" [\""+str(chr(u))+"\"] = "+str(u)+",\n"

t = t[:len(t)-2]+"\n}\n"

f = open("LC_Unicode.lua", "w", encoding='utf-8')
f.write(t)
f.close()
