#!/usr/bin/python3
import os
import shutil
import re

os.chdir("client")

SERVER_PREFIX = "../server/from_client/" 
PRIVATE_PREFIX = "../private/from_client/"

shutil.rmtree(SERVER_PREFIX)
shutil.rmtree(PRIVATE_PREFIX)
os.makedirs(PRIVATE_PREFIX)

def convert_coffee(source, target):
    with open(target, "w") as tf, open(source) as sf:
        for line in sf.readlines():
            match = re.match("Template.(\w+).helpers", line)
            if match:
                name = match.group(1)
                tf.write("SSR.compileTemplate '{name}', Assets.getText('from_client/{name}.jade'), language: 'jade'\n\n"
                         .format(name=match.group(1)))
            tf.write(line)
            
            
def convert_jade(source):
    tf = None
    if source == "./components/head/head.jade":
        with open(SERVER_PREFIX + "head.coffee", 'w') as f:
            f.write("SSR.compileTemplate '{name}', Assets.getText('from_client/{name}.jade'), language: 'jade'\n\n"
                         .format(name='head'))
        tf = open(PRIVATE_PREFIX + "head.jade", 'w')
        strip_chars = 0
    with open(source) as sf:
        for line in sf.readlines():
            if not line.strip():
                continue
            match = re.match(r"template\(name=['\"](\w+)['\"]\)", line)
            if match:
                name = match.group(1)
                if tf:
                    tf.close()
                tf = open(PRIVATE_PREFIX + name + ".jade", 'w')
                strip_chars = 4
            else:
                assert tf
                tf.write(line[strip_chars:])
    if tf:
        tf.close()
                

for directory, subdirs, files in os.walk("."):
    for d in subdirs:
        dname = os.path.join(directory, d)
        print(dname)
        os.makedirs(SERVER_PREFIX + dname)
    for f in files:
        fname = os.path.join(directory, f)
        print(fname)
        unused_path, ext = os.path.splitext(fname)
        if ext == ".less":
            target = SERVER_PREFIX + fname
            shutil.copyfile(fname, target)
        elif ext == ".coffee":
            target = SERVER_PREFIX + fname
            convert_coffee(fname, target)
        elif ext == ".jade":
            convert_jade(fname)
            