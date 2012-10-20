package MT::Plugin::OMV::StopWatch;
#   MTStopWatch - Measure the elapsed time along building process
#   @see http://www.magicvox.net/
#           Programmed by Piroli YUKARINOMIYA (MagicVox)
#           Open MagicVox.net - http://www.magicvox.net/home.php
#   $Id$

use strict;
use MT::Template::Context;

use vars qw( $VENDOR $MYNAME $VERSION );
($VENDOR, $MYNAME) = (split /::/, __PACKAGE__)[-2, -1];
(my $revision = '$Rev$') =~ s/\D//g;
$VERSION = '0.11'. ($revision ? ".$revision" : '');

### Register plugin
if (MT->can ('add_plugin')) {
    require MT::Plugin;
    my $plugin = MT::Plugin->new;
    $plugin->name ("${MYNAME} ver.${VERSION}");
    $plugin->description (<<HTMLHEREDOC);
Measure the elapsed time along building process.
HTMLHEREDOC
    $plugin->doc_link ('http://www.magicvox.net/');
    MT->add_plugin ($plugin);
}

### Enable the high-resolution time function, if you can.
eval {
    use Time::HiRes qw( time );
};

### $MTStopWatch$
MT::Template::Context->add_tag (StopWatch => \&stop_watch);
sub stop_watch {
    my ($ctx, $args, $cond) = @_;

    ### Start a measurement in the slot specified by 'start'
    if (defined (my $arg_start = $args->{'start'})) {
        $ctx->{__stash}{__PACKAGE__. $arg_start} = time ();
        return '';
    }

    ### Calculate the elapsed time since MTStopWatch tag appeared with 'start' arguments.
    ### @see also http://www.sixapart.jp/movabletype/manual/3.3/b_global_filters/#sprintf
    if (defined (my $arg_stop = $args->{'stop'})) {
        if (defined (my $start_time = $ctx->{__stash}{__PACKAGE__. $arg_stop})) {
            return (time () - $start_time) * ($args->{'magnify'} || 1);
        }
    }

    return '';
}

1;