use ExtUtils::MakeMaker;

WriteMakefile(
    'NAME'		=> 'Apache::Chameleon',
    'VERSION_FROM'	=> 'lib/Apache/Chameleon.pm',
    'PREREQ_PM'		=> { 
                             Apache => undef,
                             Apache::Cookie => undef,
                             Apache::Log => undef,
                             Apache::libapreq => undef,
                             Apache::Request => undef,
                             Apache::FakeRequest => undef,
                             Class::DBI => 0.36,
                             Class::DBI::FromCGI => 0.9,
                             Class::DBI::mysql => 0.13,
                             CGI::Untaint => 0.83,
                             CGI::Untaint::date => 0.03,
                             CGI::Untaint::email => 0.03,
                             Digest::MD5 => undef,
                             Mail::Send => undef,
                             Template => 2.06,
                             Test::Simple => 0.42,
                           },
    ($] >= 5.005 ?
      (
       AUTHOR     => 
       'Russell Matbouli <apache-chameleon-makefile@russell.matbouli.org>'
      ) : ()),
);
