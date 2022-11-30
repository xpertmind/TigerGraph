import argparse
import os
import csv
import pandas as pd
import gzip
import pyTigerGraph as tg
import cfg

chunk_size = 20000  # nr. of records to read from each file
parser = argparse.ArgumentParser(description='Get the arguments')
parser.add_argument('Path', metavar='path',  type=str,
                    help='the path to the refinitive files')
args = parser.parse_args()

input_path = args.Path

if not os.path.isdir(input_path):
    print('The path specified does not exist')
    exit()

# TG
tgconn = tg.TigerGraphConnection(host=cfg.host, graphname=cfg.graphname, username=cfg.username,
                                 password=cfg.password, restppPort=cfg.restppPort, gsPort=cfg.gsPort, useCert=False, gsqlVersion=cfg.gsqlversion)
cfg.token = tgconn.getToken(cfg.secret, cfg.tokenlifetime)

#ddl
with open(input_path + "/ddl.gsql") as f:
    contents = f.read()
print(tgconn.gsql(''' + contents + ''', options=[]))

# funstions
with open(input_path + "/functions.gsql") as f:
    contents = f.read()
print(tgconn.gsql(''' + contents + ''', options=[]))


exit()
