package Demeter::UI::Athena::PlotK;

use Wx qw( :everything );
use base 'Wx::Panel';
use Wx::Event qw(EVT_LIST_ITEM_ACTIVATED EVT_LIST_ITEM_SELECTED EVT_BUTTON  EVT_KEY_DOWN);

use Demeter::UI::Wx::SpecialCharacters qw(:all);

sub new {
  my ($class, $parent) = @_;
  my $this = $class->SUPER::new($parent, -1, wxDefaultPosition, wxDefaultSize, wxMAXIMIZE_BOX );

  my $box = Wx::BoxSizer->new( wxVERTICAL );

  my $hbox = Wx::BoxSizer->new( wxVERTICAL );
  $box -> Add($hbox, 1, wxALL|wxALIGN_CENTER_HORIZONTAL, 4);

  my $slot = Wx::BoxSizer->new( wxHORIZONTAL );
  $hbox -> Add($slot, 0, wxGROW|wxALL, 0);
  $this->{chie} = Wx::CheckBox->new($this, -1, $CHI.'(E)          ');
  $slot -> Add($this->{chie}, 1, wxALL, 1);
  $this->{mchie} = Wx::CheckBox->new($this, -1, '');
  $slot -> Add($this->{mchie}, 0, wxALL, 1);

  $slot = Wx::BoxSizer->new( wxHORIZONTAL );
  $hbox -> Add($slot, 0, wxGROW|wxALL, 0);
  $this->{win} = Wx::CheckBox->new($this, -1, 'Window');
  $slot -> Add($this->{win}, 0, wxALL, 1);


  $this->{$_}->SetBackgroundColour( Wx::Colour->new($Demeter::UI::Athena::demeter->co->default("athena", "single")) )
    foreach (qw(chie win));
  $this->{$_}->SetBackgroundColour( Wx::Colour->new($Demeter::UI::Athena::demeter->co->default("athena", "marked")) )
    foreach (qw(mchie));


  $hbox -> Add(0, 1, 1);

  my $right = Wx::BoxSizer->new( wxVERTICAL );
  $hbox -> Add($right, 0, wxALL, 4);

  my $range = Wx::BoxSizer->new( wxHORIZONTAL );
  $box -> Add($range, 0, wxBOTTOM, 7);
  my $label = Wx::StaticText->new($this, -1, "kmin");
  $this->{kmin} = Wx::TextCtrl ->new($this, -1, $Demeter::UI::Athena::demeter->co->default("plot", "kmin"),
				     wxDefaultPosition, [50,-1]);
  $range -> Add($label,        0, wxALL, 5);
  $range -> Add($this->{kmin}, 0, wxRIGHT, 10);
  $label = Wx::StaticText->new($this, -1, "kmax");
  $this->{kmax} = Wx::TextCtrl ->new($this, -1, $Demeter::UI::Athena::demeter->co->default("plot", "kmax"),
				     wxDefaultPosition, [50,-1]);
  $range -> Add($label,        0, wxALL, 5);
  $range -> Add($this->{kmax}, 0, wxRIGHT, 10);


  $this->SetSizerAndFit($box);
  return $this;
};

1;