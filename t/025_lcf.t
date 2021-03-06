#!/usr/bin/perl

## Test LCF object functionality of Demeter under Moose

=for Copyright
 .
 Copyright (c) 2008-2017 Bruce Ravel (http://bruceravel.github.io/home).
 All rights reserved.
 .
 This file is free software; you can redistribute it and/or
 modify it under the same terms as Perl itself. See The Perl
 Artistic License.
 .
 This program is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

=cut

use Test::More tests => 14;

use Demeter qw(:data);
use Demeter::LCF;
use File::Basename;
use File::Spec;

use Demeter::Constants qw($EPSILON2 $EPSILON3);
use Const::Fast;

my $here  = dirname($0);

my $this = Demeter::LCF -> new();
my $OBJ  = 'LCF';

ok( ref($this) =~ m{$OBJ},           "made a $OBJ object");
ok( $this->plottable,                "$OBJ object is plottable");
ok( $this->group =~ m{\A\w{5}\z},    "$OBJ object has a proper group name");
ok( $this->name =~ m{LCF},           "name set to its default (" . $this->name . ")");
$this -> name('this');
ok( $this->name eq 'this',           "$OBJ object has a settable label");
ok( ref($this->mo) =~ 'Mode',        "$OBJ object can find the Mode object");
ok( ref($this->co) =~ 'Config',      "$OBJ object can find the Config object");
ok( ref($this->po) =~ 'Plot',        "$OBJ object can find the Plot object");
my $which = (Demeter->is_larch) ? 'larch' : 'ifeffit';
ok( ($this->mo->template_plot     =~ m{plot}   and
     $this->mo->template_feff     eq 'feff6'   and
     $this->mo->template_process  eq $which and
     $this->mo->template_fit      eq $which and
     $this->mo->template_analysis eq $which),
                                     "$OBJ object can find template sets");


my $prj  = Demeter::Data::Prj -> new(file=>'t/cyanobacteria.prj');
$this -> space('der');
my $data = $prj->record(4);
my ($metal, $chloride, $sulfide) = $prj->records(9, 11, 15);

$this->data($data);
$this->add_many($metal, $chloride, $sulfide);
#$this->add($metal);
#$this->add($chloride);
#$this->add($sulfide);

$this->xmin($data->bkg_e0-20);
$this->xmax($data->bkg_e0+60);
$this->fit;

ok( $this->data,                     "$OBJ object has an associated Data object");

ok( abs($this->rfactor - 0.0047212) < $EPSILON3,  "R-factor (0.0047212) ".$this->rfactor );
ok( $this->nvarys == 2,  "nvarys (2)" );
my @list = @{ $this->standards };
my ($w, $dw) = $this->weight($list[0]);
ok( abs($w  - 0.322) < $EPSILON2,  "metal weight (0.322)" );
ok( abs($dw - 0.028) < $EPSILON2,  "metal uncertainty (0.028)" );

