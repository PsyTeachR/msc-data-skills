# Installing `R` {#installing-r}

It is recommended that you at least attempt to install R and RStudio on your own workstation.  In the long run, it will be better to have it on your own system, and moreover, it won't cost you anything.  However, you don't have to be that ambitious.  There are workstations in the Boyd Orr labs that have R/RStudio installed; additionally, library workstations may also have copies installed. The upside of using these workstations is that everything has been installed and tested.  The downside (apart from the obvious of not being able to take them home with you) is that you will have limited ability to configure it to your needs because you lack access privileges.  There may be some packages that won't install, and those that do install successfully will be wiped away after you logout.  These annoyances can be avoided by having your own version.

Installing R and RStudio is very easy. The sections below explain how, but in case you find it confusing, [there is a helpful YouTube video here](https://www.youtube.com/watch?v=lVKMsaWju8w).

## Installing Base R

Install base R from one of the mirrors near you.They are listed at
<http://cran.r-project.org/mirrors.html>. If a particular mirror is
down, try another one.  Once you have chosen a mirror, choose the
download link for your operating system (Linux, Mac OS X, or Windows)
and install &lsquo;base&rsquo; binaries for distribution. If you are using Linux
or Mac OS, you are done; skip to the next section on RStudio. If you
are installing the Windows version, after you install R, you should
also install RTools. Follow the link below (on the same page on the
mirror where you downloaded base R) to RTools, and then click on a
&lsquo;frozen&rsquo; version nearest to the top of the list (`Rtools33.exe` at the
time of writing, but there might be a later frozen version by the time
you are reading this).

## Installing RStudio

This is very easy: just go to <https://www.rstudio.com/products/rstudio/download3/> and download the RStudio Desktop (Free License) version for your operating system.

## Additional tweaks you might want to try

Although installing R and RStudio is itself very easy, there is an additional optional tweak that may not be so easy but you might want to try it.  This is installing the LaTeX typesetting system so that you can produce PDF reports from RStudio.  Without this additional tweak, you will be able to produce reports in HTML but not PDF.  To generate PDF reports, you will additionally need: 

1.  [pandoc](http://pandoc.org/installing.html), and
2.  LaTeX, a typesetting language, available through
    -   WINDOWS: <http://miktex.org/>
    -   Mac OS: [MacTex](https://tug.org/mactex/downloading.html) (2.6GB download) or [BasicTeX](http://ww.tug.org/mactex/morepackages.html) (100MB download, but should work fine)

Again, these additional tweaks are optional, and if you have problems installing these, don't get hung up on it; you can just generate HTML reports, and if you want a PDF, just use one of the Boyd Orr computers.

