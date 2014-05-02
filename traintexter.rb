class StatusGather #parse data & gather train status

end

DATABASE_NAME = 'TextSchedule'

class TextSchedule #database of times/trains/user phone #s

  def initialize
    require 'pg'

    ignore_errors = "/dev/null 2>&1"
    `createdb #{DATABASE_NAME} #{ignore_errors}`

    @db_connection = PG.connect( dbname: DATABASE_NAME )
    @db_connection.exec("drop table if exists users;")
    @db_connection.exec("drop table if exists trains;")
    @db_connection.exec("drop table if exists times;")
    @db_connection.exec("drop table if exists users_times;")
    @db_connection.exec("drop table if exists users_trains;")

    #TABLE USERS:
    #--------------------------
    @db_connection.exec(<<-SQL
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
      %w[Mario +18185364199],
      %w[Isabel +17724869106],
      %w[Zach +12127293997],
      ].each do |record|

      @db_connection.exec(<<-SQL
        insert into users(name, phone)
        values ( '#{record.join("','")}' )
        returning user_id;
        SQL
      )

    end

    results = @db_connection.exec(<<-SQL
      select * from users;
      SQL
      )
    p results.values

    #TABLE TRAINS:
    #---------------------------------------
    @db_connection.exec(<<-SQL
      create table trains
      (
        train_id  serial primary key,
        name        varchar(255)
      );
      SQL
    )

    ["ACE", "BDFM", "L", "123", "456", "NQR", "7", "G", "JZ", "S"].each do |record|

      @db_connection.exec(<<-SQL
        insert into trains(name)
        values ( '#{record}' );
        SQL
      )

    end

    results = @db_connection.exec(<<-SQL
      select * from trains ;
      SQL
      )
    p results.values


    #TABLE TIMES:
    #---------------------------------------
    @db_connection.exec(<<-SQL
      create table times
      (
        time_id    serial primary key,
        time       time
      );
      SQL
    )

    ["08:00","12:00","06:00","19:00","14:00","02:00"].each do |record|

      @db_connection.exec(<<-SQL
        insert into times(time)
        values ( '#{record}' );
        SQL
      )

    end

    results = @db_connection.exec(<<-SQL
      select * from times ;
      SQL
      )
    p results.values



    #TABLE USERS_TIMES:
    #---------------------------------------
    @db_connection.exec(<<-SQL
      create table users_times
      (
        user_time_id serial primary key,
        user_id      int,
        time_id      int
      );
      SQL
    )

    6.times do
      user_id = (1..4).to_a.sample
      time_id = (1..6).to_a.sample
      @db_connection.exec("
        insert into users_times(user_id, time_id)
        values (#{user_id},#{time_id} );
        "
      )
    end

    results = @db_connection.exec(<<-SQL
      select * from users_times ;
      SQL
      )
    p results.values


    #TABLE USERS_TRAINS:
    #---------------------------------------
    @db_connection.exec(<<-SQL
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
      @db_connection.exec("
        insert into users_trains(user_id, train_id)
        values (#{user_id},#{train_id} );
        "
      )
    end

    results = @db_connection.exec(<<-SQL
      select * from users_trains ;
      SQL
      )
    p results.values


  end

  def test_db_query
    names_with_time = @db_connection.exec(<<-SQL
      SELECT phone,trains.name FROM users
      JOIN users_times ON users.user_id=users_times.user_id
      JOIN times ON times.time_id=users_times.time_id
      JOIN users_trains ON users.user_id=users_trains.user_id
      JOIN trains ON trains.train_id=users_trains.train_id
      WHERE times.time = '08:00:00'
      SQL
    )

    names_with_time.values
  end

end

test = TextSchedule.new
p test.test_db_query

class TextSender #sends texts to user

end

