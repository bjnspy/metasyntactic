mkdir ../tags/YourRights/iPhone/$1
svn add ../tags/YourRights/iPhone/$1
svn cp MetasyntacticShared/ ../tags/YourRights/iPhone/$1/MetasyntacticShared
svn cp YourRights/ ../tags/YourRights/iPhone/$1/YourRights
tar -zcvf ../tags/YourRights/iPhone/$1/Distribution-iphoneos.tar.gz  YourRights/iPhone/build/Distribution-iphoneos
svn add ../tags/YourRights/iPhone/$1/Distribution-iphoneos.tar.gz