#!/usr/bin/perl -w
# Test suite for pathmerge.
# This code is in the public domain, see README.
#

use strict;

my $EXE = 'blib/script/pathmerge';
if (not -x $EXE) {
    die "$EXE not executable\n";
}

# Tests are: arguments to pathmerge, and expected output.
my @tests
  = (
     [ [], "\n" ],
     [ [ '' ], "\n" ],
     [ [ '', '' ], "\n" ],
     [ [ ':' ], "\n" ],
     [ [ ':/foo' ], ":/foo\n" ],
     [ [ '/foo', '/bar' ], "/foo:/bar\n" ],
     [ [ '/foo', '/bar', '/foo' ], "/foo:/bar\n" ],
     [ [ '/foo', '/bar:/baz', '/foo' ], "/foo:/bar:/baz\n" ],
     [ [ '/foo:/foo/fumble', '/bar:/baz', '/foo' ], "/foo:/foo/fumble:/bar:/baz\n" ],
     [ [ '/foo:/foo/fumble:', '/bar:/foo' ], "/foo:/foo/fumble::/bar\n" ],
     [ [ '/foo:/foo/fumble:', '.', '.:/foo' ], "/foo:/foo/fumble::.\n" ],
     [ [ '', '.', '.:/foo' ], ":.:/foo\n" ],
     [ [ '-d', '/', '/nonexistent' ], "/\n" ],
    );

print '1..', scalar @tests, "\n";
my $test_num = 1;
foreach (@tests) {
    my ($args, $expect) = @$_;
    my $got;

    my $pid = open(FH, '-|');
    if (not defined $pid) {
	die "cannot fork: $!";
    }
    elsif ($pid) {
	# Parent.
	local $/ = undef;
	$got = <FH>;
	close FH or die "cannot close pipe from child: $!";
    }
    else {
	# Child.  Throw away stderr for now, just check stdout.
	open STDERR, '>/dev/null'
	  or die "cannot reopen stderr to /dev/null: $!";
	exec($EXE, @$args) or die "cannot exec $EXE: $!";
    }

    if ($got eq $expect) {
	print "ok $test_num\n";
    }
    else {
	print STDERR "ran $EXE ", join(' ', @$args), "\n";
	print STDERR "expected '$expect'\n";
	print STDERR "got '$got'\n";
	print "not ok $test_num\n";
    }
    ++ $test_num;
}
