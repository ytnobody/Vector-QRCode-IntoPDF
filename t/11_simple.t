use strict;
use utf8;
use Test::More;
use Vector::QRCode::IntoPDF;
use File::Spec;
use File::Temp 'tempdir';
use Digest::SHA 'sha256_hex';

my $tmpdir = tempdir(CLEANUP => 1);
my $src_pdf_file = File::Spec->catfile(qw/t data dummy.pdf/);
my $dst_pdf_file = File::Spec->catfile($tmpdir, 'result.pdf');

my $obj = Vector::QRCode::IntoPDF->new(pdf_file => $src_pdf_file);

isa_ok $obj->pdf, 'PDF::API2';

$obj->imprint(
    page => 1,
    x    => 213,
    y    => 250,
    text => '退学失敗',
    size => 6,
    unit => 'cm',
);

$obj->save($dst_pdf_file);

open my $fh, $dst_pdf_file or die $!;
my $pdf_data = do{local $/; <$fh>};
close $fh;

is sha256_hex($pdf_data), '42ce539e66d8c2e703c56973a60160e980e5c48cc453dcbc5f1f1b9623ca2413';

done_testing;
