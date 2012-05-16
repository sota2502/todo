package ToDo::Schema::Result::Task;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use base 'DBIx::Class::Core';

__PACKAGE__->load_components("InflateColumn::DateTime");

=head1 NAME

ToDo::Schema::Result::Task

=cut

__PACKAGE__->table("task");

=head1 ACCESSORS

=head2 task_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 user_id

  data_type: 'integer'
  is_nullable: 0

=head2 title

  data_type: 'varchar'
  is_nullable: 1
  size: 40

=head2 description

  data_type: 'text'
  is_nullable: 1

=head2 status

  data_type: 'tinyint'
  default_value: 0
  is_nullable: 1
  size: 3

=head2 created_at

  data_type: 'timestamp'
  is_nullable: 1

=head2 updated_at

  data_type: 'timestamp'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "task_id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "user_id",
  { data_type => "integer", is_nullable => 0 },
  "title",
  { data_type => "varchar", is_nullable => 1, size => 40 },
  "description",
  { data_type => "text", is_nullable => 1 },
  "status",
  { data_type => "tinyint", default_value => 0, is_nullable => 1, size => 3 },
  "created_at",
  { data_type => "timestamp", is_nullable => 1 },
  "updated_at",
  { data_type => "timestamp", is_nullable => 1 },
);
__PACKAGE__->set_primary_key("task_id");


# Created by DBIx::Class::Schema::Loader v0.07002 @ 2012-05-16 23:48:09
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:WJKK9yHtp/+RiGo2m1oJOg


# You can replace this text with custom content, and it will be preserved on regeneration
1;
