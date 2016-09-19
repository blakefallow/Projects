+#Authentication
import os, os.path, pyrax, pyrax.exceptions as exc, time
pyrax.set_setting("identity_type", "rackspace")
pyrax.set_default_region('select data center')
pyrax.set_credentials("rackspace_username", "apikey")
cf = pyrax.cloudfiles

#Container & StorageObject
cont = cf.get_container("container")
objs = cont.get_objects()

#Date & Time
now = time.time()
deltime = os.path.getmtime in objs
difftime = now - deltime

#Fetch File
for obj in objs:
    if difftime < (30 * 86400):
     cf.download_object("container",obj.name,"download_location",structure=False);
  
#Clean up
for obj in objs:
    if difftime > (30 * 86400):
        cont.delete_object(obj.name)
