# LibraryFind - Quality find done better.
# Copyright (C) 2007 Oregon State University
#
# This program is free software; you can redistribute it and/or modify it under 
# the terms of the GNU General Public License as published by the Free Software 
# Foundation; either version 2 of the License, or (at your option) any later 
# version.
#
# This program is distributed in the hope that it will be useful, but WITHOUT 
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS 
# FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License along with 
# this program; if not, write to the Free Software Foundation, Inc., 59 Temple 
# Place, Suite 330, Boston, MA 02111-1307 USA
#
# Questions or comments on this program may be addressed to:
#
# LibraryFind
# 121 The Valley Library
# Corvallis OR 97331-4501
#
# http://libraryfind.org

require 'yaml'

db = YAML::load_file("../config/database.yml")
pusername=db['production']['username']
ppassword = db['production']['password']
pdatabase =db['production']['database']

dusername = db['development']['username']
dpassword = db['development']['password']
ddatabase = db['development']['database']

sucess = system('mysqldump --opt ' + pdatabase + '>prod_backup.sql -u' + pusername + ' --password=' + ppassword)
success = system('mysql ' + ddatabase + ' < prod_backup.sql -u' + dusername + ' --password=' + dpassword)
  

