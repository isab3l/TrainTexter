class StatusGather #parse data & gather train status

end

class TextSchedule #database of times/trains/user phone #s

DATABASE_NAME = 'TextSchedule'
require 'pg'

ignore_errors = "/dev/null 2>&1"
`createdb #{DATABASE_NAME} #{ignore_errors}`

db_connection = PG.connect( dbname: DATABASE_NAME )
db_connection.exec("drop table if exists users;")
db_connection.exec("drop table if exists trains;")
db_connection.exec("drop table if exists times;")
db_connection.exec("drop table if exists users_times;")
db_connection.exec("drop table if exists users_trains;")

#TABLE 1:
#--------------------------
db_connection.exec(<<-SQL
  create table users
  (
    user_id  serial primary key,
    name        varchar(255),
    phone       varchar(200)
  );
  SQL
)

[
  %w[Alex 0000000000],
  %w[Mario 8185364199],
  %w[Isabel 7724869106],
  %w[Zach 0000000000],
  ].each do |record|

  db_connection.exec(<<-SQL
    insert into users(name, phone)
    values ( '#{record.join("','")}' )
    returning user_id;
    SQL
  )

end

results = db_connection.exec(<<-SQL
  select * from users;
  SQL
  )
p results.values

#TABLE 2:
#---------------------------------------
db_connection.exec(<<-SQL
  create table trains
  (
    train_id  serial primary key,
    name        varchar(255)
  );
  SQL
)

["ACE", "BDFM", "L", "123", "456", "NQR", "7", "G", "JZ", "S"].each do |record|

  db_connection.exec(<<-SQL
    insert into trains(name)
    values ( '#{record}' );
    SQL
  )

end

results = db_connection.exec(<<-SQL
  select * from trains ;
  SQL
  )
p results.values


#TABLE 3:
#---------------------------------------
db_connection.exec(<<-SQL
  create table times
  (
    time_id    serial primary key,
    time       time
  );
  SQL
)

["08:00","12:00","06:00","19:00","14:00","02:00"].each do |record|

  db_connection.exec(<<-SQL
    insert into times(time)
    values ( '#{record}' );
    SQL
  )

end

results = db_connection.exec(<<-SQL
  select * from times ;
  SQL
  )
p results.values



#TABLE 4:
#---------------------------------------
db_connection.exec(<<-SQL
  create table users_times
  (
    user_time_id serial primary key,
    user_id      int,
    time_id      int
  );
  SQL
)

# [ %w[1 1],
#   %w[3 4],
#   %w[4 3],
#   %w[2 6],
#   %w[4 2],
#   %w[1 5],
#   %w[3 5]


#   ].each do |record|

#   db_connection.exec(<<-SQL
#     insert into users_times(user_id, time_id)
#     values ( '#{record.join("','")}' );
#     SQL
#   )
# end

6.times do
  user_id = (1..4).to_a.sample
  time_id = (1..6).to_a.sample
  db_connection.exec("
    insert into users_times(user_id, time_id)
    values (#{user_id},#{time_id} );
    "
  )
end

results = db_connection.exec(<<-SQL
  select * from users_times ;
  SQL
  )
p results.values


#TABLE 2:
#---------------------------------------
db_connection.exec(<<-SQL
  create table users_trains
  (
    user_train_id  serial primary key,
    user_id   int,
    train_id  int
  );
  SQL
)


7.times do
  user_id = (1..4).to_a.sample
  train_id = (1..10).to_a.sample
  db_connection.exec("
    insert into users_trains(user_id, train_id)
    values (#{user_id},#{train_id} );
    "
  )
end

results = db_connection.exec(<<-SQL
  select * from users_trains ;
  SQL
  )
p results.values




names_with_time = db_connection.exec(<<-SQL
  SELECT name FROM users
  JOIN users_times ON users.user_id=users_times.user_id
  JOIN times ON times.time_id=users_times.time_id
  WHERE times.time = '08:00:00'
  SQL
)

p names_with_time.values


end

class TextSender #sends texts to user

end

