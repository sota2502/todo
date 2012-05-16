use strict;
use warnings;
use Test::More;


use Catalyst::Test 'ToDo';
use ToDo::Controller::Task;

ok( request('/task')->is_success, 'Request should succeed' );
done_testing();
