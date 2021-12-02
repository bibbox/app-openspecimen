import pandas as pd
import argparse
import email, smtplib, ssl
from email import encoders
from email.mime.base import MIMEBase
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText
import OpenSpecimenAPIconnector as OSconn
import OpenSpecimenAPIconnector.os_core as os_core
import OpenSpecimenAPIconnector.os_util as os_util
import OpenSpecimenAPIconnector.mg_core as mg_core
import OpenSpecimenAPIconnector.mg_util as mg_util
import xlsxwriter
from pathlib import Path

base_url= 'http://localhost:8080' 
base_url+='/openspecimen/rest/ng'

loginname='admin'#input() 
password='Login@123'#input()
auth = (loginname, password)
logfile = open("/var/lib/openspecimen/plugins/log.txt", "a")


# Create the parser
parser = argparse.ArgumentParser()
# Add an argument
parser.add_argument('--es', type=str, required=True)
parser.add_argument('--er', type=str, required=True)
parser.add_argument('--p', type=str, required=True)
parser.add_argument('--id', type=str, required=True)
# Parse the argument
args = parser.parse_args()

#print(args.es, args.er, args.p, args.id)

# Setting the login data for the given Openspecimen instance
OSconn.config_manager.set_login(base_url, auth)

# get necessary cp information
cp_tools = os_core.collection_protocol()

# get cp info and wirte a dict in order to simplify the api output
cps = cp_tools.get_all_collection_protocols()
cp_ids= []
for i, item in enumerate(cps):
    if str(args.id) == str(item["id"]):
        cp_ids.append(item["id"])
        print("found id")
        logfile.write("found_id")
exporter = mg_util.bbmri_connector()
filename = "/var/lib/openspecimen/plugins/test.xlsx"  # In same directory as script
bbmri_file = exporter.execute(cp_ids, "/var/lib/openspecimen/plugins/empty_eric_duo.xlsx")
logfile.write("wrote file")

try:
    with pd.ExcelWriter(filename, engine='xlsxwriter') as writer:
        for sheet_name in bbmri_file.keys():
            df = bbmri_file[sheet_name]
            df.to_excel(writer, sheet_name=sheet_name, index=False)

except Exception as e:
    logfile.write(e)
subject = "Directory Update"
body = "Diese wichtige Nachricht spamt dich mit EMX files für das directory !"
sender_email = args.es
receiver_email = args.er
password = args.p

# Create a multipart message and set headers
message = MIMEMultipart()
message["From"] = sender_email
message["To"] = receiver_email
message["Subject"] = subject
#message["Bcc"] = receiver_email  # Recommended for mass emails

# Add body to email
message.attach(MIMEText(body, "plain"))
# Open PDF file in binary mode
with open(filename, "rb") as attachment:
    # Add file as application/octet-stream
    # Email client can usually download this automatically as attachment
    part = MIMEBase("application", "octet-stream")
    part.set_payload(attachment.read())

# Encode file in ASCII characters to send by email    
encoders.encode_base64(part)

# Add header as key/value pair to attachment part
part.add_header(
    "Content-Disposition",
    f"attachment; filename= {filename}",
)

# Add attachment to message and convert message to string
message.attach(part)
text = message.as_string()

# Log in to server using secure context and send email
context = ssl.create_default_context()
with smtplib.SMTP_SSL("smtp.gmail.com", 465, context=context) as server:
    print(sender_email, password)
    server.login(sender_email, password)
    server.sendmail(sender_email, receiver_email, text)
    server.quit()

logfile.write("done")
