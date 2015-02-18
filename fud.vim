function! Fud( ... )

python << EOF

import os
import re, anydbm
import vim

def openVimQ( db, fileAlias ):
   try:
      path = db[ fileAlias ]
   except:
      print "Binding for " + fileAlias + " doesn't exist"
      return
   # open the file for edit in vim
   vimCmd = 'open ' + path
   vim.command( vimCmd )

def getDbPath():
   # As of now, the current directory is the dbpath
   cwd = os.getcwd()
   return cwd  

def ofud():
  
   dbName = getDbPath() 
   #handle failure
   #createHashFile if not already there
   user = os.environ.get( 'USER' )
   wsDb = anydbm.open( dbName + '/' + user + '_dbf', 'c' )
   
   # try and get the arguments
   argv = []
   argc = int( vim.eval( "a:0" ) ) + 1
   for i in range( 1, argc ): 
      evalNo = "a:" + str( i )
      argv.append( vim.eval( evalNo ) )

   if len( argv ) == 1:
      # is a query
      openVimQ( wsDb, argv[ 0 ] )
   elif len( argv ) == 2:
      # wsDb[ alias ] = path
      wsDb[ argv[ 0 ] ] = argv[ 1 ]
      openVimQ( wsDb, argv[ 0 ] )
   elif len( argv ) == 0:
      print '\nFiles under development for ' + dbName 
      print '---------------------------------------'
      for entry in wsDb.keys():
         print entry + " => " + wsDb[ entry ]

ofud()

EOF

command! -nargs=? Fud call Fud(<f-args>)

endfunction
