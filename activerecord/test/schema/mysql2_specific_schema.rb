ActiveRecord::Schema.define do

  if ActiveRecord::Base.connection.version >= '5.6.0'
    create_table :datetime_defaults, force: true do |t|
      t.datetime :modified_datetime, default: -> { 'CURRENT_TIMESTAMP' }
    end
  end

  create_table :binary_fields, force: true do |t|
    t.binary :var_binary, limit: 255
    t.binary :var_binary_large, limit: 4095
    t.tinyblob   :tiny_blob
    t.blob       :normal_blob
    t.mediumblob :medium_blob
    t.longblob   :long_blob
    t.tinytext   :tiny_text
    t.text       :normal_text
    t.mediumtext :medium_text
    t.longtext   :long_text

    t.index :var_binary
  end

  create_table :key_tests, force: true, :options => 'ENGINE=MyISAM' do |t|
    t.string :awesome
    t.string :pizza
    t.string :snacks
  end

  add_index :key_tests, :awesome, :type => :fulltext, :name => 'index_key_tests_on_awesome'
  add_index :key_tests, :pizza, :using => :btree, :name => 'index_key_tests_on_pizza'
  add_index :key_tests, :snacks, :name => 'index_key_tests_on_snack'

  create_table :collation_tests, id: false, force: true do |t|
    t.string :string_cs_column, limit: 1, collation: 'utf8_bin'
    t.string :string_ci_column, limit: 1, collation: 'utf8_general_ci'
  end

  ActiveRecord::Base.connection.execute <<-SQL
DROP PROCEDURE IF EXISTS ten;
SQL

  ActiveRecord::Base.connection.execute <<-SQL
CREATE PROCEDURE ten() SQL SECURITY INVOKER
BEGIN
	select 10;
END
SQL

  ActiveRecord::Base.connection.execute <<-SQL
DROP PROCEDURE IF EXISTS topics;
SQL

  ActiveRecord::Base.connection.execute <<-SQL
CREATE PROCEDURE topics(IN num INT) SQL SECURITY INVOKER
BEGIN
  select * from topics limit num;
END
SQL

  ActiveRecord::Base.connection.drop_table "enum_tests", if_exists: true

  ActiveRecord::Base.connection.execute <<-SQL
CREATE TABLE enum_tests (
  enum_column ENUM('text','blob','tiny','medium','long','unsigned')
)
SQL
end
