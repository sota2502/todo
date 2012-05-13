package ToDo::Schema::Result::User;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use base 'DBIx::Class::Core';

__PACKAGE__->load_components("InflateColumn::DateTime");

=head1 NAME

ToDo::Schema::Result::User

=cut

__PACKAGE__->table("user");

=head1 ACCESSORS

=head2 user_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 password

  data_type: 'char'
  is_nullable: 1
  size: 40

=head2 email

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=cut

__PACKAGE__->add_columns(
  "user_id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "password",
  { data_type => "char", is_nullable => 1, size => 40 },
  "email",
  { data_type => "varchar", is_nullable => 1, size => 255 },
);
__PACKAGE__->set_primary_key("user_id");
__PACKAGE__->add_unique_constraint("email_unique", ["email"]);


# Created by DBIx::Class::Schema::Loader v0.07002 @ 2012-05-10 23:41:38
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:iZjiwj2nYu6G4PJPLzjr8w


# You can replace this text with custom content, and it will be preserved on regeneration
1;
