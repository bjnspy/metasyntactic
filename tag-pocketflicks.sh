mkdir ../tags/PocketFlicks/iPhone/$1
svn add ../tags/PocketFlicks/iPhone/$1
svn cp PocketFlicks/iPhone/ ../tags/PocketFlicks/iPhone/$1/PocketFlicks
svn cp BoxOfficeShared/ ../tags/PocketFlicks/iPhone/$1/BoxOfficeShared
svn cp MetasyntacticShared/ ../tags/PocketFlicks/iPhone/$1/MetasyntacticShared
svn cp NetflixShared/ ../tags/PocketFlicks/iPhone/$1/NetflixShared
tar -zcvf ../tags/PocketFlicks/iPhone/$1/Distribution-iphoneos.tar.gz PocketFlicks/iPhone/build/Distribution-iphoneos
svn add ../tags/PocketFlicks/iPhone/$1/Distribution-iphoneos.tar.gz