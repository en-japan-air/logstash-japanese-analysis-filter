require 'lock_jar'

lockfile = File.expand_path("../../Jarfile.lock", __FILE__)
# Download any missing Jars
LockJar.install(lockfile)
# Loads the ClassPath with Jars from the lockfile
LockJar.load(lockfile)
