use strict;
use warnings;
use Test::More;


use Catalyst::Test 'ToDo';
use ToDo::Controller::Task::Add;

ok( request('/task/add')->is_success, 'Request should succeed' );
done_testing();
