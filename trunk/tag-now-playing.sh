mkdir ../tags/NowPlaying/iPhone/$1
svn add ../tags/NowPlaying/iPhone/$1
svn cp NowPlaying/iPhone/ ../tags/NowPlaying/iPhone/$1/NowPlaying
svn cp BoxOfficeShared/ ../tags/NowPlaying/iPhone/$1/BoxOfficeShared
svn cp MetasyntacticShared/ ../tags/NowPlaying/iPhone/$1/MetasyntacticShared
svn cp NetflixShared/ ../tags/NowPlaying/iPhone/$1/NetflixShared
tar -zcvf ../tags/NowPlaying/iPhone/$1/Distribution-iphoneos.tar.gz  NowPlaying/iPhone/build/Distribution-iphoneos
svn add ../tags/NowPlaying/iPhone/$1/Distribution-iphoneos.tar.gz