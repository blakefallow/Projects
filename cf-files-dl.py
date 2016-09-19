#Authentication
import os, os.path, pyrax, pyrax.exceptions as exc, time
pyrax.set_setting("identity_type", "")
pyrax.set_default_region('')
pyrax.set_credentials("", "")
cf = pyrax.cloudfiles

#Container & StorageObject
cont = cf.get_container("")
objs = cont.get_objects()

#Fetch File
for obj in objs:
     cf.download_object("",obj.name,"",structure=False);
