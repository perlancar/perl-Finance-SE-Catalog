package Finance::SE::Catalog;

# DATE
# VERSION

use 5.010001;
use strict;
use warnings;

# BEGIN FRAGMENT id=meta-financial_market
# note: This fragment's content is generated by a script. Do not edit manually!
# src-file: /zpool_host_mnt/mnt/home/u1/repos/gudangdata/bin/../table/financial_market/meta.yaml
# src-revision: da3b188cdc9caa74d91a863c5a8d30d800394674 (Wed Sep 19 17:08:16 2018 +0700)
# generate-date: Wed Sep 19 10:20:12 2018 UTC
# generated-by: update-fragments-in-perl-module
our $meta = {
  fields => {
    add_codes    => {
                      pos      => 8,
                      schema   => "str*",
                      sortable => 1,
                      summary  => "Additional codes (each code separated by semicolon)",
                      unique   => 0,
                    },
    add_names    => {
                      pos      => 7,
                      schema   => "str*",
                      sortable => 1,
                      summary  => "Additional names (each name separated by semicolon)",
                      unique   => 0,
                    },
    add_yf_codes => {
                      pos      => 4,
                      schema   => "str*",
                      sortable => 1,
                      summary  => "Additional Yahoo! Finance codes (each code separated by semicolon)",
                      unique   => 0,
                    },
    city         => { pos => 10, schema => "str*", sortable => 1, summary => "City", unique => 0 },
    code         => {
                      pos      => 0,
                      schema   => "str*",
                      sortable => 1,
                      summary  => "Code (usually popular acronym if unique, otherwise MIC)",
                      unique   => 1,
                    },
    country      => {
                      pos      => 9,
                      schema   => "str*",
                      sortable => 1,
                      summary  => "ISO 2-letter country code",
                      unique   => 0,
                    },
    eng_name     => {
                      pos      => 5,
                      schema   => "str*",
                      sortable => 1,
                      summary  => "English name",
                      unique   => 1,
                    },
    founded      => {
                      pos      => 11,
                      schema   => "str*",
                      sortable => 1,
                      summary  => "Year founded",
                      unique   => 0,
                    },
    local_name   => { pos => 6, schema => "str*", sortable => 1, summary => "Local name", unique => 0 },
    mic          => {
                      pos      => 1,
                      schema   => ["str*", { len => 4 }],
                      sortable => 1,
                      summary  => "Market Identifier Code (ISO 10383)",
                      unique   => 1,
                    },
    status       => { pos => 12, schema => "str*", sortable => 1, summary => "Status", unique => 0 },
    types        => {
                      pos      => 2,
                      schema   => "str*",
                      sortable => 1,
                      summary  => "Types (each type separated by semicolon)",
                      unique   => 0,
                    },
    yf_code      => {
                      pos      => 3,
                      schema   => "str*",
                      sortable => 1,
                      summary  => "Yahoo! Finance code",
                      unique   => 0,
                    },
  },
  header => 1,
  pk => "code",
  summary => "Catalog (list) of stock exchanges",
};
# END FRAGMENT id=meta-financial_market

# BEGIN FRAGMENT id=data-financial_market
# note: This fragment's content is generated by a script. Do not edit manually!
# src-file: /zpool_host_mnt/mnt/home/u1/repos/gudangdata/bin/../table/financial_market/data.csv
# src-revision: da3b188cdc9caa74d91a863c5a8d30d800394674 (Wed Sep 19 17:08:16 2018 +0700)
# generate-date: Wed Sep 19 10:20:12 2018 UTC
# generated-by: update-fragments-in-perl-module
our $data = [
  [
    "NYSE",
    "XNYS",
    "SE",
    "",
    "",
    "New York Stock Exchange",
    "",
    "",
    "",
    "US",
    "New York City",
    1792,
    "active",
  ],
  [
    "NASDAQ",
    "XNAS",
    "SE",
    "",
    "",
    "Nasdaq Stock Exchange",
    "",
    "",
    "",
    "US",
    "New York City",
    1971,
    "active",
  ],
  [
    "IDX",
    "XIDX",
    "SE",
    "JK",
    "",
    "Indonesia Stock Exchange",
    "Bursa Efek Indonesia",
    "Bursa Efek Jakarta",
    "",
    "ID",
    "Jakarta",
    1912,
    "active",
  ],
  [
    "LSX",
    "XLON",
    "SE",
    "L",
    "IL",
    "London Stock Exchange",
    "",
    "",
    "",
    "GB",
    "London",
    1698,
    "active",
  ],
  [
    "SGX",
    "XSES",
    "SE",
    "SI",
    "",
    "Singapore Exchange",
    "",
    "Singapore Stock Exchange;Stock Exchange of Singapore",
    "",
    "SG",
    "Singapore",
    1973,
    "active",
  ],
];
# END FRAGMENT id=data-financial_market

my %code_occurrences;
my %se_by_primary_code;
my %se_by_code;
my %name_occurrences;
my %se_by_primary_name_lc;
my %se_by_name_lc;

sub new {
    my $class = shift;

    unless (keys %code_occurrences) {
        # primary code & name
        for my $rec (@$data) {
            # XXX check uniqueness of primary code & eng_name
            $code_occurrences{$rec->{code}}++;
            $se_by_primary_code{$rec->{code}} = $rec;
            $se_by_code{$rec->{code}} = $rec;
            my $name_lc = lc $rec->{eng_name};
            $name_occurrences{$name_lc}++;
            $se_by_primary_name_lc{$name_lc} = $rec;
            $se_by_name_lc{$name_lc} = $rec;
        }
        for my $rec (@$data) {
            # mic
            for ($rec->{mic}) {
                next if $se_by_primary_code{$_};
                $code_occurrences{$_}++;
                $se_by_code{$_} = $rec;
            }

            # yahoo finance codes
            if (length $rec->{yf_code}) {
                for ($rec->{yf_code}) {
                    next if $se_by_primary_code{$_};
                    $code_occurrences{$_}++;
                    $se_by_code{$_} = $rec;
                }
                if (length $rec->{add_yf_codes}) {
                    for (split /;/, $rec->{add_yf_codes}) {
                        next if $se_by_primary_code{$_};
                        $code_occurrences{$_}++;
                        $se_by_code{$_} = $rec;
                    }
                }
            }

            # additional codes
            if (length $rec->{add_codes}) {
                for (split /;/, $rec->{add_codes}) {
                    next if $se_by_primary_code{$_};
                    $code_occurrences{$_}++;
                    $se_by_code{$_} = $rec;
                }
            }

            # additional names
            if (length $rec->{add_names}) {
                for (split /;/, lc $rec->{add_names}) {
                    next if $se_by_primary_name_lc{$_};
                    $name_occurrences{$_}++;
                    $se_by_name_lc{$_} = $rec;
                }
            }
        }

    }
    bless {}, $class;
}

sub by_code {
    my ($self, $code) = @_;
    $code = uc($code);
    die "Can't find stock exchange with code '$code'"
        unless my $rec = $se_by_code{$code};
    die "Ambiguous stock exchange code '$code' (refers to multiple exchanges)"
        unless $code_occurrences{$code} == 1;
    $rec;
}

sub by_name {
    my ($self, $name) = @_;
    $name = lc $name;
    die "Can't find stock exchange with name '$name'"
        unless my $rec = $se_by_name_lc{$name};
    die "Ambiguous stock exchange name '$name' (refers to multiple exchanges)"
        unless $name_occurrences{$name} == 1;
    $rec;
}

sub all_codes {
    my $self = shift;
    my @res;
    for (@$data) {
        push @res, $_->{code};
    }
    @res;
}

sub all_data {
    my $self = shift;
    @$data;
}

1;
# ABSTRACT: Catalog (list) of stock exchanges

=head1 SYNOPSIS

 use Finance::SE::Catalog;

 my $cat = Finance::SE::Catalog->new;

 my $record = $cat->by_code("IDX");                      # => { code=>"IDX", mic=>"XIDX", eng_name=>"Indonesia Stock Exchange", ...}
 my $record = $cat->by_code("BEI");                      # can also search by MIC or additional codes
 my $record = $cat->by_name("Indonesia Stock Exchange"); # note: case-sensitive

 my @codes = $cat->all_codes(); # => ("NYSE", "NASDAQ", "IDX", ...) # only primary code

 my @data = $cat->all_data; # => ({code=>"IDX", mic=>"XIDX", ...}, {...}, ...)


=head1 DESCRIPTION

B<STATUS: Very incomplete. I currently focus only on markets supported by Yahoo!
Finance, and even from that subset I currently have only included a few.>

This class attempts to provide a list/catalog of stock exchanges around the
world.


=head1 METHODS

=head2 new

=head2 by_code

=head2 by_name

=head2 all_codes

=head2 all_data


=head1 SEE ALSO

C<Finance::SE::*> modules, e.g. L<Finance::SE::IDX>.

=cut
