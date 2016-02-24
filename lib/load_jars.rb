require 'lock_jar'

lockfile = File.expand_path("../../Jarfile.lock", __FILE__)
# Loads the ClassPath with Jars from the lockfile
LockJar.load(lockfile)