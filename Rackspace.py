#Authentication
import os, os.path, pyrax, pyrax.exceptions as exc, time, sys
pyrax.set_setting("identity_type", "rackspace")
pyrax.set_default_region('IAD')
pyrax.set_credentials("blakefallow", "3fc4fa43efc04d53bfe149b7f7c15ec8")
cf = pyrax.cloudfiles

#Container & StorageObject
cont = cf.get_container("mysql_backups")
objs = cont.get_objects()

#Date & Time
now = time.time()
deltime = os.path.getmtime in objs
difftime = now - deltime

#Fetch File
for obj in objs:
    if difftime < (30 * 86400):
     cf.download_object("mysql_backups",obj.name,"C:\Users\Blake\Desktop",structure=False);
  
#Clean up
for obj in objs:
    if difftime > (30 * 86400):
        cont.delete_object(obj.name)
#print(now)