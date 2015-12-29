# Makefile.PL - run this to generate a Makefile for pip.
# Copyright 2002 Ed Avis.  See COPYING for conditions.
#
use ExtUtils::MakeMaker;

# Work around a bug installing section 1 manpages.
use vars '%extra_constants';
%extra_constants = (INSTALLMAN1DIR  => '$(PREFIX)/man/man1');

WriteMakefile
  (
   NAME		=> 'pathmerge',
   VERSION      => '0.2',
   ($] >= 5.005 ?    ## Add these new keywords supported since 5.005
    (AUTHOR     => 'Ed Avis <ed@membled.com>') : ()),
   EXE_FILES    => [ qw(pathmerge) ],
  );

sub MY::constants {
    package MY;
    my $inherited = shift->SUPER::constants(@_);
    die if not keys %::extra_constants;
    foreach (sort keys %::extra_constants) {
	$inherited .= "$_ = $::extra_constants{$_}\n";
    }
    return $inherited;
}
