use strict;
use warnings;
use utf8;
use HTML::Entities 'decode_entities';
use IO::All -binary, -utf8;

binmode STDOUT, ":utf8";

my $in_file      = "input.csv";
my $out_file     = "output.csv";
my %replacements = (
    '\u00ED' => 'í',
);

# stream_big_files();
slurp_small_files();

#read in output file and print to screen to confirm
print io( $out_file )->all;

sub clean_lines {
    my ( $line ) = @_;

    decode_entities( $line );    # in place

    #Find and replace
    for my $k ( keys %replacements ) {
        $line =~ s/\Q$k\E/$replacements{$k}/g;
    }

    return $line;
}

sub slurp_small_files {
    my @lines = io( $in_file )->all;
    $_ = clean_lines( $_ ) for @lines;
    io( $out_file )->print( @lines );
    return;
}

sub stream_big_files {
    my $in  = io( $in_file );
    my $out = io( $out_file );
    while ( my $line = $in->getline ) {
        last if !defined $line;
        $line = clean_line( $line );
        $out->print( $line );
    }
}
