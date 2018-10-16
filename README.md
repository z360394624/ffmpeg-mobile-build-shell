# 基于FFMPEG项目编译适用于android平台的libggmpeg.so

## 编译ffmpeg准备

修改ffmpeg源码目录下configure文件，使编译完成的so库不会有版本号


        SLIBNAME_WITH_MAJOR='$(SLIBNAME).$(LIBMAJOR)'  
        LIB_INSTALL_EXTRA_CMD='$$(RANLIB)"$(LIBDIR)/$(LIBNAME)"'  
        SLIB_INSTALL_NAME='$(SLIBNAME_WITH_VERSION)'  
        SLIB_INSTALL_LINKS='$(SLIBNAME_WITH_MAJOR)$(SLIBNAME)' 

    改为


        SLIBNAME_WITH_MAJOR='$(SLIBPREF)$(FULLNAME)-$(LIBMAJOR)$(SLIBSUF)'  
        LIB_INSTALL_EXTRA_CMD='$$(RANLIB) "$(LIBDIR)/$(LIBNAME)"'  
        SLIB_INSTALL_NAME='$(SLIBNAME_WITH_MAJOR)'  
        SLIB_INSTALL_LINKS='$(SLIBNAME)' 

## 移动端mobile目录

## PC端linux目录

