use strict;
use warnings;
use Test::More;


use Catalyst::Test 'ToDo';
use ToDo::Controller::User;

ok( request('/user')->is_success, 'Request should succeed' );
done_testing();
