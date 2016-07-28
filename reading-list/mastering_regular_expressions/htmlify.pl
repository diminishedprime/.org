undef $/;   # Enter "file-slurp" mode.

# the qr operator converts the following regex into a 'regex object'
$HostnameRegex = qr/[-a-z0-9]+(\.[-a-z0-9]+)*\.(com|edu|info)/i;

$text = <>; # Slurp up the first file given on the command line.

$text =~ s/&/&amp;/g; # Make the basic HTML
$text =~ s/</&lt;/g;  # characters &, <, and >
$text =~ s/>/&gt;/g;  # HTML safe.

$text =~ s/^\s*$/<p>/mg; # Separate paragraphs.

# Turn email address into links
$text =~ s{
    \b
    # Capture the address to $1
    (
     \w[-.\w]*                                 # username
     \@
     $HostnameRegex
    )
    \b
    }{<a href="mailto:$1">$1</a>}gix;

#Turn HTTP URLs into links
$text =~ s{
    \b
    # Capture the URL to $1
    (
     http:// $HostnameRegex \b
     (
      / [-a-z0-9_:\@&?=+,.!/~*'%\$]*                       # optional path
        (?<![.,?!]) # Not allowed to end with [.,?!]
     )?
    )
}{<a href="$1">$1</a>}gix;

print $text
